# Ansible Automation

All Ansible runs should take place in this directory, using commands of the following form:

```bash
ansible-playbook vxlan/01-create-fabric.yaml
```

The [ansible.cfg](./ansible.cfg), [dCloud inventory](./dcloud-inventory.yaml), and [NDFC host variables](./host_vars/dcloud_dcnm.yaml) are rooted in this directory and thus require this approach to running the Ansible for both the [VXLAN](./vxlan/README.md) and [Classic](./classic/README.md) portions of this workshop.

Additionally, you'll almost certainly want to "follow along" in the NDFC GUI.  Once your VPN session has been established **on the local laptop** (not in the learning lab as it has no GUI tools), you'll open a web browser tab and connect to [dCloud NDFC Instance](https://198.18.134.200/appcenter/cisco/ndfc/ui/dashboard).

