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

### Gitlab-CI requirements

To use the Generated `.gitlab-ci.yaml` pipeline you must met the following conditions:

- **Gitlab runner uses Docker executor**. You must make sure the Gitlab runners selected using `CICD_RUNNER_TAGS` or the default one when no tag specified has docker executor configured.
- the Gitlab CI pipeline requires **distributed caching enabled on the runner** to work properly. This is a direct consequence of using "Docker executor" with caching. more
- the Gitlab CI pipeline requires an **AWS IAM role assumable by the runners** identity when the **"aws-creds" job is enabled** on the Gitlab pipeline

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

# Alternatively you can specify a profile
# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
$ export AWS_PROFILE=myprofile
```
> **Please note that exporting credentials as environment variables may not be the most secure method, especially in shared environments.**

# Utilization
## Start the AWSTerraformStarterKit

Once you have set your AWS credentials in the path and modified the `configure.yaml` file to fit your needs, you can start the AWSTerraformStarterKit using the command `make start`. This command will execute the `make init` command, which performs the following steps:

1. It converts the `configure.yaml` file to a `.env` file. The `.env` file is used to store environment variables required by the AWSTerraformStarterKit.

2. It generates a new `Makefile` based on the `configure.yaml` file. The `Makefile` contains predefined targets and commands that can be executed using the `make` command.

3. It generates a new `gitlab-ci.yml` file by leveraging the information present in the .env file and using a GitLab CI Jinja template file as a blueprint. The resulting gitlab-ci.yml file will reflect the specific configurations and values provided in the .env file, allowing for a customized and automated setup of your GitLab CI pipeline. see [Gitlab-CI prerequisites](#gitlab-ci-requirements)

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

run your own `make help` command in your environement to list all the available commands

help                           This help.
debug                          Print debug logs
init                           Generate .env file
generate                       Generate from template gitlab-ci.yml and Makefile
generate_makefile              Generate Makefile
generate_gitlab_ci             Generate  GitlabCI
start                          Stop the project
stop                           Start the project run the docker containers and process the templates files
down                           Stop the project, stop the docker containers
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

## Customize terraform commands for a plan

You can customize terraform commands by following these steps:

1. Configure commands

   Edit the `configure.yaml` and add the config key depending on the customization you want
   For `init` with the following keys `override_init_parameters`. eg.

   ```yaml
   ...
   plans:
   - name: terraform/compute/app-server
     override_init_parameters: -config=../backend.tfvars
   ...
   ```

   The equivalent terraform command for this configuration would be `cd terraform/compute/app-server && terraform init -config=../backend.tfvars`.

   For  `plan` with the following keys:
   - `override_var_parameters`: This key can be used to override the default parameters. eg.

       ```yaml
       ...
       plans:
         - name: terraform/compute/app-server
           override_var_parameters: -var-file=../compute.tfvars
       ...
       ```

       The equivalent terraform command for this configuration would be `cd terraform/compute/app-server && terraform plan -var-file=../compute.tfvars`.

   - `additional_var_parameters`: This key can be used to add parameters to default parameters. eg.

      ```yaml
      ...
      plans:
        - name: terraform/compute/app-server
          additional_var_parameters: -var-file=../compute.tfvars
      ...
      ```

      The equivalent terraform command for this configuration would be `cd terraform/compute/app-server && terraform plan -var-file=/project/terraform/common.tfvars -var-file=parameters.auto.tfvars -var-file=../compute.tfvars`.

2. Re-generate the `Makefile`

   ```bash
   make start
   ```

   This command will re-generate the local `.env` file, generates and override the automatic content part of the `Makefile` with the new parameter for the updated plan.

## Add custom template

This functionality help render template using the same content of the `configure.yaml` this can be useful for example when you want to render a pipeline as code for another CI like Github Actions. This allow extension of the functionality of the starterkit.

To add custom template, just specify in the `configure.yaml` file  under the `templates` array an entry with `source` key for the template path and the `target` key for the output file. for example:

```yaml
templates:
  - source: templates/.github-actions.yaml.2
    target: .github/workflows/.github-actions.yaml
```

For the entry 0, the starterkit will render the template `templates/.github-actions.yaml.j2` using variables from `configure.yaml` to `.github/workflows/.github-actions.yaml`.

> [!IMPORTANT]
> The directory of the target file must exists. If not rendered file creation will fail.

## Add additional make files

This functionality can be used to add custom target to `Makefile`. This allows to extends functionalities of the starterkit by provider makefile with additional target related to new tools for example.

To add additional make files, follows the following steps:

**step 1:** just specify in the `configure.yaml` file  under the `additional_makefiles` array an entry with the path to the make files. for example:

```yaml
additional_makefiles:
  - project.mk
```

**step 2:** runs the generate target of the project

```shell
make generate
```

The starterkit will include additional make files at the end of the `Makefile` using the `include` key word.

## Pass Custom Environment Variables

This feature allows you to define custom environment variables to be inserted into the generated `.env` file.

### Define Custom Environment Variables

1. **In your path**, define your environment variables using the **SK_** format.

2. If the environment variable key already exists in the `.env` file, it will be replaced with the new value.

3. You can also define custom environment variables in the `configure.yaml` file under the **CUSTOM_ENV** section.

4. Additionally, in the default `gitlab-ci.yml` file, a variable will be automatically inserted with the value in the format `<VARIABLE_NAME>_SECRET`.

Example configuration in `configure.yaml`:

```yaml
####################
# CUSTOM ENV
####################
#CUSTOM_ENV:
#  MYAPI: test
```

### Change the Python Version

The TFenv image is built using the `pyenv` tool, a popular utility that simplifies the management of multiple Python versions. Several Python versions, ranging from Python 3.8 to Python 3.12, are pre-installed in the image.

To switch the Python version for a Terraform plan, simply add a `.python-version` file to the plan's folder. This file should specify the desired Python version, and `pyenv` will automatically switch to that version when executing the plan.

### About Pyenv

Pyenv allows you to easily install and switch between different versions of Python in your environment. It’s highly useful for managing project-specific Python versions without affecting the global system environment.

For more details about Pyenv, you can check out the official repository here: [Pyenv GitHub Repository](https://github.com/pyenv/pyenv).

Example usage:

```bash
# In your plan folder, create a `.python-version` file with the desired Python version
echo "3.9" > .python-version
```

## New command in Makefile

If the command you want to add to the StarterKit does not depend on the configure.yaml file, you can add it to
custome make file and update the `configure.yaml` file accordingly. However, if the command requires some dynamic configuration based on the configure.yaml file, you should create a custom jinja template for the custom make file and configure its target as a custom make file.

For example, in the following example we will add clean up command.

The command template file `project.mk.j2`

```txt
{% for plan in plans %}
{% set plan_name = plan['name'] if 'name' in plan else plan %}
{% set slug = plan_name | replace('/',"_") %}
cleanup_{{ plan['name] }}:
   rm -rf {{ plan_name }}/.terraform
{% endfor %}
```

In the `configure.yaml` file

```yaml
...
templates:
  - source: project.mk.j2
    target: project.mk
...
additional_makefiles:
  - project.mk
...
```

Don't forget to generate files

```shell
make generate
```

## Add dependencies between plans

You can define explicite dependencies between your plans using the key work `depends_on` just like in the example below:

```yaml
...
plans:
- terraform/network
- name: terraform/compute
  depends_on:
  - terraform/network
  - terraform/storage
- name: terraform/storage
  depends_on:
  - terraform/network
- name: terraform/security
...
```

Defining explicit dependency helps organization gitlab jobs in **execution batch**. Execution batch is a stage with attached jobs which doesn't have dependencies with each other within the same stage but have dependencies with the previous stage if any.

This dependency definition also helps generate to correct plan destruction order.


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
It will generate `.env` file for Docker environment and regenerate both `Makefile` and `.gitlab-ci.yml` if the `GENERATE_GITLAB_CI` in `configure.yaml` is set to `True`.

> Do not forget to commit the newly generated files

A note regarding `configure.yaml.dist`: this will be committed into your Git repo (beacuse it is not in `.gitignore`). This will help you making a diff with the `configure.yaml.dist` of the release you downloaded and apply the changes in the `configure.yaml` file accordingly.
