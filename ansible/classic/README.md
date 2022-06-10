# Classic Ethernet Automation

In this portion of the workshop, there will be a great deal more hands on activities to determine the appropriate information necessary to build out our policies and REST API calls within NDFC.  The playbooks in this directory require modifications based on your research into NDFC and will not function properly until correctly configured.

If you just want to "skip to the end", working functional Ansible for this entire set of tasks can be found in the [solutions](./solutions/) directory.

## General Instructions

Specific instructions are provided in the learning lab instructions. The general flow to complete this workshop, however, depends on the action needed. For simply policy creation, we will:

- Find the appropriate template for the task
- Find the parameters needed to configure the policy
- Update the Ansible for the needed template and parameters

For fabric creation or other API driven tasks, we'll augment that approach by:

- Finding the appropriate API
- Identify the required payloads
- Update the Ansible to specify the payloads.

## Requirements

Aside from setting up Python and Ansible environment as described in this workshop [README.md](../../README.md), the Ansible commands to run the playbook must be run from this directory's parent directory (DEVWKS-3155-CLUS22/ansible) and not from **this** directory. The required inventory, configuration, and host variables are commonly shared between the VXLAN and Classic set of playbooks and are located there.
