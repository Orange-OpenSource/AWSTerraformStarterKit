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

TERRAFORM_UPGRADE_FLAG ?= --upgrade
DEFAULT_TERRAFORM_INIT_PARAMETERS = $(TERRAFORM_UPGRADE_FLAG) $(TERRAFORM_INIT_BACKEND_CONFIG_BUCKET) $(TERRAFORM_INIT_BACKEND_CONFIG_REGION) $(TERRAFORM_INIT_BACKEND_CONFIG_DYNAMO_TABLE) $(TERRAFORM_INIT_BACKEND_CONFIG_ROLE_ARN) $(TERRAFORM_INIT_BACKEND_CONFIG_KEY)
TERRAFORM_INIT_PARAMETERS ?= $(DEFAULT_TERRAFORM_INIT_PARAMETERS)
TERRAFORM_INIT := init $(TERRAFORM_INIT_PARAMETERS)

#### global variables ####
TFLINT_CONFIG ?= $(DEFAULT_TFLINT_CONFIG)
PRECOMMIT_CONFIG ?= $(DEFAULT_PRECOMMIT_CONFIG)
SHELLCHECK_CONFIG ?= $(DEFAULT_SHELLCHECK_CONFIG)
YAMLLINT_CONFIG ?= $(DEFAULT_YAMLLINT_CONFIG)
MARKDOWNLINT_CONFIG ?= $(DEFAULT_MARKDOWNLINT_CONFIG)
TRIVY_CONFIG ?= $(DEFAULT_TRIVY_CONFIG)
TERRASCAN_CONFIG ?= $(DEFAULT_TERRASCAN_CONFIG)
TERRAFORM_DOCS_CONFIG ?= $(DEFAULT_TERRAFORM_DOCS_CONFIG)

ifdef CICD_MODE
	TFENV_EXEC ?= $(shell which tfenv)
	TERRAFORM_EXEC ?= $(shell which terraform)
	TFLINT_RUN ?= $(shell which tflint) --config $(TFLINT_CONFIG)
	PRECOMMIT_RUN ?= $(shell which pre-commit)
	DOTENV_LINTER ?= $(shell which dotenv-linter)
	SHELL_LINT ?= $(shell which shellcheck)
	YAML_LINT ?= $(shell which yamllint)
	MD_LINT ?= $(shell which mdl) --style $(MARKDOWNLINT_CONFIG)
	TRIVY_RUN ?= $(shell which trivy)
	TERRASCAN_RUN ?= $(shell which terrascan)
	TERRAFORM_DOCS ?= $(shell which terraform-docs)
	SCOUTSUITE_EXEC ?= $(shell which scout)
else
	TFENV_EXEC = $(DOCKER_COMPOSE) exec terraform
	TERRAFORM_EXEC = $(DOCKER_COMPOSE) exec terraform
	TFLINT_RUN = $(DOCKER_COMPOSE_DEV_TOOLS) run --rm lint --config ${DOCKER_WORKDIR}/$(TFLINT_CONFIG)
	PRECOMMIT_RUN = $(DOCKER_COMPOSE_DEV_TOOLS) run --rm precommit
	DOTENV_LINTER = $(DOCKER_COMPOSE_DEV_TOOLS) run --rm dotenv-linter
	SHELL_LINT = $(DOCKER_COMPOSE_DEV_TOOLS) run --rm shell_lint shellcheck
	YAML_LINT = $(DOCKER_COMPOSE_DEV_TOOLS) run --rm yaml_lint yamllint
	MD_LINT = $(DOCKER_COMPOSE_DEV_TOOLS) run --rm markdown_lint mdl --style ./$(MARKDOWNLINT_CONFIG)
	TRIVY_RUN = $(DOCKER_COMPOSE_DEV_TOOLS) run --rm trivy
	TERRASCAN_RUN  = $(DOCKER_COMPOSE_DEV_TOOLS) run --rm terrascan
	TERRAFORM_DOCS = $(DOCKER_COMPOSE_DEV_TOOLS) run --rm terraform_docs
	SCOUTSUITE_EXEC ?= $(DOCKER_COMPOSE_DEV_TOOLS) run --rm scoutsuite
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

TERRAFORM_VAR_PARAMETERS ?= $(VAR_PARAMETERS) ${ADDITIONAL_VAR_PARAMETERS}

########################################################################################################################
#  FUNCTIONS
########################################################################################################################
terraform_check_version_commands:
ifndef CICD_MODE
	$(DOCKER_COMPOSE_DEV_TOOLS) run terraform_version_check /${DOCKER_WORKDIR}/${CURRENT_DIR}
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
ifdef CICD_MODE
		cd ${CURRENT_DIR} && tfenv install
		cd ${CURRENT_DIR} && terraform $(TERRAFORM_INIT)
		cd ${CURRENT_DIR} && terraform apply ${PLAN_BINARY_FILE}
else
		$(TFENV_EXEC)  /bin/sh -c "cd ${CURRENT_DIR} && tfenv install"
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && terraform $(TERRAFORM_INIT)"
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && terraform apply -compact-warnings ${TERRAFORM_VAR_PARAMETERS}"
endif

# Combination of Terraform commands to apply a stack layer
terraform_apply_commands:
ifdef CICD_MODE
		cd ${CURRENT_DIR} && tfenv install
		cd ${CURRENT_DIR} && terraform apply ${PLAN_BINARY_FILE}
else
		$(TFENV_EXEC)  /bin/sh -c "cd ${CURRENT_DIR} && tfenv install"
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && terraform apply -compact-warnings ${TERRAFORM_VAR_PARAMETERS}"
endif

# Combination of Terraform commands to init a stack layer
terraform_init_commands:
ifdef CICD_MODE
		cd ${CURRENT_DIR} && tfenv install
		cd ${CURRENT_DIR} && terraform $(TERRAFORM_INIT)
else
		$(TFENV_EXEC)  /bin/sh -c "cd ${CURRENT_DIR} && tfenv install"
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && terraform $(TERRAFORM_INIT)"
endif

# Combination of Terraform commands to plan a stack layer
terraform_plan_commands:
ifdef CICD_MODE
		cd ${CURRENT_DIR} && $(TFENV_EXEC) install
		cd ${CURRENT_DIR} && terraform plan ${TERRAFORM_VAR_PARAMETERS} -out ${PLAN_BINARY_FILE}
		cd ${CURRENT_DIR} && terraform show -json ${PLAN_BINARY_FILE} > ${PLAN_JSON_FILE}
else
		$(TFENV_EXEC)  /bin/sh -c "cd ${CURRENT_DIR} && tfenv install"
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && terraform plan -compact-warnings ${TERRAFORM_VAR_PARAMETERS} -out ${PLAN_BINARY_FILE}"
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && terraform show -json ${PLAN_BINARY_FILE} > ${PLAN_JSON_FILE}"
endif

terraform_lint:
	$(TFLINT_RUN) --chdir ${CURRENT_DIR}

# Terraform commands to delete a stack layer
terraform_destroy_commands:
ifdef CICD_MODE
		cd ${CURRENT_DIR} && tfenv install
		cd ${CURRENT_DIR} && terraform destroy ${PLAN_BINARY_FILE}
else
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && tfenv install"
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && terraform destroy ${TERRAFORM_VAR_PARAMETERS}"
endif

# Terraform commands to delete a stack layer from a binary plan
terraform_destroyauto_commands:
ifdef CICD_MODE
		cd ${CURRENT_DIR} && tfenv install
		cd ${CURRENT_DIR} && terraform apply -destroy ${TERRAFORM_VAR_PARAMETERS} ${PLAN_BINARY_FILE}
else
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && tfenv install"
		$(TERRAFORM_EXEC) /bin/sh -c "cd ${CURRENT_DIR} && terraform apply -destroy ${TERRAFORM_VAR_PARAMETERS} ${PLAN_BINARY_FILE}"
endif

# Trivy commands to scan a stack layer
trivy_commands:
	$(TRIVY_RUN) config ${CURRENT_DIR} --config=./$(TRIVY_CONFIG) --skip-dirs .terraform

# Terrascan commands to scan a stack layer
terrascan_commands:
	$(TERRASCAN_RUN) scan -i terraform --verbose --config-path=./$(TERRASCAN_CONFIG)  --iac-dir=${CURRENT_DIR}

# Terraform docs commands for a stack layer
terraform_docs_commands:
	$(TERRAFORM_DOCS) ${CURRENT_DIR} --config=./${TERRAFORM_DOCS_CONFIG}

# markdown lint commands for a stack layer
markdown_lint_commands:
	$(MD_LINT) ${CURRENT_DIR}

# shell lint commands for a stack layer
shell_lint_commands:
	$(SHELL_LINT) $$(find ${CURRENT_DIR} -name "*.sh")

# yaml lint commands for a stack layer
yaml_lint_commands:
	$(YAML_LINT) -c ./$(YAMLLINT_CONFIG)  --no-warnings ${CURRENT_DIR}

scoutsuite:
	$(SCOUTSUITE_EXEC) scout aws --report-dir .scoutesuite-report --no-browser
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
	@$(MAKE) render_templates
	if [ "${GENERATE_GITLAB_CI}" == "True" ]; then "$(MAKE)" generate_gitlab_ci; fi


generate_makefile: ## Generate Makefile
generate_makefile:
	if [ ! -d .backup ] ; then mkdir .backup ; fi
	cp Makefile .backup/Makefile-${cur_date}.bck
	# Hack: use only for first run
	$(DOCKER_COMPOSE_DEV_TOOLS) run --rm jinja2docker make.mk.j2 /variables/configure.yaml
	$(DOCKER_COMPOSE_DEV_TOOLS) run --rm jinja2docker make.mk.j2 /variables/configure.yaml | tee makeplan.mk
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

render_template: ## Render  template
render_template:
	if [ ! -d .backup ] ; then mkdir .backup ; fi
	if [ -f ${TPL_DST} ] ; then mkdir -p .backup/$$(dirname ${TPL_DST}) && cp ${TPL_DST} .backup/${TPL_DST}-${cur_date}.bck ; else touch ${TPL_DST} ; fi
	cp configure.yaml automation/jinja2/variables/
	cp ${TPL_SRC} automation/jinja2/templates/$$(basename ${TPL_SRC})
	$(DOCKER_COMPOSE_DEV_TOOLS) run jinja2docker $$(basename ${TPL_SRC}) /variables/configure.yaml | tee ${TPL_DST}
	tr -d "\r" < ${TPL_DST}>${TPL_DST}.tmp
	mv ${TPL_DST}.tmp ${TPL_DST}

render_templates: ## Render  templates

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
	$(PRECOMMIT_RUN) run -a --config ./$(PRECOMMIT_CONFIG)

dotenv_lint: ## Lint dotenv files
dotenv_lint:
	$(DOTENV_LINTER) --skip UnorderedKey --skip LowercaseKey

markdown_lint: ## DEPRECATED: Lint Markdown files files
markdown_lint:
	echo $(MD_LINT)
	$(MD_LINT) .

shell_lint: ## DEPRECATED: Lint shell files
shell_lint:
	$(SHELL_LINT) **/*/*.sh

yaml_lint: ## DEPRECATED: Lint yaml files
yaml_lint:
	$(YAML_LINT) -c ./$(YAMLLINT_CONFIG)  --no-warnings .

terrascan_docker: ## Terrascan Docker
terrascan_docker:
	$(DOCKER_COMPOSE_DEV_TOOLS) run terrascan scan -d automation -i docker --verbose --config-path=./$(TERRASCAN_CONFIG)

powershell_lint: ## PowerShell Linter
powershell_lint:
	$(DOCKER_COMPOSE_DEV_TOOLS) run powershell_lint "Invoke-ScriptAnalyzer -Recurse -Path ."

quality-checks: ## run quality checks
quality-checks: dotenv_lint format_all validate_all lint_all precommit markdown_lint_all shell_lint_all yaml_lint_all trivy_all terrascan_docker terrascan_all

########################################################################################################################
#  INSTALL / DELETE PLANS
########################################################################################################################

# Automatic Content Generated

generate_documentation: ## DEPRECATED: Generate Terraform Documentation
generate_documentation:
	$(DOCKER_COMPOSE_DEV_TOOLS) run --rm --remove-orphans terraform_docs terraform/demo --config=./${TERRAFORM_DOCS_CONFIG}
	$(DOCKER_COMPOSE_DEV_TOOLS) run --rm --remove-orphans terraform_docs terraform/demo2 --config=./${TERRAFORM_DOCS_CONFIG}
	$(DOCKER_COMPOSE_DEV_TOOLS) run --rm --remove-orphans terraform_docs terraform/demo3 --config=./${TERRAFORM_DOCS_CONFIG}

render_templates: ## Render all templates
render_templates:

terraform_terrascan: ## DEPRECATED: Terrascan Terraform
terraform_terrascan:
	$(TERRASCAN_RUN) scan -i terraform --verbose --config-path=./.terrascan_config.toml  --iac-dir=terraform/demo  --iac-dir=terraform/demo2  --iac-dir=terraform/demo3 
format: ## DEPREATED: Format all Terraform files using "terraform fmt"
format:
	@$(MAKE) --no-print-directory terraform_format CURRENT_DIR="terraform/demo"
	@$(MAKE) --no-print-directory terraform_format CURRENT_DIR="terraform/demo2"
	@$(MAKE) --no-print-directory terraform_format CURRENT_DIR="terraform/demo3"

trivy:  ## DEPRECATED: Terraform Trivy
trivy:
	$(TRIVY_RUN) config terraform/demo --config=./.config/${TRIVY_CONFIG} --skip-dirs .terraform
	$(TRIVY_RUN) config terraform/demo2 --config=./.config/${TRIVY_CONFIG} --skip-dirs .terraform
	$(TRIVY_RUN) config terraform/demo3 --config=./.config/${TRIVY_CONFIG} --skip-dirs .terraform

validate: ## DEPRECATED: Validate all Terraform files using "terraform validate"
validate:
	@$(MAKE) --no-print-directory terraform_validate CURRENT_DIR="terraform/demo"
	@$(MAKE) --no-print-directory terraform_validate CURRENT_DIR="terraform/demo2"
	@$(MAKE) --no-print-directory terraform_validate CURRENT_DIR="terraform/demo3"

lint: ## DEPRECATED: Check that good naming practices are respected in Terraform files (using tflint)
lint:
	$(TFLINT_RUN) --init
	@$(MAKE) --no-print-directory terraform_lint CURRENT_DIR="terraform/demo"
	@$(MAKE) --no-print-directory terraform_lint CURRENT_DIR="terraform/demo2"
	@$(MAKE) --no-print-directory terraform_lint CURRENT_DIR="terraform/demo3"

terraform_docs_terraform_demo: ## Generate terraform/demo layer Terraform Documentation
terraform_docs_terraform_demo:
	@$(MAKE) --no-print-directory terraform_docs_commands CURRENT_DIR="terraform/demo"
terrascan_terraform_demo: ## Terrascan Terraform terraform/demo layer
terrascan_terraform_demo:
	@$(MAKE) --no-print-directory terrascan_commands CURRENT_DIR="terraform/demo"
format_terraform_demo: ## Format terraform/demo layer Terraform files using "terraform fmt"
format_terraform_demo:
	@$(MAKE) --no-print-directory terraform_format CURRENT_DIR="terraform/demo"

trivy_terraform_demo: ## Terraform trivy terraform/demo layer
trivy_terraform_demo:
	@$(MAKE) --no-print-directory trivy_commands CURRENT_DIR=terraform/demo
validate_terraform_demo: ## Validate AWS terraform/demo layer
validate_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_validate

tflint_terraform_demo: ## Terraform code goot practices check with tflint on terraform/demo layer
tflint_terraform_demo:
	@$(MAKE) --no-print-directory terraform_lint CURRENT_DIR=terraform/demo
markdown_lint_terraform_demo: ## Lint Markdown files files on terraform/demo layer
markdown_lint_terraform_demo:
	@$(MAKE) --no-print-directory markdown_lint_commands CURRENT_DIR=terraform/demo
shell_lint_terraform_demo: ## Lint shell files files on terraform/demo layer
shell_lint_terraform_demo:
	@$(MAKE) --no-print-directory shell_lint_commands CURRENT_DIR=terraform/demo
yaml_lint_terraform_demo: ## Lint yaml files files on terraform/demo layer
yaml_lint_terraform_demo:
	@$(MAKE) --no-print-directory yaml_lint_commands CURRENT_DIR=terraform/demo
console_terraform_demo: ## Connect terraform Docker AWS terraform/demo layer
console_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo console_commands

tsvc_terraform_demo: ## Check terraform module version terraform/demo
tsvc_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_check_version_commands

init_terraform_demo: ## Init AWS terraform/demo layer
init_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_init_commands

plan_terraform_demo: ## Plan AWS terraform/demo layer
plan_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_plan_commands

apply_terraform_demo: ## Apply AWS terraform/demo layer
apply_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_apply_commands

install_terraform_demo: ## Install AWS terraform/demo layer
install_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_install_commands

destroy_terraform_demo: ## Uninstall AWS terraform/demo layer
destroy_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_destroy_commands

destroyauto_terraform_demo: ## Uninstall AWS terraform/demo layer automaticaly
destroyauto_terraform_demo:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo terraform_destroyauto_commands
terraform_docs_terraform_demo2: ## Generate terraform/demo2 layer Terraform Documentation
terraform_docs_terraform_demo2:
	@$(MAKE) --no-print-directory terraform_docs_commands CURRENT_DIR="terraform/demo2" TERRAFORM_DOCS_CONFIG=.config/.terraform-docs.yml
terrascan_terraform_demo2: ## Terrascan Terraform terraform/demo2 layer
terrascan_terraform_demo2:
	@$(MAKE) --no-print-directory terrascan_commands CURRENT_DIR="terraform/demo2" TERRASCAN_CONFIG=.config/.terrascan_config.toml
format_terraform_demo2: ## Format terraform/demo2 layer Terraform files using "terraform fmt"
format_terraform_demo2:
	@$(MAKE) --no-print-directory terraform_format CURRENT_DIR="terraform/demo2"

trivy_terraform_demo2: ## Terraform trivy terraform/demo2 layer
trivy_terraform_demo2:
	@$(MAKE) --no-print-directory trivy_commands CURRENT_DIR=terraform/demo2 TRIVY_CONFIG=.config/.trivy.yaml
validate_terraform_demo2: ## Validate AWS terraform/demo2 layer
validate_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 terraform_validate

tflint_terraform_demo2: ## Terraform code goot practices check with tflint on terraform/demo2 layer
tflint_terraform_demo2:
	@$(MAKE) --no-print-directory terraform_lint CURRENT_DIR=terraform/demo2 TFLINT_CONFIG=.config/.tflint.hcl
markdown_lint_terraform_demo2: ## Lint Markdown files files on terraform/demo2 layer
markdown_lint_terraform_demo2:
	@$(MAKE) --no-print-directory markdown_lint_commands CURRENT_DIR=terraform/demo2 MARKDOWNLINT_CONFIG=.config/.mdl_style.rb
shell_lint_terraform_demo2: ## Lint shell files files on terraform/demo2 layer
shell_lint_terraform_demo2:
	@$(MAKE) --no-print-directory shell_lint_commands CURRENT_DIR=terraform/demo2 SHELLCHECK_CONFIG=.config/.shellcheckrc
yaml_lint_terraform_demo2: ## Lint yaml files files on terraform/demo2 layer
yaml_lint_terraform_demo2:
	@$(MAKE) --no-print-directory yaml_lint_commands CURRENT_DIR=terraform/demo2 YAMLLINT_CONFIG=.config/.yamllintrc
console_terraform_demo2: ## Connect terraform Docker AWS terraform/demo2 layer
console_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 console_commands

tsvc_terraform_demo2: ## Check terraform module version terraform/demo2
tsvc_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 terraform_check_version_commands

init_terraform_demo2: ## Init AWS terraform/demo2 layer
init_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 TERRAFORM_INIT_PARAMETERS="" terraform_init_commands

plan_terraform_demo2: ## Plan AWS terraform/demo2 layer
plan_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 TERRAFORM_VAR_PARAMETERS="" terraform_plan_commands

apply_terraform_demo2: ## Apply AWS terraform/demo2 layer
apply_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 TERRAFORM_VAR_PARAMETERS="" terraform_apply_commands

install_terraform_demo2: ## Install AWS terraform/demo2 layer
install_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 TERRAFORM_VAR_PARAMETERS="" terraform_install_commands

destroy_terraform_demo2: ## Uninstall AWS terraform/demo2 layer
destroy_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 TERRAFORM_VAR_PARAMETERS="" terraform_destroy_commands

destroyauto_terraform_demo2: ## Uninstall AWS terraform/demo2 layer automaticaly
destroyauto_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 TERRAFORM_VAR_PARAMETERS="" terraform_destroyauto_commands
terraform_docs_terraform_demo3: ## Generate terraform/demo3 layer Terraform Documentation
terraform_docs_terraform_demo3:
	@$(MAKE) --no-print-directory terraform_docs_commands CURRENT_DIR="terraform/demo3"
terrascan_terraform_demo3: ## Terrascan Terraform terraform/demo3 layer
terrascan_terraform_demo3:
	@$(MAKE) --no-print-directory terrascan_commands CURRENT_DIR="terraform/demo3"
format_terraform_demo3: ## Format terraform/demo3 layer Terraform files using "terraform fmt"
format_terraform_demo3:
	@$(MAKE) --no-print-directory terraform_format CURRENT_DIR="terraform/demo3"

trivy_terraform_demo3: ## Terraform trivy terraform/demo3 layer
trivy_terraform_demo3:
	@$(MAKE) --no-print-directory trivy_commands CURRENT_DIR=terraform/demo3
validate_terraform_demo3: ## Validate AWS terraform/demo3 layer
validate_terraform_demo3:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo3 terraform_validate

tflint_terraform_demo3: ## Terraform code goot practices check with tflint on terraform/demo3 layer
tflint_terraform_demo3:
	@$(MAKE) --no-print-directory terraform_lint CURRENT_DIR=terraform/demo3
markdown_lint_terraform_demo3: ## Lint Markdown files files on terraform/demo3 layer
markdown_lint_terraform_demo3:
	@$(MAKE) --no-print-directory markdown_lint_commands CURRENT_DIR=terraform/demo3
shell_lint_terraform_demo3: ## Lint shell files files on terraform/demo3 layer
shell_lint_terraform_demo3:
	@$(MAKE) --no-print-directory shell_lint_commands CURRENT_DIR=terraform/demo3
yaml_lint_terraform_demo3: ## Lint yaml files files on terraform/demo3 layer
yaml_lint_terraform_demo3:
	@$(MAKE) --no-print-directory yaml_lint_commands CURRENT_DIR=terraform/demo3
console_terraform_demo3: ## Connect terraform Docker AWS terraform/demo3 layer
console_terraform_demo3:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo3 console_commands

tsvc_terraform_demo3: ## Check terraform module version terraform/demo3
tsvc_terraform_demo3:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo3 terraform_check_version_commands

init_terraform_demo3: ## Init AWS terraform/demo3 layer
init_terraform_demo3:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo3 terraform_init_commands

plan_terraform_demo3: ## Plan AWS terraform/demo3 layer
plan_terraform_demo3:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo3 ADDITIONAL_VAR_PARAMETERS="-var-file=../common.tfvars" terraform_plan_commands

apply_terraform_demo3: ## Apply AWS terraform/demo3 layer
apply_terraform_demo3:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo3 ADDITIONAL_VAR_PARAMETERS="-var-file=../common.tfvars" terraform_apply_commands

install_terraform_demo3: ## Install AWS terraform/demo3 layer
install_terraform_demo3:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo3 ADDITIONAL_VAR_PARAMETERS="-var-file=../common.tfvars" terraform_install_commands

destroy_terraform_demo3: ## Uninstall AWS terraform/demo3 layer
destroy_terraform_demo3:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo3 ADDITIONAL_VAR_PARAMETERS="-var-file=../common.tfvars" terraform_destroy_commands

destroyauto_terraform_demo3: ## Uninstall AWS terraform/demo3 layer automaticaly
destroyauto_terraform_demo3:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo3 ADDITIONAL_VAR_PARAMETERS="-var-file=../common.tfvars" terraform_destroyauto_commands

terraform_docs_all:  ## Generate Terraform Documentation for all stacks
terraform_docs_all: terraform_docs_terraform_demo terraform_docs_terraform_demo2 terraform_docs_terraform_demo3
terrascan_all:  ## Terrascan Terraform
terrascan_all: terrascan_terraform_demo terrascan_terraform_demo2 terrascan_terraform_demo3
format_all:  ## Format all Terraform files using "terraform fmt"
format_all: format_terraform_demo format_terraform_demo2 format_terraform_demo3
trivy_all:  ## Terraform Trivy
trivy_all: trivy_terraform_demo  trivy_terraform_demo2  trivy_terraform_demo3 
validate_all:  ## Validate all Terraform files using "terraform validate"
validate_all: validate_terraform_demo  validate_terraform_demo2  validate_terraform_demo3 
tflint_all:  ## Terraform code goot practices check with tflint on all layers
tflint_all: tflint_terraform_demo  tflint_terraform_demo2  tflint_terraform_demo3 
markdown_lint_all:  ## Lint Markdown files files on all layers
markdown_lint_all: markdown_lint_terraform_demo  markdown_lint_terraform_demo2  markdown_lint_terraform_demo3 
shell_lint_all:  ## Lint shell files files on all layers
shell_lint_all: shell_lint_terraform_demo  shell_lint_terraform_demo2  shell_lint_terraform_demo3 
yaml_lint_all:  ## Lint yaml files files on all layers
yaml_lint_all: yaml_lint_terraform_demo  yaml_lint_terraform_demo2  yaml_lint_terraform_demo3 
tsvc_all: ## Install all AWS layers
tsvc_all: tsvc_terraform_demo  tsvc_terraform_demo2  tsvc_terraform_demo3 
init_all: ## Init all AWS layers
init_all: init_terraform_demo  init_terraform_demo2  init_terraform_demo3 
plan_all: ## Plan all AWS layers
plan_all: init_terraform_demo  init_terraform_demo2  init_terraform_demo3 
install_all: ## Install all AWS layers
install_all: plan_terraform_demo  plan_terraform_demo2  plan_terraform_demo3 
destroy_all: ## Uninstall all layers
destroy_all: destroy_terraform_demo3  destroy_terraform_demo2  destroy_terraform_demo 

### Makefile customizations

