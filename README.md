# AWSTerraformStarterKit

The AWSTerraformStarterKit is a tool developed to simplify the process of deploying resources on Amazon Web Services (AWS) using Terraform. Terraform is an infrastructure as code (IaC) tool that allows you to define and provision infrastructure resources in a declarative manner.

- [Description](#description)
- [Objectives and Benefits](#objectives-and-benefits)
- [Installation procedure and Usage](docs/installation.md)
- [Tools description](docs/tools.md)
## Description

The purpose of the AWSTerraformStarterKit is to provide a pre-configured template or framework that helps **linux** users quickly get started with AWS and Terraform. It typically includes a set of predefined Terraform configurations, scripts, tools, and best practices tailored for common AWS use cases.

The AWSTerraformStarterKit utilizes several technologies to facilitate the deployment of resources on AWS with Terraform. These technologies include:

1. **Docker**: Docker is a containerization platform that allows for the creation and management of lightweight, isolated environments called containers. In the context of the AWSTerraformStarterKit, Docker is used to provide a consistent and reproducible development environment. It helps ensure that the required dependencies and tools are readily available without conflicts.

2. **Makefile**: Makefile is a build automation tool that is commonly used to define and execute tasks in software development projects. In the context of the AWSTerraformStarterKit, Makefile is used to define and automate common tasks such as initializing the project, deploying resources, running tests, and cleaning up.

3. **Jinja**: Jinja is a powerful templating engine for Python. In the context of the AWSTerraformStarterKit, Jinja is used for templating purposes to generate configuration files or scripts dynamically. It allows for the inclusion of variables, conditionals, loops, and other programming constructs within templates, enabling dynamic generation of Terraform configurations based on user-defined parameters.

4. **GitLab-CI**: if you wish to orchestrate your Terraform deployments thanks to GitLab-CI, this AWSTerraformStarterKit is able to generate a `.gitlab-ci.ym` designed to create and execute the GitLab jobs of your choice. (**at the moment, the AWSTerraformStarterKit is designed to manage GitLab-CI only**)

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
