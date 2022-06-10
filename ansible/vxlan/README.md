# VXLAN EVPN Fabric Automation

In this portion of the workshop, we'll ease into the Ansible operations and NDFC exploration needed to determine what custom REST API or policy creation is required. Given the emphasis on VXLAN EVPN fabric support in Ansible/Terraform, only one playbook in this directory requires modification [fabric creation](./01-create-fabric.yaml). We'll leverage some utilities to determine the missing information and then update the playbook.

If you just want to "skip to the end", working functional Ansible for this entire set of tasks can be found in the [solutions](./solutions/) directory.

## General Instructions

Specific instructions are provided in the learning lab environment. The general flow to complete this workshop, for fabric creation or other API driven tasks, proceeds as follows:

- Finding the appropriate API
- Identify the required payloads
- Update the Ansible to specify the payloads.

## Requirements

Aside from setting up Python and Ansible environment as described in this workshop [README.md](../../README.md), the Ansible commands to run the playbook must be run from this directory's parent directory (DEVWKS-3155-CLUS22/ansible) and not from **this** directory. The required inventory, configuration, and host variables are commonly shared between the VXLAN and Classic set of playbooks and are located there.
