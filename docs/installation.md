# Installation and Usage

- [Prerequisites](#prerequisites)
- [Initialize a Project](#initialize-a-project)
- [Utilization](#utilization)
  - [Start the AWSTerraformStarterKit](#start-the-awsterraformstarterkit)
  - [Help](#help)
  - [Usage](#usage)
  - [Add a Terraform Plan](#add-a-terraform-plan)
  - [Update AWSTerraformStarterKit](#update-awsterraformstarterkit)

## Prerequisites

To install the AWSTerraformStarterKit, several tools are required on the user's computer:

1. **Docker**: [Docker](https://docs.docker.com/engine/install/) is a platform that allows you to package, distribute, and run applications in isolated containers. It provides a consistent environment for running the AWSTerraformStarterKit's components and dependencies.

2. **Docker Compose Plugin**: [Docker Compose Plugin](https://docs.docker.com/compose/install/linux/) is an extension for Docker that simplifies the management of multi-container applications. It enables you to define and run multi-container setups required by the AWSTerraformStarterKit.

3. **Makefile**: [Makefile](https://www.gnu.org/software/make/manual/make.html) is a build automation tool that helps manage and organize complex workflows. In the context of the AWSTerraformStarterKit, Makefile provides a convenient way to define and execute common tasks and commands for setting up and deploying AWS resources.

4. **AWS CLI**: [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) (Command Line Interface) is a unified tool for interacting with various AWS services through the command line. It allows you to configure your AWS credentials, manage resources, and automate tasks required by the AWSTerraformStarterKit.

5. **jq**: [jq](https://jqlang.github.io/jq/) is a lightweight and flexible command-line JSON processor. It enables you to manipulate and extract data from JSON files and API responses, which can be useful for processing and transforming data within the AWSTerraformStarterKit.

6. **Git**: [Git](https://git-scm.com/) is a distributed version control system used for tracking changes in source code during software development.

By having these tools installed, users can seamlessly set up and utilize the AWSTerraformStarterKit for deploying resources on AWS with Terraform.

## Initialize a Project

### Step 1

To **intialize** the AWSTerraformStarterKit, follow these steps:  
([link to **update** section](#Update-AWSTerraformStarterKit))

1. Clone an empty Git repo or create a empty directory and intitialize de Git repo with `git init` command

2. Create a **terraform** folder within your new repository and copy your Terraform plans into. A Terraform plan is a subfolder of the **terraform** directory.

3. You can create a **common.tfvars** file at the root level of **terraform** directory that will contain the common parameters of your Teraform plans. 

4. Download `get-starter-kit.sh` shell script and make it executable

   ```bash
   curl -o get-starter-kit.sh https://raw.githubusercontent.com/Orange-OpenSource/AWSTerraformStarterKit/master/get-starter-kit.sh
   chmod +x get-starter-kit.sh
   ```


5. Execute `get-starter-kit.sh`
   - Without any arguments: the shell script will download the lastest version of the shell script.
   - With a AWSTerraformStaertKit specific version to be downloaded as argument (release list: https://github.com/Orange-OpenSource/AWSTerraformStarterKit/releases)
   ```bash
   ./get-starter-kit.sh
   # OR
   ./get-starter-kit.sh 0.1.2
   ```

6. The `get-starter-kit.sh` will download the AWSTerraformStarterKit files and folders. You are now ready to bootstrap you first Terraform project with the AWSTerraformStarterKit!

#### Directory Structure Overview after AWSTerraformStarterKit download

```yaml
Project Root Directory:
  - .config/:
  - .editorconfig
  - .git
  - .gitignore
  - Makefile
  - automation/:
  - configure.yaml.dist
  - docker-compose-tools.yml
  - docker-compose.yml
  - get-starter-kit.sh
  - terraform/:
    - common.tfvars
    - network/:
      - main.tf
      - provider.tf
      - parameters.auto.tfvars
      - ...
    - compute/:
      - ...
```

### Step 2

1. Locate the `.gitignore.dist` then copy it as `.gitignore`. 

   ```bash
   cp .gitignore.dist .gitignore
   ```
2. Edit `.gitignore` file in a text editor and update with your desired other files to ignore. 

> `.gitignore` contains : 
> - the standard ignore file list for a Terraform project
> - the AWSTerraformStarterKit files and folders that should not be commited in your Git repo.
> - You own list of files and directories that should not be commited in your Git repo.

### Step 3

1. Locate the `configure.yaml.dist` then copy it as `configure.yaml`. 

   ```bash
   cp configure.yaml.dist configure.yaml
   ```
2. Edit `configure.yaml` file in a text editor and update the parameters  with your desired values. Make sure to follow the instructions or comments provided in the file to correctly configure each parameter.


> `configure.yaml` is the main configuration file of AWSTerraformStarterKit. It contains : 
> - ENV Variables
> - Docker Compose image tags to use
> - GITLAB CI configuration
> - Terraform S3 Backend Configuration
> - Terraform plans
> - proxy settings


### Step4

[Export AWS credentials as environment variables in your path.](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

The following examples show how you can configure environment variables for the default user.

```bash
$ export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
$ export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
$ export AWS_DEFAULT_REGION=us-west-2
```
> **Please note that exporting credentials as environment variables may not be the most secure method, especially in shared environments.**

# Utilization
## Start the AWSTerraformStarterKit

Once you have set your AWS credentials in the path and modified the `configure.yaml` file to fit your needs, you can start the AWSTerraformStarterKit using the command `make start`. This command will execute the `make init` command, which performs the following steps:

1. It converts the `configure.yaml` file to a `.env` file. The `.env` file is used to store environment variables required by the AWSTerraformStarterKit.

2. It generates a new `Makefile` based on the `configure.yaml` file. The `Makefile` contains predefined targets and commands that can be executed using the `make` command.

3. It generates a new `gitlab-ci.yml` file by leveraging the information present in the .env file and using a GitLab CI Jinja template file as a blueprint. The resulting gitlab-ci.yml file will reflect the specific configurations and values provided in the .env file, allowing for a customized and automated setup of your GitLab CI pipeline.

By executing `make start`, the AWSTerraformStarterKit will be initialized with the provided configuration, and you can proceed with deploying resources on AWS using Terraform.

It's important to note that if your AWS credentials expire or change, you need to update the credentials in the environment variables or the AWS CLI configuration and then restart the AWSTerraformStarterKit by running `make start` again. This ensures that the AWSTerraformStarterKit uses the updated credentials for all AWS operations.

#### Directory Structure overview after AWSTerraformStarterKit starts
```yaml
  Project Root Directory:
   - .backup/:
   - .config/:
   - .editorconfig
   - .env
   - .git
   - .gitignore
   - .gitignore.dist
   - Makefile
   - README.md
   - automation/:
   - configure.yaml
   - configure.yaml.dist
   - docker-compose-dashboard.yml
   - docker-compose-tools.yml
   - docker-compose.yml
   - get-starter-kit.sh
   - makeplan.mk
   - terraform/:
      - common.tfvars
      - network/:
         - main.tf
         - provider.tf
         - parameters.auto.tfvars
         - ...
      - compute/:
         - ...
```
## Help

To get help and list all the available commands in the AWSTerraformStarterKit, you can use the `make help` command. This command will display the available targets and their descriptions from the `Makefile`. 

```bash
$ make help
```
```bash
help                           This help.
debug                          Print debug logs
init                           Generate .env file
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

   For example, if you want to add a plan named "new-plan", the entry would be:

   ```yaml
   plans:
     - terraform/network
     - terraform/compute
     - terraform/new-plan

   ```

4. Save the `configure.yaml` file after adding the new plan name.

After adding the new Terraform plan to the `configure.yaml` file, you can restart the AWSTerraformStarterKit by executing the `make start` command.
This command will generate the necessary templates based on the newly added plan. Here are the steps:

1. Open a terminal or command prompt in the project directory.

2. Run the following command to start the AWSTerraformStarterKit:

   ```bash
   make start
   ```

   This command will trigger the execution of the AWSTerraformStarterKit's Makefile, which includes the logic to generate the required templates.

3. The AWSTerraformStarterKit will read the `configure.yaml` file, identify the added plan, and generate the corresponding templates or configuration files based on the plan's specifications.

4. Once the process completes, you can proceed with using the generated templates for your Terraform deployment.


# Update AWSTerraformStarterKit

1. Download `remove-starter-kit.sh`, make it executable and execute the shell script.  
```bash
curl -o remove-starter-kit.sh https://raw.githubusercontent.com/Orange-OpenSource/AWSTerraformStarterKit/master/remove-starter-kit.sh
chmod +x remove-starter-kit.sh
./remove-starter-kit.sh
```

   `remove-starter-kit.sh` shell script removes all the AWSTerraformStarterKit, the `Makefile` and the `.gitlab-ci.yml`  

```bash
.config exists, will be deleted
automation exists, will be deleted
.gitignore.dist exists, will be deleted
docker-compose.yml exists, will be deleted
docker-compose-tools.yml exists, will be deleted
makeplan.mk exists, will be deleted
.env exists, will be deleted
.editorconfig exists, will be deleted
Makefile exists, will be deleted
```

2. Execute `get-starter-kit.sh` to download the latest version of the AWSTerraformStarterKit (or provide the desired version as argument).

```bash
./get-starter-kit.sh
```

3. Run `make start` 
```bash
make start
```
It will generate `.env` file for Docker environment and regenerate both `Makefile` and `.gitlab-ci.yml`  

> Do not forget to commit the newly generated files

A note regarding `configure.yaml.dist`: this will be committed into your Git repo (beacuse it is not in `.gitignore`). This will help you making a diff with the `configure.yaml.dist` of the release you downloaded and apply the changes in the `configure.yaml` file accordingly.
