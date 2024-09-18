
# Automatic Content Generated

generate_documentation: ## DEPRECATED: Generate Terraform Documentation
generate_documentation:
	$(DOCKER_COMPOSE_DEV_TOOLS) run --rm --remove-orphans terraform_docs terraform/demo --config=./${TERRAFORM_DOCS_CONFIG}
	$(DOCKER_COMPOSE_DEV_TOOLS) run --rm --remove-orphans terraform_docs terraform/demo2 --config=./${TERRAFORM_DOCS_CONFIG}
	$(DOCKER_COMPOSE_DEV_TOOLS) run --rm --remove-orphans terraform_docs terraform/demo3 --config=./${TERRAFORM_DOCS_CONFIG}
	$(DOCKER_COMPOSE_DEV_TOOLS) run --rm --remove-orphans terraform_docs terraform/demo1 --config=./${TERRAFORM_DOCS_CONFIG}

render_templates: ## Render all templates
render_templates:
	@$(MAKE) --no-print-directory render_template TPL_SRC=".test/exec_plan.j2" TPL_DST="exec_plan.txt"

terraform_terrascan: ## DEPRECATED: Terrascan Terraform
terraform_terrascan:
	$(TERRASCAN_RUN) scan -i terraform --verbose --config-path=./.terrascan_config.toml  --iac-dir=terraform/demo  --iac-dir=terraform/demo2  --iac-dir=terraform/demo3  --iac-dir=terraform/demo1 
format: ## DEPREATED: Format all Terraform files using "terraform fmt"
format:
	@$(MAKE) --no-print-directory terraform_format CURRENT_DIR="terraform/demo"
	@$(MAKE) --no-print-directory terraform_format CURRENT_DIR="terraform/demo2"
	@$(MAKE) --no-print-directory terraform_format CURRENT_DIR="terraform/demo3"
	@$(MAKE) --no-print-directory terraform_format CURRENT_DIR="terraform/demo1"

trivy:  ## DEPRECATED: Terraform Trivy
trivy:
	$(TRIVY_RUN) config terraform/demo --config=./.config/${TRIVY_CONFIG} --skip-dirs .terraform
	$(TRIVY_RUN) config terraform/demo2 --config=./.config/${TRIVY_CONFIG} --skip-dirs .terraform
	$(TRIVY_RUN) config terraform/demo3 --config=./.config/${TRIVY_CONFIG} --skip-dirs .terraform
	$(TRIVY_RUN) config terraform/demo1 --config=./.config/${TRIVY_CONFIG} --skip-dirs .terraform

validate: ## DEPRECATED: Validate all Terraform files using "terraform validate"
validate:
	@$(MAKE) --no-print-directory terraform_validate CURRENT_DIR="terraform/demo"
	@$(MAKE) --no-print-directory terraform_validate CURRENT_DIR="terraform/demo2"
	@$(MAKE) --no-print-directory terraform_validate CURRENT_DIR="terraform/demo3"
	@$(MAKE) --no-print-directory terraform_validate CURRENT_DIR="terraform/demo1"

lint: ## DEPRECATED: Check that good naming practices are respected in Terraform files (using tflint)
lint:
	$(TFLINT_RUN) --init
	@$(MAKE) --no-print-directory terraform_lint CURRENT_DIR="terraform/demo"
	@$(MAKE) --no-print-directory terraform_lint CURRENT_DIR="terraform/demo2"
	@$(MAKE) --no-print-directory terraform_lint CURRENT_DIR="terraform/demo3"
	@$(MAKE) --no-print-directory terraform_lint CURRENT_DIR="terraform/demo1"

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
	@$(MAKE) --no-print-directory terraform_docs_commands CURRENT_DIR="terraform/demo2"
terrascan_terraform_demo2: ## Terrascan Terraform terraform/demo2 layer
terrascan_terraform_demo2:
	@$(MAKE) --no-print-directory terrascan_commands CURRENT_DIR="terraform/demo2"
format_terraform_demo2: ## Format terraform/demo2 layer Terraform files using "terraform fmt"
format_terraform_demo2:
	@$(MAKE) --no-print-directory terraform_format CURRENT_DIR="terraform/demo2"

trivy_terraform_demo2: ## Terraform trivy terraform/demo2 layer
trivy_terraform_demo2:
	@$(MAKE) --no-print-directory trivy_commands CURRENT_DIR=terraform/demo2
validate_terraform_demo2: ## Validate AWS terraform/demo2 layer
validate_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 terraform_validate

tflint_terraform_demo2: ## Terraform code goot practices check with tflint on terraform/demo2 layer
tflint_terraform_demo2:
	@$(MAKE) --no-print-directory terraform_lint CURRENT_DIR=terraform/demo2
markdown_lint_terraform_demo2: ## Lint Markdown files files on terraform/demo2 layer
markdown_lint_terraform_demo2:
	@$(MAKE) --no-print-directory markdown_lint_commands CURRENT_DIR=terraform/demo2
shell_lint_terraform_demo2: ## Lint shell files files on terraform/demo2 layer
shell_lint_terraform_demo2:
	@$(MAKE) --no-print-directory shell_lint_commands CURRENT_DIR=terraform/demo2
yaml_lint_terraform_demo2: ## Lint yaml files files on terraform/demo2 layer
yaml_lint_terraform_demo2:
	@$(MAKE) --no-print-directory yaml_lint_commands CURRENT_DIR=terraform/demo2
console_terraform_demo2: ## Connect terraform Docker AWS terraform/demo2 layer
console_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 console_commands

tsvc_terraform_demo2: ## Check terraform module version terraform/demo2
tsvc_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 terraform_check_version_commands

init_terraform_demo2: ## Init AWS terraform/demo2 layer
init_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 terraform_init_commands

plan_terraform_demo2: ## Plan AWS terraform/demo2 layer
plan_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 terraform_plan_commands

apply_terraform_demo2: ## Apply AWS terraform/demo2 layer
apply_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 terraform_apply_commands

install_terraform_demo2: ## Install AWS terraform/demo2 layer
install_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 terraform_install_commands

destroy_terraform_demo2: ## Uninstall AWS terraform/demo2 layer
destroy_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 terraform_destroy_commands

destroyauto_terraform_demo2: ## Uninstall AWS terraform/demo2 layer automaticaly
destroyauto_terraform_demo2:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo2 terraform_destroyauto_commands
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
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo3 terraform_plan_commands

apply_terraform_demo3: ## Apply AWS terraform/demo3 layer
apply_terraform_demo3:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo3 terraform_apply_commands

install_terraform_demo3: ## Install AWS terraform/demo3 layer
install_terraform_demo3:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo3 terraform_install_commands

destroy_terraform_demo3: ## Uninstall AWS terraform/demo3 layer
destroy_terraform_demo3:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo3 terraform_destroy_commands

destroyauto_terraform_demo3: ## Uninstall AWS terraform/demo3 layer automaticaly
destroyauto_terraform_demo3:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo3 terraform_destroyauto_commands
terraform_docs_terraform_demo1: ## Generate terraform/demo1 layer Terraform Documentation
terraform_docs_terraform_demo1:
	@$(MAKE) --no-print-directory terraform_docs_commands CURRENT_DIR="terraform/demo1"
terrascan_terraform_demo1: ## Terrascan Terraform terraform/demo1 layer
terrascan_terraform_demo1:
	@$(MAKE) --no-print-directory terrascan_commands CURRENT_DIR="terraform/demo1"
format_terraform_demo1: ## Format terraform/demo1 layer Terraform files using "terraform fmt"
format_terraform_demo1:
	@$(MAKE) --no-print-directory terraform_format CURRENT_DIR="terraform/demo1"

trivy_terraform_demo1: ## Terraform trivy terraform/demo1 layer
trivy_terraform_demo1:
	@$(MAKE) --no-print-directory trivy_commands CURRENT_DIR=terraform/demo1
validate_terraform_demo1: ## Validate AWS terraform/demo1 layer
validate_terraform_demo1:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo1 terraform_validate

tflint_terraform_demo1: ## Terraform code goot practices check with tflint on terraform/demo1 layer
tflint_terraform_demo1:
	@$(MAKE) --no-print-directory terraform_lint CURRENT_DIR=terraform/demo1
markdown_lint_terraform_demo1: ## Lint Markdown files files on terraform/demo1 layer
markdown_lint_terraform_demo1:
	@$(MAKE) --no-print-directory markdown_lint_commands CURRENT_DIR=terraform/demo1
shell_lint_terraform_demo1: ## Lint shell files files on terraform/demo1 layer
shell_lint_terraform_demo1:
	@$(MAKE) --no-print-directory shell_lint_commands CURRENT_DIR=terraform/demo1
yaml_lint_terraform_demo1: ## Lint yaml files files on terraform/demo1 layer
yaml_lint_terraform_demo1:
	@$(MAKE) --no-print-directory yaml_lint_commands CURRENT_DIR=terraform/demo1
console_terraform_demo1: ## Connect terraform Docker AWS terraform/demo1 layer
console_terraform_demo1:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo1 console_commands

tsvc_terraform_demo1: ## Check terraform module version terraform/demo1
tsvc_terraform_demo1:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo1 terraform_check_version_commands

init_terraform_demo1: ## Init AWS terraform/demo1 layer
init_terraform_demo1:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo1 terraform_init_commands

plan_terraform_demo1: ## Plan AWS terraform/demo1 layer
plan_terraform_demo1:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo1 terraform_plan_commands

apply_terraform_demo1: ## Apply AWS terraform/demo1 layer
apply_terraform_demo1:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo1 terraform_apply_commands

install_terraform_demo1: ## Install AWS terraform/demo1 layer
install_terraform_demo1:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo1 terraform_install_commands

destroy_terraform_demo1: ## Uninstall AWS terraform/demo1 layer
destroy_terraform_demo1:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo1 terraform_destroy_commands

destroyauto_terraform_demo1: ## Uninstall AWS terraform/demo1 layer automaticaly
destroyauto_terraform_demo1:
	@$(MAKE) --no-print-directory CURRENT_DIR=terraform/demo1 terraform_destroyauto_commands

terraform_docs_all:  ## Generate Terraform Documentation for all stacks
terraform_docs_all: terraform_docs_terraform_demo terraform_docs_terraform_demo2 terraform_docs_terraform_demo3 terraform_docs_terraform_demo1
terrascan_all:  ## Terrascan Terraform
terrascan_all: terrascan_terraform_demo terrascan_terraform_demo2 terrascan_terraform_demo3 terrascan_terraform_demo1
format_all:  ## Format all Terraform files using "terraform fmt"
format_all: format_terraform_demo format_terraform_demo2 format_terraform_demo3 format_terraform_demo1
trivy_all:  ## Terraform Trivy
trivy_all: trivy_terraform_demo  trivy_terraform_demo2  trivy_terraform_demo3  trivy_terraform_demo1 
validate_all:  ## Validate all Terraform files using "terraform validate"
validate_all: validate_terraform_demo  validate_terraform_demo2  validate_terraform_demo3  validate_terraform_demo1 
tflint_all:  ## Terraform code goot practices check with tflint on all layers
tflint_all: tflint_terraform_demo  tflint_terraform_demo2  tflint_terraform_demo3  tflint_terraform_demo1 
markdown_lint_all:  ## Lint Markdown files files on all layers
markdown_lint_all: markdown_lint_terraform_demo  markdown_lint_terraform_demo2  markdown_lint_terraform_demo3  markdown_lint_terraform_demo1 
shell_lint_all:  ## Lint shell files files on all layers
shell_lint_all: shell_lint_terraform_demo  shell_lint_terraform_demo2  shell_lint_terraform_demo3  shell_lint_terraform_demo1 
yaml_lint_all:  ## Lint yaml files files on all layers
yaml_lint_all: yaml_lint_terraform_demo  yaml_lint_terraform_demo2  yaml_lint_terraform_demo3  yaml_lint_terraform_demo1 
tsvc_all: ## Install all AWS layers
tsvc_all: tsvc_terraform_demo  tsvc_terraform_demo2  tsvc_terraform_demo3  tsvc_terraform_demo1 
init_all: ## Init all AWS layers
init_all: init_terraform_demo  init_terraform_demo2  init_terraform_demo3  init_terraform_demo1 
plan_all: ## Plan all AWS layers
plan_all: init_terraform_demo  init_terraform_demo2  init_terraform_demo3  init_terraform_demo1 
install_all: ## Install all AWS layers
install_all: plan_terraform_demo  plan_terraform_demo2  plan_terraform_demo3  plan_terraform_demo1 
destroy_all: ## Uninstall all layers
destroy_all: destroy_terraform_demo1  destroy_terraform_demo3  destroy_terraform_demo2  destroy_terraform_demo 

### Makefile customizations

