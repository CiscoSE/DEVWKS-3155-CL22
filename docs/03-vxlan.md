# VXLAN EVPN Fabric Automation

From the previous section, we generated a large (but manageable) list of parameters that could be leveraged in building our VXLAN EVPN fabric definition (here with the '--verbose' added):

```
(optional): BROWNFIELD_NETWORK_NAME_FORMAT      : Generated network name should be &lt; 64 characters                           : Auto_Net_VNI$$VNI$$_VLAN$$VLAN_ID$$
(required): FABRIC_NAME                         : Please provide the fabric name to create it (Max Size 32)                     : 
(required): FABRIC_VPC_QOS_POLICY_NAME          : Qos Policy name should be same on all spines                                  : spine_qos_for_fabric_vpc_peering
(required): ISIS_AUTH_KEYCHAIN_NAME                                                                                             : 
(optional): MSO_SITE_GROUP_NAME                                                                                                 : 
(optional): ADVERTISE_PIP_BGP                   : For Primary VTEP IP Advertisement As Next-Hop Of Prefix Routes                : false
(required): AUTO_SYMMETRIC_VRF_LITE             : Whether to auto generate VRF LITE sub-interface and BGP peering configura...  : false
(optional): BFD_IBGP_ENABLE                                                                                                     : false
(required): BGP_AS                              : 1-4294967295 | 1-65535[.0-65535]<br />It is a good practice to have a uni...  : 
(optional): BGP_AS_PREV                                                                                                         : 
(required): BGP_AUTH_ENABLE                                                                                                     : false
(required): BGP_AUTH_KEY                        : Encrypted BGP Authentication Key based on type                                : 
(required): BGP_AUTH_KEY_TYPE                   : BGP Key Encryption Type: 3 - 3DES, 7 - Cisco                                  : 3
(required): BGP_LB_ID                           : (Min:0, Max:1023)                                                             : 0
(optional): IBGP_PEER_TEMPLATE                  : Speficies the iBGP Peer-Template config used for RR and<br />spines with ...  : 
(optional): IBGP_PEER_TEMPLATE_LEAF             : Specifies the config used for leaf, border or<br /> border gateway.<br />...  : 
(required): abstract_bgp                        : BGP Configuration                                                             : base_bgp
(required): abstract_bgp_neighbor               : BGP Neighbor Configuration                                                    : evpn_bgp_rr_neighbor
(required): abstract_bgp_rr                     : BGP RR Configuration                                                          : evpn_bgp_rr
(required): ANYCAST_RP_IP_RANGE                 : Anycast or Phantom RP IP Address Range                                        : 10.254.254.0/24
(required): DCI_SUBNET_RANGE                    : Address range to assign P2P Interfabric Connections                           : 10.33.0.0/16
(required): LOOPBACK0_IP_RANGE                  : Typically Loopback0 IP Address Range                                          : 10.2.0.0/22
(required): LOOPBACK1_IP_RANGE                  : Typically Loopback1 IP Address Range                                          : 10.3.0.0/22
(required): MPLS_LOOPBACK_IP_RANGE              : Used for VXLAN to MPLS SR/LDP Handoff                                         : 10.101.0.0/25
(required): ROUTER_ID_RANGE                                                                                                     : 10.2.0.0/23
(required): SUBNET_RANGE                        : Address range to assign Numbered and Peer Link SVI IPs                        : 10.4.0.0/16
(optional): ENABLE_NXAPI                        : Enable NX-API on port 443                                                     : true
(optional): ENABLE_NXAPI_HTTP                   : Enable NX-API on port 80                                                      : true
(optional): ENABLE_NGOAM                        : Enable the Next Generation (NG) OAM feature for all switches in the fabri...  : true
(optional): MSO_SITE_GROUP_NAME                                                                                                 : 
(optional): MSO_SITE_ID                                                                                                         : 
(optional): SITE_ID                             : For EVPN Multi-Site Support (Min:1, Max: 281474976710655). <br />Defaults...  : 
```

Now, let's isolate the attributes that make the most sense based on their descriptions and set the required values for our lab:

```json
{
      "FABRIC_NAME": "Brownfield",
      "SITE_ID": "65002",
      "BGP_AS": "65002",
      "ENABLE_NXAPI": "true",
      "ENABLE_NXAPI_HTTP": "true",
      "ENABLE_NGOAM": "true",
      "CDP_ENABLE": "true",
      "PM_ENABLE" : "false",
      "GRFIELD_DEBUG_FLAG": "Enable",
      "LOOPBACK0_IP_RANGE": "20.2.0.0/22",
      "LOOPBACK1_IP_RANGE": "20.3.0.0/22",
      "ANYCAST_RP_IP_RANGE": "20.254.254.0/24",
      "SUBNET_RANGE": "20.4.0.0/16",
      "DCI_SUBNET_RANGE": "20.33.0.0/16"
}
```

Now, we are all set. In the editor on the right, let's add that information to the **ansible/vxlan/01-create-fabric.yaml** playbook and give it a whirl!  Now, normally, you'd ALWAYS use the flag **--check** to ansible-playbook, which in development or production environments I highly recommend.

```bash
cd ansible
export SWITCH_USER=admin
export SWITCH_PASS=C1sco12345
ansible-playbook vxlan/01-create-fabric.yaml
```

```
PLAY [dcnm] ********************************************************************************************************************************************************************************

TASK [Create the VXLAN fabric: 'Brownfield'] ***********************************************************************************************************************************************
ok: [dcloud_dcnm]

PLAY RECAP *********************************************************************************************************************************************************************************
dcloud_dcnm                : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

If your NDFC browser tab is still available, you can check to see if the fabric was created.

Now, fortunately, for the remainder of our network deployment workflow, Ansible covers all the use cases. For the sake of time, we'll quickly review them and then move on.

**Add Switches**

```bash
ansible-playbook 02-add-switches.yaml
```

```

PLAY [dcnm] ********************************************************************************************************************************************************************************

TASK [Add Switches to VXLAN 'Brownfield' fabric] *******************************************************************************************************************************************
[WARNING]: Adding switches to a VXLAN fabric can take a while.  Please be patient...
changed: [dcloud_dcnm]

PLAY RECAP *********************************************************************************************************************************************************************************
dcloud_dcnm                : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

**Create VRFs**

```bash
ansible-playbook 03-vrfs.yaml
```

```
PLAY [dcnm] ********************************************************************************************************************************************************************************

TASK [Create VXLAN EVPN Fabric VRFs (Source of Truth)] *************************************************************************************************************************************
changed: [dcloud_dcnm]

PLAY RECAP *********************************************************************************************************************************************************************************
dcloud_dcnm                : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

**Create Networks**

```bash
ansible-playbook 04-networks.yaml
```

```

PLAY [dcnm] ********************************************************************************************************************************************************************************

TASK [Create VXLAN EVPN Fabric Networks (Source of Truth)] *********************************************************************************************************************************
changed: [dcloud_dcnm]

PLAY RECAP *********************************************************************************************************************************************************************************
dcloud_dcnm                : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

**Configure Interfaces**

```bash
ansible-playbook 05-interfaces.yaml        
```

```
PLAY [dcnm] ********************************************************************************************************************************************************************************

TASK [Configure the Ethernet1/6 interfaces] ************************************************************************************************************************************************
changed: [dcloud_dcnm]

PLAY RECAP *********************************************************************************************************************************************************************************
dcloud_dcnm                : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

## Summary

Now we have a fully configured VXLAN EVPN fabric. These are fairly standard operations that you will undertake in a fabric environment, covering a good 80% of the types of tasks available.

For those more advanced scenarios, the fabric discovery efforts in the previous section as well as the Classic Ethernet build out in the next section will give you the breadth of training needed for advanced templates/policies in either network design.
