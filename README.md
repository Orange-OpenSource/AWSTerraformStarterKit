# Terraform StarterKit

The StarterKit is a tool developed to simplify the process of deploying resources on Amazon Web Services (AWS) using Terraform. Terraform is an infrastructure as code (IaC) tool that allows you to define and provision infrastructure resources in a declarative manner.

The purpose of the StarterKit is to provide a pre-configured template or framework that helps users quickly get started with AWS and Terraform. It typically includes a set of predefined Terraform configurations, scripts, tools, and best practices tailored for common AWS use cases.

The StarterKit utilizes several technologies to facilitate the deployment of resources on AWS with Terraform. These technologies include:

1. Docker: Docker is a containerization platform that allows for the creation and management of lightweight, isolated environments called containers. In the context of the starter kit, Docker is used to provide a consistent and reproducible development environment. It helps ensure that the required dependencies and tools are readily available without conflicts.

2. Makefile: Makefile is a build automation tool that is commonly used to define and execute tasks in software development projects. In the context of the starter kit, Makefile is used to define and automate common tasks such as initializing the project, deploying resources, running tests, and cleaning up.

3. Jinja: Jinja is a powerful templating engine for Python. In the context of the StarterKit, Jinja is used for templating purposes to generate configuration files or scripts dynamically. It allows for the inclusion of variables, conditionals, loops, and other programming constructs within templates, enabling dynamic generation of Terraform configurations based on user-defined parameters.

4. GitLab-CI: if you wish to orchestrate your Terraform deployments thanks to GitLab-CI, this starter kit is able to generate a `.gitlab-ci.ym` designed to create and execute the GitLab jobs of your choice. (**at the moment, the AWSTerraformStarterKit is designed to manage GitLab-CI only**)

These technologies work together to provide an efficient and streamlined workflow for deploying resources on AWS using Terraform. Docker ensures consistent and isolated environments, the Makefile automates common tasks, and Jinja enables flexible and dynamic templating.

## Objectives and Benefits

Here are some key objectives and benefits of an AWS StarterKit:

1. **Accelerating AWS adoption:** By providing a ready-to-use StarterKit, users can quickly onboard AWS and start deploying infrastructure resources without spending significant time on initial setup and configuration.

2. **Simplifying Terraform usage:** The StarterKit abstracts away some of the complexities and provides a simplified interface for provisioning resources (via Makefile), making it easier for users to get up and running with Terraform.

3. **Standardized infrastructure:** The StarterKit promotes standardization and consistency in infrastructure deployments. It enforces best practices, naming conventions, and predefined configurations, ensuring that resources are provisioned in a consistent and reliable manner.

4. **Modularity and reusability:** A well-designed StarterKit encourages modular and reusable infrastructure code. It may include modules or templates that can be easily customized and extended to meet specific requirements, promoting code reusability and reducing duplication.

5. **Security and compliance:** The StarterKit can include security configurations and guidelines to ensure that the provisioned resources adhere to AWS security best practices. It may also provide compliance-focused templates to help users meet specific regulatory requirements.

6. **Documentation and guidance:** Along with the StarterKit, documentation and guidance materials are often provided to assist users in understanding the tool's features, how to customize configurations, and how to troubleshoot common issues.

Overall, an AWS StarterKit aims to streamline the process of deploying resources on AWS using Terraform, reducing the learning curve and accelerating the time to value for users. It provides a solid foundation and best practices to help users start their infrastructure-as-code journey on AWS with confidence.

## Prerequisites

To install the StarterKit, several tools are required on the user's computer:

1. **Docker**: [Docker](https://docs.docker.com/engine/install/) is a platform that allows you to package, distribute, and run applications in isolated containers. It provides a consistent environment for running the starter kit's components and dependencies.

2. **Docker Compose Plugin**: [Docker Compose Plugin](https://docs.docker.com/compose/install/linux/) is an extension for Docker that simplifies the management of multi-container applications. It enables you to define and run multi-container setups required by the starter kit.

3. **Makefile**: [Makefile](https://www.gnu.org/software/make/manual/make.html) is a build automation tool that helps manage and organize complex workflows. In the context of the starter kit, Makefile provides a convenient way to define and execute common tasks and commands for setting up and deploying AWS resources.

4. **AWS CLI**: [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) (Command Line Interface) is a unified tool for interacting with various AWS services through the command line. It allows you to configure your AWS credentials, manage resources, and automate tasks required by the starter kit.

5. **jq**: [jq](https://jqlang.github.io/jq/) is a lightweight and flexible command-line JSON processor. It enables you to manipulate and extract data from JSON files and API responses, which can be useful for processing and transforming data within the starter kit.

6. **Git**: [Git](https://git-scm.com/) is a distributed version control system used for tracking changes in source code during software development.

By having these tools installed, users can seamlessly set up and utilize the StarterKit for deploying resources on AWS with Terraform.

## Initialize a Project

### Step 1

To start using the AWSTerraformStarterKit, follow these steps:

1. Clone an empty Git repo or create a empty directory and intitialize de Git repo with `git init` command

2. Create a **terraform** folder within your new repository and copy your Terraform plans into. A Terraform plan is a subfolder of the **terraform** directory.

3. You can create a **common.tfvars** file at the root level of **terraform** directory that will contain the common parameters of your Teraform plans. 

4. Download `get-starter-kit.sh` shell script from this repository at the root level of you repo and make it executalbe (`chmod +x get-starter-kit.sh`)

5. Execute `get-starter-kit.sh`
   - Without any arguments: the shell script will download the lastest version of the shell script.
   - With a AWSTerraformStaertKit specific version to be downloade as argument (release list: https://github.com/Orange-OpenSource/AWSTerraformStarterKit/releases)

6. The `get-starter-kit.sh` will download the AWSTerraformStarterKit files and folders. You are now ready to bootstrap you first Terraform project with the AWSTerraformStaertKit!

### Step 2

1. Locate the `.gitignore.dist`

2. Rename `.gitignore.dist` to `.gitignore`. The `.gitignore` file contains the standard ignore file list for a Terraform project and the AWSTerraformStarterKit files and folders that should not be commited in your Git repo.

### Step 3

1. Locate the `configure.yaml.dist` file in the StarterKit directory.

2. Make a copy of the `configure.yaml.dist` file and rename it as `configure.yaml`. You can do this by executing the following command in the terminal or command prompt:

   ```bash
   cp configure.yaml.dist configure.yaml
   ```

   This creates a new file named `configure.yaml` with the same content as `configure.yaml.dist`.

3. Open the `configure.yaml` file in a text editor.

4. Inside the `configure.yaml` file, you'll find various parameters that need to be updated according to your requirements.

5. Update the parameters in the `configure.yaml` file with your desired values. Make sure to follow the instructions or comments provided in the file to correctly configure each parameter.

6. Save the changes to the `configure.yaml` file.

### Step4

[Export AWS credentials as environment variables in your path.](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

1. Open a terminal or command prompt.

2. Set the AWS access key ID as an environment variable by executing the following command:

   ```bash
   export AWS_ACCESS_KEY_ID="your_access_key_id"
   ```

   Replace `"your_access_key_id"` with your actual AWS access key ID.

3. Set the AWS secret access key as an environment variable by executing the following command:

   ```bash
   export AWS_SECRET_ACCESS_KEY="your_secret_access_key"
   ```

   Replace `"your_secret_access_key"` with your actual AWS secret access key.

4. (Optional) If you have an AWS session token, you can set it as an environment variable by executing the following command:

   ```bash
   export AWS_SESSION_TOKEN="your_session_token"
   ```

   Replace `"your_session_token"` with your actual AWS session token.

5. (Optional) If you have an AWS Default Region, you can set it as an environment variable by executing the following command:

   ```bash
   export AWS_REGION="your_session_region"
   ```

   Replace `"your_session_region"` with your actual AWS Region parameter.

By setting these environment variables, AWS CLI and other AWS-related tools will be able to access your AWS credentials from the environment, allowing you to interact with AWS services using those credentials.

**Please note that exporting credentials as environment variables may not be the most secure method, especially in shared environments.**

## Start the Project

Once you have set your AWS credentials in the path and modified the `configure.yaml` file to fit your needs, you can start the StarterKit using the command `make start`. This command will execute the `make init` command, which performs the following steps:

1. It converts the `configure.yaml` file to a `.env` file. The `.env` file is used to store environment variables required by the StarterKit.

2. It generates a new `Makefile` based on the `configure.yaml` file. The `Makefile` contains predefined targets and commands that can be executed using the `make` command.

3. It generates a new `gitlab-ci.yml` file by leveraging the information present in the .env file and using a GitLab CI Jinja template file as a blueprint. The resulting gitlab-ci.yml file will reflect the specific configurations and values provided in the .env file, allowing for a customized and automated setup of your GitLab CI pipeline.

By executing `make start`, the StarterKit will be initialized with the provided configuration, and you can proceed with deploying resources on AWS using Terraform.

It's important to note that if your AWS credentials expire or change, you need to update the credentials in the environment variables or the AWS CLI configuration and then restart the StarterKit by running `make start` again. This ensures that the StarterKit uses the updated credentials for all AWS operations.

## Help

To get help and list all the available commands in the StarterKit, you can use the `make help` command. This command will display the available targets and their descriptions from the `Makefile`. Here's how you can use it:

1. Open a terminal or command prompt.

2. Navigate to the StarterKit directory.

3. Run the following command:

   ```bash
   make help
   ```

   This will display the list of available targets and their descriptions, providing you with information about the available commands and their purposes.

Additionally, you can open the `Makefile` in a text editor to explore and understand the various targets and commands defined in it. The `Makefile` contains rules that define how the StarterKit is built, executed, and managed using the `make` command.

By using `make help` and referring to the `Makefile`, you can gain a better understanding of the available commands and utilize them effectively in your StarterKit workflow.

## Usage

Every available commands are described in the make file. Use the `make help` command to get all available commands.

```bash
help                           This help.
debug                          Print debug logs
generate                       Generate from template gitlab-ci.yml and Makefile
generate_makefile              Generate Makefile
generate_gitlab_ci             Generate  GitlabCI
start                          Stop the project
stop                           Start the project
down                           stop containers
kill                           Destroy all containers
console                        Connect Terraform Docker
logout                         Remove assumed role
drfit                          Detect Drift
precommit                      Launch precommit hooks
dotenv_linter                  Lint dotenv files
markdown_lint                  Lint Markdown files files
shell_lint                     Lint shell files
yaml_lint                      Lint yaml files
trivy                          Terraform Trivy
assume-role                    Assume the given role
dashboard                      Launch Terradash on localhost:8080
quality-checks                 run quality checks
format                         Format all Terraform files using "terraform fmt"
validate                       Validate all Terraform files using "terraform validate"
lint                           Check that good naming practices are respected in Terraform files (using tflint)
plan_compute                   Plan AWS compute layer
install_compute                Install AWS compute layer
delete_compute                 Uninstall AWS compute layer
plan_all                       Plan all AWS layers
install_all                    Install all AWS layers
delete_all                     Uninstall all layers
```

## Add a Terraform Plan

To add a new Terraform plan to the project, you can follow these steps:

1. Open the `configure.yaml` file in a text editor. This file should be located in the project directory.

2. Locate the `plans` key in the `configure.yaml` file. This key contains a list of plan names.

3. Add the name of the new plan to the `plans` list. Each plan name should be a string.

   For example, if you want to add a plan named "new-plan", the entry would look like:

   ```yaml
   plans:
     - plan1
     - plan2
     - new-plan

   ```

4. Save the `configure.yaml` file after adding the new plan name.

After adding the new Terraform plan to the `configure.yaml` file, you can relaunch the starter kit by executing the `make start` command.
This command will generate the necessary templates based on the newly added plan. Here are the steps:

1. Open a terminal or command prompt in the project directory.

2. Run the following command to start the starter kit:

   ```bash
   make start
   ```

   This command will trigger the execution of the StarterKit's Makefile, which includes the logic to generate the required templates.

3. The starter kit will read the `configure.yaml` file, identify the added plan, and generate the corresponding templates or configuration files based on the plan's specifications.

4. Once the process completes, you can proceed with using the generated templates for your Terraform deployment.

## Add a Tool

### New Service in Docker

1. Open the `docker-compose-tools.yaml` file located in the project's directory.

2. Inside the file, you will find a list of services defined under the `services` section. Each service represents a specific tool or component used in the starter kit.

3. To add a new tool, you can either use an existing Docker community image or create your own Dockerfile.

   - Using an existing Docker community image: Find the appropriate image for the tool you want to add on the [Docker Hub](https://hub.docker.com/). Copy the image name and version tag.

   - Creating your own Dockerfile: If you prefer to create your own Dockerfile, you can place it in the `automation` folder of the project. Make sure to include the necessary instructions to build the Docker image.

4. Add a new service definition in the `docker-compose-tools.yaml` file for your tool. Follow the existing service definitions as a reference.

   - If using an existing Docker community image, you can use the `image` property to specify the image name and version.

   - If using a custom Dockerfile, you can use the `build` property to specify the path to the Dockerfile.

   Customize other properties such as the container name, volumes, environment variables, and any additional configurations specific to the tool you are adding.

5. Save the `docker-compose-tools.yaml` file after adding the new service definition.

### New command in Makefile

If the command you want to add to the starter kit does not depend on the configure.yaml file, you can directly add it to
the Makefile. However, if the command requires some dynamic configuration based on the configure.yaml file, you should add it to
the Jinja template in the automation folder.

## Tips

[Rebase from a fork repository](https://levelup.gitconnected.com/how-to-update-fork-repo-from-original-repo-b853387dd471)

Launch makefile without stopping on errors `make -k cmd` useful for the `quality-checks` target.

After adding a new Terraform Plan, launch the `make start` to update the `Makefile` and `.gitlab-ci.yml` file.

## Tools

- [TFEnv](https://github.com/tfutils/tfenv)

tfenv is a version manager specifically designed for Terraform. It provides a simple and convenient way to manage multiple
versions of Terraform on a single machine. With tfenv, you can easily switch between different versions of Terraform based on your project's requirements.

Using tfenv, you can install and manage multiple versions of Terraform side by side, ensuring compatibility with different projects or environments.
It allows you to easily switch between versions with a single command, making it effortless to work on different projects that may require different
versions of Terraform.

1. Create a file named `.terraform-version` in the root directory of your Terraform project.

2. Inside the `.terraform-version` file, specify the desired version of Terraform you want to use for your project. For example, you can write `0.15.4` to indicate that you want to use version 0.15.4.

3. Install tfenv on your machine if you haven't done so already. You can refer to the tfenv documentation for installation instructions specific to your operating system.

4. Once tfenv is installed, navigate to the root directory of your Terraform project using the command line.

5. Run the following command to let tfenv detect and switch to the version specified in the `.terraform-version` file

`tfenv install`

This command will check the `.terraform-version` file and automatically install the specified version of Terraform if it's not already installed.
If the desired version is already installed, tfenv will switch to that version.

6. Verify that the correct version of Terraform is now in use by running:

`terraform version`

You should see the version specified in the `.terraform-version` file displayed in the output.

By using the `.terraform-version` file, tfenv makes it easy to ensure that the correct version of Terraform is used for each specific project or directory. It simplifies the management of Terraform versions and helps maintain consistency across different projects.

If you have any further questions or need additional assistance, feel free to ask!

- [Trivy](https://github.com/aquasecurity/trivy)

Trivy is a security vulnerability scanner and open-source tool designed for container and application security. It helps
in identifying vulnerabilities in container images, as well as in software dependencies used by applications.
Trivy scans container images and provides detailed reports on any known vulnerabilities
found in the operating system packages, libraries, and other components.
It supports various platforms and package managers, making it a valuable tool for developers, DevOps teams, and security
professionals to proactively identify and address security risks in their containerized environments.

- [Pre-commit](https://pre-commit.com/)

Pre-commit is a lightweight and highly customizable framework used for setting up and enforcing code quality checks and
pre-commit hooks in software development projects. It allows developers to define a set of hooks that automatically run
before committing their code changes, ensuring that certain checks and validations are performed. These checks can
include formatting code, linting, running tests, and more.

Pre-commit helps maintain code consistency, improves code quality, and catches potential issues early in the development
process, enhancing collaboration and reducing the likelihood of introducing bugs into the codebase.

- [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform).

   - terraform_validate
   - terraform_fmt
   - terraform_docs
   - terrascan
   - terraform_tflint
   - terraform_tfsec

- [Terradocs](https://github.com/terraform-docs/terraform-docs)

Terradocs is a documentation generation tool specifically designed for Terraform configurations. It analyzes Terraform
code and generates comprehensive documentation that helps users understand and visualize the infrastructure and
resources defined in their Terraform projects. Terradocs extracts information from the Terraform configuration files,
such as resource definitions, variable descriptions, input and output values, and outputs them in a user-friendly format.

Terradocs provides an automated way to keep documentation in sync with the Terraform codebase, making it easier to
maintain and share up-to-date documentation. It enhances collaboration among team members by providing clear and
structured documentation that can be easily understood by developers, operators, and stakeholders.

- [terraform_tflint](https://github.com/terraform-linters/tflint)

Terraform linter is a static analysis tool used to enforce coding best practices, maintain consistency, and identify
potential issues in Terraform code. It analyzes the Terraform configuration files and provides feedback on code quality,
style violations, and potential errors or misconfigurations.

By using a set of predefined rules or custom configurations, the Terraform linter can catch common mistakes, deprecated
syntax, unused variables, and other code smells. It helps developers write cleaner and more reliable Terraform code by
highlighting problematic areas and suggesting improvements.

- [terrascan](https://runterrascan.io/)

Terrascan is a static code analysis tool designed specifically for Terraform configurations. It helps identify potential
security vulnerabilities, compliance violations, and misconfigurations in Terraform code. Terrascan scans the Terraform
files and compares them against a set of predefined security policies and best practices.

By leveraging the power of static analysis, Terrascan can detect security risks such as overly permissive IAM policies,
insecure storage configurations, and unencrypted sensitive data. It provides detailed reports that highlight the specific
vulnerabilities and non-compliant configurations found in the code.

- [tfsec](https://github.com/aquasecurity/tfsec)

tfsec is a security scanner and static analysis tool specifically built for Terraform code. It helps identify potential
security risks, best practice violations, and misconfigurations in Terraform configurations.
tfsec analyzes the Terraform code and provides feedback on security-related issues, allowing developers to proactively
address them.

By scanning the Terraform files, tfsec checks for common security vulnerabilities such as open security group rules,
missing encryption settings, and insecure access control configurations. It provides detailed reports and recommendations
to help developers remediate security issues and ensure a more robust and secure infrastructure.

- [dotenv linter](https://github.com/dotenv-linter/dotenv-linter)

dotenv-linter is a tool used for linting and validating .env files. It helps ensure that environment variable files are
well-formatted and adhere to best practices. dotenv-linter scans .env files and provides feedback on potential issues
and inconsistencies in the file content.

By using dotenv-linter, developers can catch common mistakes such as missing or duplicated keys, invalid or incomplete
values, and improper formatting. It enforces guidelines for maintaining clean and error-free .env files, making
it easier to manage environment configurations across different environments and deployments.

- [markdown_lint](https://github.com/markdownlint/markdownlint)

markdownlint is a linter and style checker specifically designed for Markdown documents. It helps ensure consistency,
readability, and adherence to best practices in Markdown files. markdownlint analyzes Markdown content and provides
feedback on formatting, style violations, and potential errors.

By using markdownlint, developers and writers can catch common mistakes such as inconsistent heading levels,
trailing spaces, excessive line lengths, and incorrect link formatting. It enforces guidelines for maintaining
well-structured and visually appealing Markdown documents, improving the overall quality of documentation and written content.

- [shell_lint](https://www.shellcheck.net/)

shellcheck is a static analysis tool used to lint and validate shell scripts. It helps identify potential issues, errors,
and best practice violations in shell scripts. shellcheck analyzes shell script files and provides feedback on code quality,
potential bugs, and security vulnerabilities.

By using shellcheck, developers can catch common mistakes such as syntax errors, undefined variables, incorrect command usage,
and unsafe code patterns. It enforces guidelines for writing robust and portable shell scripts, ensuring better code reliability and maintainability.

- [yaml_lint](https://www.yamllint.com/)

yamllint is a linter and validator specifically designed for YAML files. It helps ensure the correctness, consistency,
and adherence to best practices in YAML files. yamllint analyzes YAML content and provides feedback on syntax errors, formatting issues,
and potential problems.

By using yamllint, developers and configuration authors can catch common mistakes such as indentation errors, incorrect syntax,
duplicate keys, and inconsistent formatting. It enforces guidelines for maintaining clean and error-free YAML files, improving the overall
quality and reliability of configuration files.

- [powershell_lint](https://github.com/cypher0n3/psscriptanalyzer-docker)

PowerShell Script Analyzer (PSScriptAnalyzer) is a static analysis tool specifically built for PowerShell scripts.
It helps identify potential issues, coding style violations, and best practice violations in PowerShell scripts.
PSScriptAnalyzer analyzes PowerShell script files and provides feedback on code quality, potential bugs, and maintainability.

By using PSScriptAnalyzer, developers can catch common mistakes such as syntax errors, undefined variables,
unused variables, incorrect parameter usage, and overall script quality.

- [Terraform docs](https://terraform-docs.io/)
- Terraform Docs is a tool used for linting and validating Terraform module documentation. It helps ensure that module
  documentation is accurate, well-formatted, and follows best practices. Terraform Docs analyzes the documentation
  files associated with Terraform modules and provides feedback on formatting, content, and potential issues.

By using Terraform Docs, developers can catch common mistakes such as missing or incomplete descriptions, inconsistent
formatting, and incorrect usage examples. It enforces guidelines for maintaining clear, concise, and informative module
documentation, improving the overall quality of module documentation and enhancing collaboration among team members.
