# bpg-proxmox-module

This repository contains Terraform modules, based on [bpg/proxmox](https://registry.terraform.io/providers/bpg/proxmox/latest/docs), for provisioning virtual machines on Proxmox using Cloud-Init for configuration management. The modules provide reusable and configurable components that can be used to define and deploy virtual machines in a Proxmox environment.

## Local Development

- Prerequisites

    - [Terraform](https://www.terraform.io/downloads.html) installed on your local machine
    - Access to a Proxmox server or cluster
    - [Creating the Proxmox user and password for terraform](https://registry.terraform.io/providers/bpg/proxmox/latest/docs)
    - SSH Authorized Keys use for logging into the new created virtual machines.
    - terraform-docs: A utility to generate documentation from Terraform modules in various output formats. Installation.

 - Module Development
 To begin your module development, navigate to the modules/bpg-proxmox-module directory, where the module code is located, Remember to run terraform-docs -c .terraform-docs.yml . after updating the code to generate the documentation.

    ```
    .
    ├── modules
    │   └── bpg-proxmox-module
    │       ├── .terraform-docs.yml
    │       ├── README.md
    │       ├── cloud-image.tf
    │       ├── cloud-init.tf
    │       ├── examples
    │       │   ├── local.tf
    │       │   ├── main.tf
    │       │   ├── outputs.tf
    │       │   ├── provider.tf
    │       │   └── variables.tf
    │       ├── footer.md
    │       ├── header.md
    │       ├── outputs.tf
    │       ├── provider.tf
    │       ├── variables.tf
    │       └── vms.tf
    ```

  - Testing Module Locally
  To test the module locally, use the test files located in the root folder.
  
  1. Initial Development Configuration

      1. Create a new file named `localdev-export.sh` by making a copy of the example file:

         ```bash
         cp localdev-export.sh.example localdev-export.sh
         ```

      1. Update the localdev-export.sh file.

      1. Load localdev-export.sh run:

               source ./localdev-export.sh

   1. Update provider.tf
   When updating provider.tf, ensure that its version matches the one specified in modules/bpg-proxmox-module/provider.tf.

   1. After updating, ensure the rest of the .tf files are modified as needed for testing.

   1. Finally, run the Terraform command to test your configuration.

## 📚 Getting Started

1. Log in to GitLab: Sign in to your GitLab account.

### Creating a Project

1. **Select** the **terraform-modules group** where you want to **create** the **project**.
1. Once inside the terraform-modules group, click on the **New project** button.
1. Fill in the necessary details for the new project, including the project name ("**bpg-proxmox-module**") and project path.
1. **Set Visibility Level:** In the group creation form, locate the **Visibility Level** select "**Internal**." This setting ensures that the group and its contents are visible to all logged-in users.
1. Click on the **Create project** button to finalise the creation of the "iac-cicd" project.

## 📚 How to Deploy

To clone a repository from a public GitLab repository and push it to a private GitLab repository, you can follow these steps:

1. Clone the public repository:

    ```
    git clone <public_repository_url>
    ```

1. Navigate into the cloned repository:

    ```
    cd <repository_name>
    ```

1. Add the private repository as a new remote:

    ```
    git remote set-url origin <private_repository_url>
    ```

1. Push the cloned repository to the private repository:

    ```
    git push
    ```

1. Create the tag in the GitLab portal to the GitLab repository to trigger the CI/CD pipeline. The pipeline will build and push it in Terraform Module Registry.

## bpg-proxmox-module-cicd

To use this Terraform module in GitLab CI/CD, please use the bpg-proxmox-module-cicd available at the following [link](https://github.com/jodykpw/bpg-proxmox-module-cicd).

## License

This project is licensed under the MIT License. 

## Donation
If this project has helped save you time during development, I'd greatly appreciate a gesture of gratitude in the form of a cup of coffee :)

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=R2GUUDA73BHQG)

## 🇬🇧🇭🇰 Author Information

* Author: Jody WAN
* Linkedin: https://www.linkedin.com/in/jodywan/
* Website: https://www.jodywan.com