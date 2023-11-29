# import config.
# you can change the default config with `make cnf="config_special.env" build`

cnf ?= .env
ifneq ("$(wildcard $(cnf))","")
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))
endif

cur_date = $(shell date '+%Y-%m-%d-%H-%M-%S')

# Make will use bash instead of sh
SHELL := /usr/bin/env bash
ifdef CICD_MODE
SHELL := /usr/bin/env sh
endif

# Interactive mode
NON_INTERACTIVE ?= 0

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[-a-zA-Z0-9\._]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# Name of the output of the terraform plan
# Name of the output of the terraform plan
PLAN_BINARY_FILE=tfplan.binary
PLAN_JSON_FILE=tfplan.json

# Select the config file based of the stage
CONFIG_FILE := parameters.auto.tfvars
VAR_PARAMETERS := -var-file=../common.tfvars -var-file=${CONFIG_FILE} -var="module_path=${CURRENT_DIR}"

DOCKER_COMPOSE_FILES = -f docker-compose.yml
DOCKER_COMPOSE_FILES_TOOLS = -f docker-compose-tools.yml

DOCKER_COMPOSE = docker compose ${DOCKER_COMPOSE_FILES}
DOCKER_COMPOSE_DEV_TOOLS = docker compose ${DOCKER_COMPOSE_FILES_TOOLS}

ifdef CICD_MODE
	ROLE_NAME := ${CICD_ROLE_NAME}
else
	ROLE_NAME := ${LOCAL_ROLE_NAME}
endif

ifdef TF_VAR_backend_bucket_name
	TERRAFORM_INIT_BACKEND_CONFIG_BUCKET = -backend-config="bucket=${TF_VAR_backend_bucket_name}"
endif

ifdef TF_VAR_backend_bucket_region
	TERRAFORM_INIT_BACKEND_CONFIG_REGION = -backend-config="region=${TF_VAR_backend_bucket_region}"
endif

ifdef TF_VAR_backend_dynamodb_table
	TERRAFORM_INIT_BACKEND_CONFIG_DYNAMO_TABLE = -backend-config="dynamodb_table=${TF_VAR_backend_dynamodb_table}"
endif

ifdef TF_VAR_backend_bucket_access_role
	TERRAFORM_INIT_BACKEND_CONFIG_ROLE_ARN = -backend-config="role_arn=${TF_VAR_backend_bucket_access_role}"
endif

ifdef CUSTOM_BACKEND_BUCKET_KEY
	TERRAFORM_INIT_BACKEND_CONFIG_KEY = -backend-config="key=${PROJECT_NAME}${subst terraform,,$(CURRENT_DIR)}.tfstate"
endif

TERRAFORM_INIT = init --upgrade $(TERRAFORM_INIT_BACKEND_CONFIG_BUCKET) $(TERRAFORM_INIT_BACKEND_CONFIG_REGION) $(TERRAFORM_INIT_BACKEND_CONFIG_DYNAMO_TABLE) $(TERRAFORM_INIT_BACKEND_CONFIG_ROLE_ARN) $(TERRAFORM_INIT_BACKEND_CONFIG_KEY)

ifdef CICD_MODE
	TFENV_EXEC ?= $(shell which tfenv)
	TERRAFORM_EXEC ?= $(shell which terraform)
	TFLINT_RUN ?= $(shell which tflint) --config $(shell pwd)/.config/.tflint.hcl
	PRECOMMIT_RUN ?= $(shell which pre-commit)
	DOTENV_LINTER ?= $(shell which dotenv-linter)
	SHELL_LINT ?= $(shell which shellcheck)
	YAML_LINT ?= $(shell which yamllint)
	MD_LINT ?= $(shell which mdl) --style .config/.mdl_style.rb
	TRIVY_RUN ?= $(shell which trivy)
	TERRASCAN_RUN ?= $(shell which terrascan)
	TERRAFORM_DOCS ?= $(shell which terraform-docs)
else
	TFENV_EXEC = $(DOCKER_COMPOSE) exec terraform
	TERRAFORM_EXEC = $(DOCKER_COMPOSE) exec terraform
	TFLINT_RUN = $(DOCKER_COMPOSE_DEV_TOOLS) run --rm lint --config /workdir/.config/.tflint.hcl
	PRECOMMIT_RUN = $(DOCKER_COMPOSE_DEV_TOOLS) run --rm precommit
	DOTENV_LINTER = $(DOCKER_COMPOSE_DEV_TOOLS) run --rm dotenv-linter
	SHELL_LINT = $(DOCKER_COMPOSE_DEV_TOOLS) run --rm shell_lint shellcheck
	YAML_LINT = $(DOCKER_COMPOSE_DEV_TOOLS) run --rm yaml_lint yamllint
	MD_LINT = $(DOCKER_COMPOSE_DEV_TOOLS) run --rm markdown_lint mdl --style ./.config/.mdl_style.rb
	TRIVY_RUN = $(DOCKER_COMPOSE_DEV_TOOLS) run --rm trivy
	TERRASCAN_RUN  = $(DOCKER_COMPOSE_DEV_TOOLS) run --rm terrascan
	TERRAFORM_DOCS = $(DOCKER_COMPOSE_DEV_TOOLS) run --rm terraform-docs
endif

debug: ## Print debug logs
debug:
ifeq ($(PRINT_DEBUG),"true")
	printenv
	echo $(TFENV_EXEC)
	echo $(TERRAFORM_EXEC)
	echo $(TFLINT_RUN)
	echo $(PRECOMMIT_RUN)
endif

CONFIG_FILE := parameters.auto.tfvars
ifdef CICD_MODE
	VAR_PARAMETERS := -var-file=$(shell pwd)/terraform/common.tfvars \
		-var-file=${CONFIG_FILE} \
		-var="module_path=${CURRENT_DIR}" \
		#-var="backend_bucket_key=${CURRENT_DIR}"
else
	VAR_PARAMETERS := -var-file=${DOCKER_WORKDIR}/terraform/common.tfvars \
		-var-file=${CONFIG_FILE} \
		-var="module_path=${CURRENT_DIR}" \
		#-var="backend_bucket_key=${CURRENT_DIR}"
endif

########################################################################################################################
#  FUNCTIONS
########################################################################################################################
terraform_check_version_commands:
ifndef CICD_MODE
	$(DOCKER_COMPOSE_DEV_TOOLS) run terraform_version_check /workdir/${CURRENT_DIR}
endif

console_commands:
ifndef CICD_MODE
	$(TFENV_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && tfenv install"
	$(DOCKER_COMPOSE) exec -w ${DOCKER_WORKDIR}/${CURRENT_DIR} terraform /bin/sh
endif

terraform_validate:
ifdef CICD_MODE
	cd ${CURRENT_DIR} && tfenv install
	cd ${CURRENT_DIR} && terraform validate
else
	$(TFENV_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && tfenv install"
	$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && terraform validate"
endif

terraform_format:
ifdef CICD_MODE
	cd ${CURRENT_DIR} && $(TFENV_EXEC) install
	cd ${CURRENT_DIR} && terraform fmt -recursive
else
	$(TFENV_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && tfenv install"
	$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && terraform fmt -recursive"
endif

# Combination of Terraform commands to install a stack layer
terraform_install_commands:
ifneq (,$(wildcard ${CURRENT_DIR}/${CONFIG_FILE}))
ifdef CICD_MODE
		cd ${CURRENT_DIR} && tfenv install
		cd ${CURRENT_DIR} && terraform $(TERRAFORM_INIT)
		cd ${CURRENT_DIR} && terraform apply ${PLAN_BINARY_FILE}
else
		$(TFENV_EXEC)  /bin/sh -c "cd ${CURRENT_DIR} && tfenv install"
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && terraform $(TERRAFORM_INIT)"
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && terraform apply -compact-warnings ${VAR_PARAMETERS}"
endif
endif


# Combination of Terraform commands to apply a stack layer
terraform_apply_commands:
ifneq (,$(wildcard ${CURRENT_DIR}/${CONFIG_FILE}))
ifdef CICD_MODE
		cd ${CURRENT_DIR} && tfenv install
		cd ${CURRENT_DIR} && terraform apply ${PLAN_BINARY_FILE}
else
		$(TFENV_EXEC)  /bin/sh -c "cd ${CURRENT_DIR} && tfenv install"
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && terraform apply -compact-warnings ${VAR_PARAMETERS}"
endif
endif

# Combination of Terraform commands to init a stack layer
terraform_init_commands:
ifneq (,$(wildcard ${CURRENT_DIR}/${CONFIG_FILE}))
ifdef CICD_MODE
		cd ${CURRENT_DIR} && tfenv install
		cd ${CURRENT_DIR} && terraform $(TERRAFORM_INIT)
else
		$(TFENV_EXEC)  /bin/sh -c "cd ${CURRENT_DIR} && tfenv install"
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && terraform $(TERRAFORM_INIT)"
endif
endif

# Combination of Terraform commands to plan a stack layer
terraform_plan_commands:
ifneq (,$(wildcard ${CURRENT_DIR}/${CONFIG_FILE}))
ifdef CICD_MODE
		cd ${CURRENT_DIR} && $(TFENV_EXEC) install
		cd ${CURRENT_DIR} && terraform plan ${VAR_PARAMETERS} -out ${PLAN_BINARY_FILE}
		cd ${CURRENT_DIR} && terraform show -json ${PLAN_BINARY_FILE} > ${PLAN_JSON_FILE}
else
		$(TFENV_EXEC)  /bin/sh -c "cd ${CURRENT_DIR} && tfenv install"
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && terraform plan -compact-warnings ${VAR_PARAMETERS} -out ${PLAN_BINARY_FILE}"
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && terraform show -json ${PLAN_BINARY_FILE} > ${PLAN_JSON_FILE}"
endif
endif

terraform_lint:
	$(TFLINT_RUN) --chdir ${CURRENT_DIR}

# Terraform commands to delete a stack layer
terraform_destroy_commands:
ifneq (,$(wildcard ${CURRENT_DIR}/${CONFIG_FILE}))
ifdef CICD_MODE
		cd ${CURRENT_DIR} && tfenv install
		cd ${CURRENT_DIR} && terraform destroy ${VAR_PARAMETERS}
else
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && tfenv install"
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && terraform destroy ${VAR_PARAMETERS}"
endif
endif

# Terraform commands to delete a stack layer from a binary plan
terraform_destroyauto_commands:
ifneq (,$(wildcard ${CURRENT_DIR}/${CONFIG_FILE}))
ifdef CICD_MODE
		cd ${CURRENT_DIR} && tfenv install
		cd ${CURRENT_DIR} && terraform apply -destroy ${VAR_PARAMETERS} ${PLAN_BINARY_FILE}
else
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && tfenv install"
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && terraform apply -destroy ${VAR_PARAMETERS} ${PLAN_BINARY_FILE}"
endif
endif

########################################################################################################################
#  LOCAL DEV DOCKER
########################################################################################################################

init: ## Generate .env file
init:
	if [ ! -d .backup ] ; then mkdir .backup ; fi
	if [ -f .env ] ; then   cp .env .backup/.env-${cur_date}.bck ; else touch .env ; fi
	cp configure.yaml automation/jinja2/variables/
	# Hack: use only for first run
	$(DOCKER_COMPOSE_DEV_TOOLS) run -e MY_UID=$(shell id -u) -e MY_GID=$(shell id -g) --rm jinja2docker .env.dist.j2 /variables/configure.yaml
	$(DOCKER_COMPOSE_DEV_TOOLS) run -e MY_UID=$(shell id -u) -e MY_GID=$(shell id -g) --rm jinja2docker .env.dist.j2 /variables/configure.yaml | tee .env

compare_configuration: ## Compare configuration file configure.yaml and configure.yaml.dist
compare_configuration:
	$(DOCKER_COMPOSE_DEV_TOOLS) run -e MY_UID=$(shell id -u) -e MY_GID=$(shell id -g) --rm compare_configuration

generate: ## Generate from template gitlab-ci.yml and Makefile
generate:
	@$(MAKE) init
	@$(MAKE) generate_makefile
	if [ "${GENERATE_GITLAB_CI}" == "True" ]; then "$(MAKE)" generate_gitlab_ci; fi


generate_makefile: ## Generate Makefile
generate_makefile:
	if [ ! -d .backup ] ; then mkdir .backup ; fi
	cp Makefile .backup/Makefile-${cur_date}.bck
	# Hack: use only for first run
	$(DOCKER_COMPOSE_DEV_TOOLS) run --rm jinja2docker make.mk.j2 /variables/vars.yml
	$(DOCKER_COMPOSE_DEV_TOOLS) run --rm jinja2docker make.mk.j2 /variables/vars.yml | tee makeplan.mk
	./automation/Makefile/delete_automatic_content.sh
	cat makeplan.mk >> Makefile

generate_gitlab_ci: ## Generate  GitlabCI
generate_gitlab_ci:
	if [ ! -d .backup ] ; then mkdir .backup ; fi
	if [ -f .gitlab-ci.yml ] ; then cp .gitlab-ci.yml .backup/.gitlab-ci.yml-${cur_date}.bck ; else touch .gitlab-ci.yml ; fi
	cp configure.yaml automation/jinja2/variables/
	$(DOCKER_COMPOSE_DEV_TOOLS) run jinja2docker .gitlab-ci.yml.j2 /variables/configure.yaml | tee .gitlab-ci.yml
	tr -d "\r" < .gitlab-ci.yml>.gitlab-ci.yml.tmp
	mv .gitlab-ci.yml.tmp .gitlab-ci.yml

start: ## Start the project
start: init generate
	$(DOCKER_COMPOSE) up -d
	# $(TERRAFORM_EXEC) apk add --no-cache python3 py3-pip

stop: ## Stop the project
stop:
	$(DOCKER_COMPOSE) stop

down: ## stop containers
down:
	$(DOCKER_COMPOSE) down -v

kill: ## Destroy all containers
kill:
	$(DOCKER_COMPOSE) kill
	$(DOCKER_COMPOSE) down --volumes --remove-orphans

console: ## Connect Terraform Docker
console:
	$(TERRAFORM_EXEC) /bin/sh

restart: ## Restart the Terraform stack
restart: stop start

logout: ## Remove assumed role
logout:
	rm -f .env

########################################################################################################################
#  QUALITY CHECKS
########################################################################################################################

precommit: ## Launch precommit hooks
precommit:
	$(PRECOMMIT_RUN) run -a --config=./.config/.pre-commit-config.yaml

dotenv_lint: ## Lint dotenv files
dotenv_lint:
	$(DOTENV_LINTER) --skip UnorderedKey --skip LowercaseKey

markdown_lint: ## Lint Markdown files files
markdown_lint:
	echo $(MD_LINT)
	$(MD_LINT) .

shell_lint: ## Lint shell files
shell_lint:
	$(SHELL_LINT) **/*/*.sh

yaml_lint: ## Lint yaml files
yaml_lint:
	$(YAML_LINT) -c ./.config/.yamllintrc  --no-warnings .

terrascan_docker: ## Terrascan Docker
terrascan_docker:
	$(DOCKER_COMPOSE_DEV_TOOLS) run terrascan scan -d automation -i docker --verbose --config-path=./.config/.tetsvcrrascan_config.toml

powershell_lint: ## PowerShell Linter
powershell_lint:
	$(DOCKER_COMPOSE_DEV_TOOLS) run powershell_lint "Invoke-ScriptAnalyzer -Recurse -Path ."

quality-checks: ## run quality checks
quality-checks: dotenv_lint format validate lint precommit markdown_lint shell_lint yaml_lint trivy terrascan_docker terraform_terrascan

########################################################################################################################
#  INSTALL / DELETE PLANS
########################################################################################################################

# Automatic Content Generated

generate_documentation: ## Generate Terraform Documentation
generate_documentation:
	$(DOCKER_COMPOSE_DEV_TOOLS) run --rm --remove-orphans terraform_docs terraform/demo --config=./.config/.terraform-docs.yml
	$(DOCKER_COMPOSE_DEV_TOOLS) run --rm --remove-orphans terraform_docs terraform/demo2 --config=./.config/.terraform-docs.yml

terraform_terrascan: ## Terrascan Terraform
terraform_terrascan:
	$(TERRASCAN_RUN) scan -i terraform --verbose --config-path=./.terrascan_config.toml  --iac-dir=terraform/demo  --iac-dir=terraform/demo2 
format: ## Format all Terraform files using "terraform fmt"
format:
	@$(MAKE) --no-print-directory terraform_format CURRENT_DIR="terraform/demo"
	@$(MAKE) --no-print-directory terraform_format CURRENT_DIR="terraform/demo2"

trivy:  ## Terraform Trivy
trivy:
	$(TRIVY_RUN) config terraform/demo --config=./.config/.trivy.yaml --skip-dirs .terraform
	$(TRIVY_RUN) config terraform/demo2 --config=./.config/.trivy.yaml --skip-dirs .terraform

validate: ## Validate all Terraform files using "terraform validate"
validate:
	@$(MAKE) --no-print-directory terraform_validate CURRENT_DIR="terraform/demo"
	@$(MAKE) --no-print-directory terraform_validate CURRENT_DIR="terraform/demo2"

lint: ## Check that good naming practices are respected in Terraform files (using tflint)
lint:
	$(TFLINT_RUN) --init
	@$(MAKE) --no-print-directory terraform_lint CURRENT_DIR="terraform/demo"
	@$(MAKE) --no-print-directory terraform_lint CURRENT_DIR="terraform/demo2"

console_terraform_demo: ## Connect terraform Docker AWS terraform/demo layer
console_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo console_commands
console_terraform_demo2: ## Connect terraform Docker AWS terraform/demo2 layer
console_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 console_commands

tsvc_terraform_demo: ## Check terraform module version terraform/demo
tsvc_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_check_version_commands
tsvc_terraform_demo2: ## Check terraform module version terraform/demo2
tsvc_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 terraform_check_version_commands

tsvc_all: ## Install all AWS layers
tsvc_all: tsvc_terraform_demo tsvc_terraform_demo2 

tsvc_terraform_demo: ## Check terraform module version terraform/demo
tsvc_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_check_version_commands

tsvc_all: ## Install all AWS layers
tsvc_all: tsvc_terraform_demo 

init_terraform_demo: ## Init AWS terraform/demo layer
init_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_init_commands
init_terraform_demo2: ## Init AWS terraform/demo2 layer
init_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 terraform_init_commands

validate_terraform_demo: ## Validate AWS terraform/demo layer
validate_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_validate
validate_terraform_demo2: ## Validate AWS terraform/demo2 layer
validate_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 terraform_validate

validate_terraform_demo: ## Validate AWS terraform/demo layer
validate_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_validate

validate_terraform_demo: ## Validate AWS terraform/demo layer
validate_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_validate

plan_terraform_demo: ## Plan AWS terraform/demo layer
plan_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_plan_commands
plan_terraform_demo2: ## Plan AWS terraform/demo2 layer
plan_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 terraform_plan_commands

apply_terraform_demo: ## Apply AWS terraform/demo layer
apply_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_apply_commands

install_terraform_demo: ## Install AWS terraform/demo layer
install_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_install_commands
install_terraform_demo2: ## Install AWS terraform/demo2 layer
install_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 terraform_install_commands

destroy_terraform_demo: ## Uninstall AWS terraform/demo layer
destroy_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_destroy_commands
destroy_terraform_demo2: ## Uninstall AWS terraform/demo2 layer
destroy_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 terraform_destroy_commands

destroyauto_terraform_demo: ## Uninstall AWS terraform/demo layer automatically
destroyauto_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_destroyauto_commands

init_all: ## Init all AWS layers
init_all:
	@$(MAKE) --no-print-directory init_terraform_demo
	@$(MAKE) --no-print-directory init_terraform_demo2

plan_all: ## Plan all AWS layers
plan_all:
	@$(MAKE) --no-print-directory plan_terraform_demo
	@$(MAKE) --no-print-directory plan_terraform_demo2

install_all: ## Install all AWS layers
install_all: install_terraform_demo install_terraform_demo2 

destroy_all: ## Uninstall all layers
destroy_all: destroy_terraform_demo2 destroy_terraform_demo 