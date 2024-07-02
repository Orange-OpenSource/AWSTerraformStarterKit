
# Tools

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


- [Terraform Check Version (tsvc)](https://github.com/tfverch/tfvc)
- Terraform version check (tfvc) is a reporting tool to identify available updates for providers and modules referenced in your Terraform code. 
- It provides clear warning/failure output and resolution guidance for any issues it detects.

# Adding a Tool

## New Service in Docker

1. Open the `docker-compose-tools.yaml` file located in the project's directory.

2. Inside the file, you will find a list of services defined under the `services` section. Each service represents a specific tool or component used in the StarterKit.

3. To add a new tool, you can either use an existing Docker community image or create your own Dockerfile.

   - Using an existing Docker community image: Find the appropriate image for the tool you want to add on the [Docker Hub](https://hub.docker.com/). Copy the image name and version tag.

   - Creating your own Dockerfile: If you prefer to create your own Dockerfile, you can place it in the `automation` folder of the project. Make sure to include the necessary instructions to build the Docker image.

4. Add a new service definition in the `docker-compose-tools.yaml` file for your tool. Follow the existing service definitions as a reference.

   - If using an existing Docker community image, you can use the `image` property to specify the image name and version.

   - If using a custom Dockerfile, you can use the `build` property to specify the path to the Dockerfile.

   Customize other properties such as the container name, volumes, environment variables, and any additional configurations specific to the tool you are adding.

5. Save the `docker-compose-tools.yaml` file after adding the new service definition.

## Customize tools config file for a plan

You can customize terraform commands by following these steps:

1. Configure commands in project configuration

   Edit the `configure.yaml` and, using the key mapping bellow, add the `key` for the tools you want to override the configuration file for.

   | tools | key |
   |-------|-----|
   | tflint | tflint_config |
   | shellcheck | shellcheck_config |
   | yaml lint | yamllint_config |
   | markdown lint | markdownlint_config |
   | trivy | trivy_config |
   | terrascan | terrascan_config |
   | terraform-docs | terraform-docs_config |

   ```yaml
   ...
   plans:
   - name: terraform/compute/app-server
     # (optional) layer specific tflint config file
     tflint_config: .config/.tflint.hcl
     # (optional) layer specific shell check config file
     shellcheck_config: .config/.shellcheckrc
     # (optional) layer specific yaml lint config file
     yamllint_config: .config/.yamllintrc
     # (optional) layer specific markdown lint config file
     markdownlint_config: .config/.mdl_style.rb
     # (optional) layer specific trivy config file
     trivy_config: .config/.trivy.yaml
     # (optional) layer specific terrascan config file
     terrascan_config: .config/.terrascan_config.toml
     # (optioanl) layer specific terraform-docs config file
     terraform-docs_config: .config/.terraform-docs.yml
   ...
   ```


## CICD

### Sonarqube

In order to use the CICD sonarqube job, create a `sonar-project.properties` file at the root of the project and add a gitlab-ci variable `SONAR_TOKEN`

# Tips

[Rebase from a fork repository](https://levelup.gitconnected.com/how-to-update-fork-repo-from-original-repo-b853387dd471)

Launch makefile without stopping on errors `make -k cmd` useful for the `quality-checks` target.

After adding a new Terraform Plan, launch the `make start` to update the `Makefile` and `.gitlab-ci.yml` file.
