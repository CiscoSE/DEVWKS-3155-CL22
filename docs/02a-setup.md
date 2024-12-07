# Environment Setup and Tutorial

Let's get started with the hands on portion of this workshop.

## Environment Setup

To ensure we have the latest version of the workshop repository, clone the GitHub repository for this workshop:

```bash
cd ${HOME}/src
git clone https://github.com/CiscoSE/DEVWKS-3155-CL22
cd DEVWKS-3155-CL22
```

Next, build the Python virtual environment, install Ansible, and install some Python utilities.

```bash
source setup-python.sh
```

Finally, we need to connect your particular cloud instance of the workshop into your assigned dCloud lab instance using the VPN credentials that have been provided at your laptop station. I apologize, you'll have to type these lines with the provided credentials into the Terminal window by hand.

```
# Set the VPN credentials
export VPN_SERVER=
export VPN_USERNAME=
export VPN_PASSWORD=

# Fire it up
startvpn.sh &
```

At this point, we can test the VPN connection into your specific lab environment by attempting to log into the NDFC appliance.  Please note: we are only going to **attempt the connection**, we will **not fully log in** and will be aborting it via ctrl-c.

```bash
ssh rescue-user@198.18.134.200
```

```
The authenticity of host '198.18.134.200 (198.18.134.200)' can't be established.
RSA key fingerprint is SHA256:QGN1tOCXOeidm6pwQB9DEm0H/2TQCxysqEbWaPfGR3g.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

If you get the specified output, your VPN connections are working. Simply hit Ctrl-C to abort the connection attempt to move on to the next step in the workshop. Otherwise, we can look at the log file to see if there's anything revealing about why the VPN tunnel is not working:

```bash
# SKIP THIS STEP IF YOUR VPN IS WORKING
cat /var/log/openconnect/openconnect.log
```

## Python Utilities

The Python utility provided is a command **ndfcctl** and will allow us to interact with NDFC and the Templates micro-service. One more set of environment variables are required for the NDFC credentials:

```bash
export NDFC_HOST=198.18.134.200
export NDFC_USER=admin
export NDFC_PASS=C1sco12345
```

With a functional VPN tunnel and credentials defined, we'll be able to connect to the REST API and get some information:

```bash
ndfcctl --no-tls template list --filter feature
```

```
base_feature_leaf
base_feature_leaf_ebgp
base_feature_leaf_evpn
base_feature_leaf_upg
base_feature_spine
base_feature_spine_upg
base_feature_vpc
ext_multisite_rs_base_feature
feature_bfd
feature_bgp
feature_dhcp
feature_fhrp
feature_interface_vlan_11_1
feature_isis
feature_lacp
feature_macsec
feature_mpls
feature_mpls_ldp
feature_mpls_sr
feature_mpls_vpn
feature_msdp
feature_netflow
feature_ngmvpn
feature_ngoam
feature_nv_overlay
feature_nxapi
feature_ospf
feature_ospfv3
feature_pbr
feature_pim
feature_ptp
feature_pvlan
feature_tacacs
feature_telnet
feature_tunnel_encryption
feature_vlan_based_vnsegment_11_1
install_feature_mpls
vpc_pair_feature_lacp
```

The utility has a limited set of functions that you can explore with the help of your typical **--help**.

## How to Define a Fabric

To put context around the material we've just covered and provide a bit of a tutorial for the general workflow we are going to leverage throughout this workshop, let's look at a task common to both network styles (VXLAN EVPN and Classic Ethernet fabrics) - creating the fabric itself. As a reminder from the previous section, our general task has the following general steps:

- Identify the template by name
- Identify the parameters and their values
- Create the policy based on that information

Fortunately, with fabric creation, the first step is straightforward because the fabric template name directly maps to the network fabric type:

- Easy_Fabric template is used for VXLAN EVPN fabrics
- LAN_Classic template is used for Classic Ethernet fabrics

However, to illustrate the first step with our tool, let's find templates containing 'fabric':

```bash
ndfcctl --no-tls template list --filter fabric
```

```
Easy_Fabric
Easy_Fabric_Extn_11_1
Easy_Fabric_Extn_ios_xe
Easy_Fabric_IOS_XE
Easy_Fabric_eBGP
External_Fabric
External_Fabric_Extn
External_Fabric_Extn_ptp
Fabric_Group
MSD_Fabric
MSD_Fabric_File_Extn
ext_fabric_intf
ext_fabric_multisite_intf_11_1
ext_fabric_setup
ext_int_fabric_mpls_uplink
ext_int_fabric_mpls_uplink_po
ext_routed_fabric
external_fabric_freeform
fabric_cloudsec_oper_status
fabric_macsec_oper_status
fabric_nve_vni_counter
fabric_resources
fabric_upgrade_11_1
fabric_upgrade_ios_xe
fabric_utility_11_1
int_fabric_ipv6_link_local
int_fabric_loopback_11_1
int_fabric_num_11_1
int_fabric_phantom_rp_loopback_11_1
int_fabric_unnum_11_1
int_fabric_vlan_11_1
int_intra_fabric_ipv6_link_local
int_intra_fabric_num_link
int_intra_fabric_unnum_link
int_pre_provision_intra_fabric_link
interface_port_type_fabric
ios_xe_int_fabric_num
ios_xe_int_intra_fabric_num_link
p2p_fabric_interface
preFabricDelete_ExtFab
show_fex_fabric
unnumbered_fabric_interface
unnumbered_fabric_interface_nov6
vpc_fabric_pair_lb_id
vpc_pair_enable_fabricpath
vpc_pair_fabricpath
vpc_pair_install_fabricpath
vpc_pair_peer_link_fabric_path
```

As you can see, if the NDFC Configuration Guide didn't provide the fabric type guidance, we'd have a bit more exploration to determine the right template. We can get better detail using the utility as well (case sensitive, exact match):

```bash
ndfcctl --no-tls template get Easy_Fabric
```

```
Name: Easy_Fabric
Description:  Fabric Template for a VXLAN EVPN deployment with Nexus 9000 and 3000 switches.
Template Type: FABRIC
Template SubType: NA
Content Type: PYTHON
Supported Platforms: All
```

Clearly, we found the correct VXLAN EVPN fabric for our purposes.  What about the template parameters?

```bash
ndfcctl --no-tls template get Easy_Fabric --nvpairs
```

```
(optional): AAA_REMOTE_IP_ENABLED               : false
(optional): AAA_SERVER_CONF                     : 
(required): ACTIVE_MIGRATION                    : false
(optional): ADVERTISE_PIP_BGP                   : false
(optional): AGENT_INTF                          : eth0
(optional): ANYCAST_BGW_ADVERTISE_PIP           : false
(required): ANYCAST_GW_MAC                      : 2020.0000.00aa
(required): ANYCAST_LB_ID                       : 10
(required): ANYCAST_RP_IP_RANGE                 : 10.254.254.0/24
(optional): ANYCAST_RP_IP_RANGE_INTERNAL        : 
(required): AUTO_SYMMETRIC_VRF_LITE             : false
(optional): BFD_AUTH_ENABLE                     : false
(optional): BFD_AUTH_KEY                        : 
(optional): BFD_AUTH_KEY_ID                     : 100
(optional): BFD_ENABLE                          : false
(optional): BFD_IBGP_ENABLE                     : false
(optional): BFD_ISIS_ENABLE                     : false
(optional): BFD_OSPF_ENABLE                     : false
(optional): BFD_PIM_ENABLE                      : false
(required): BGP_AS                              : 
(optional): BGP_AS_PREV                         : 
(required): BGP_AUTH_ENABLE                     : false
(required): BGP_AUTH_KEY                        : 
(required): BGP_AUTH_KEY_TYPE                   : 3
(required): BGP_LB_ID                           : 0
(optional): BOOTSTRAP_CONF                      : 
(optional): BOOTSTRAP_ENABLE                    : false
(optional): BOOTSTRAP_MULTISUBNET               : #Scope_Start_IP, Scope_End_IP, Scope_Default_Gateway, Scope_Subnet_Prefix
(optional): BOOTSTRAP_MULTISUBNET_INTERNAL      : 
(optional): BRFIELD_DEBUG_FLAG                  : Disable
(optional): BROWNFIELD_NETWORK_NAME_FORMAT      : Auto_Net_VNI$$VNI$$_VLAN$$VLAN_ID$$
(optional): CDP_ENABLE                          : false
(required): COPP_POLICY                         : strict
(required): DCI_SUBNET_RANGE                    : 10.33.0.0/16
(required): DCI_SUBNET_TARGET_MASK              : 30
(required): DEAFULT_QUEUING_POLICY_CLOUDSCALE   : queuing_policy_default_8q_cloudscale
(required): DEAFULT_QUEUING_POLICY_OTHER        : queuing_policy_default_other
(required): DEAFULT_QUEUING_POLICY_R_SERIES     : queuing_policy_default_r_series
(optional): DEPLOYMENT_FREEZE                   : false
(optional): DHCP_ENABLE                         : false
(required): DHCP_END                            : 
(optional): DHCP_END_INTERNAL                   : 
(optional): DHCP_IPV6_ENABLE                    : DHCPv4
(optional): DHCP_IPV6_ENABLE_INTERNAL           : 
(required): DHCP_START                          : 
(optional): DHCP_START_INTERNAL                 : 
(optional): DNS_SERVER_IP_LIST                  : 
(optional): DNS_SERVER_VRF                      : 
(optional): ENABLE_AAA                          : false
(optional): ENABLE_AGENT                        : false
(optional): ENABLE_DEFAULT_QUEUING_POLICY       : false
(required): ENABLE_EVPN                         : true
(optional): ENABLE_FABRIC_VPC_DOMAIN_ID         : false
(optional): ENABLE_FABRIC_VPC_DOMAIN_ID_PREV    : 
(optional): ENABLE_MACSEC                       : false
(optional): ENABLE_NETFLOW                      : false
(optional): ENABLE_NETFLOW_PREV                 : 
(optional): ENABLE_NGOAM                        : true
(optional): ENABLE_NXAPI                        : true
(optional): ENABLE_NXAPI_HTTP                   : true
(optional): ENABLE_PBR                          : false
(optional): ENABLE_TENANT_DHCP                  : true
(optional): ENABLE_TRM                          : false
(optional): ENABLE_VPC_PEER_LINK_NATIVE_VLAN    : false
(optional): EXTRA_CONF_INTRA_LINKS              : 
(optional): EXTRA_CONF_LEAF                     : 
(optional): EXTRA_CONF_SPINE                    : 
(required): FABRIC_INTERFACE_TYPE               : p2p
(required): FABRIC_MTU                          : 9216
(optional): FABRIC_MTU_PREV                     : 9216
(required): FABRIC_NAME                         : 
(required): FABRIC_TYPE                         : Switch_Fabric
(required): FABRIC_VPC_DOMAIN_ID                : 1
(optional): FABRIC_VPC_DOMAIN_ID_PREV           : 
(optional): FABRIC_VPC_QOS                      : false
(required): FABRIC_VPC_QOS_POLICY_NAME          : spine_qos_for_fabric_vpc_peering
(optional): FEATURE_PTP                         : false
(required): FEATURE_PTP_INTERNAL                : false
(required): FF                                  : Easy_Fabric
(required): GRFIELD_DEBUG_FLAG                  : Disable
(optional): HD_TIME                             : 180
(optional): IBGP_PEER_TEMPLATE                  : 
(optional): IBGP_PEER_TEMPLATE_LEAF             : 
(required): ISIS_AUTH_ENABLE                    : false
(required): ISIS_AUTH_KEY                       : 
(required): ISIS_AUTH_KEYCHAIN_KEY_ID           : 127
(required): ISIS_AUTH_KEYCHAIN_NAME             : 
(required): ISIS_LEVEL                          : level-2
(required): ISIS_OVERLOAD_ELAPSE_TIME           : 60
(required): ISIS_OVERLOAD_ENABLE                : true
(required): ISIS_P2P_ENABLE                     : true
(required): L2_HOST_INTF_MTU                    : 9216
(optional): L2_HOST_INTF_MTU_PREV               : 9216
(required): L2_SEGMENT_ID_RANGE                 : 30000-49000
(required): L3VNI_MCAST_GROUP                   : 239.1.1.0
(required): L3_PARTITION_ID_RANGE               : 50000-59000
(required): LINK_STATE_ROUTING                  : ospf
(required): LINK_STATE_ROUTING_TAG              : UNDERLAY
(optional): LINK_STATE_ROUTING_TAG_PREV         : 
(required): LOOPBACK0_IPV6_RANGE                : fd00::a02:0/119
(required): LOOPBACK0_IP_RANGE                  : 10.2.0.0/22
(required): LOOPBACK1_IPV6_RANGE                : fd00::a03:0/118
(required): LOOPBACK1_IP_RANGE                  : 10.3.0.0/22
(required): MACSEC_ALGORITHM                    : AES_128_CMAC
(required): MACSEC_CIPHER_SUITE                 : GCM-AES-XPN-256
(required): MACSEC_FALLBACK_ALGORITHM           : AES_128_CMAC
(required): MACSEC_FALLBACK_KEY_STRING          : 
(required): MACSEC_KEY_STRING                   : 
(required): MACSEC_REPORT_TIMER                 : 5
(required): MGMT_GW                             : 
(optional): MGMT_GW_INTERNAL                    : 
(required): MGMT_PREFIX                         : 24
(optional): MGMT_PREFIX_INTERNAL                : 
(optional): MGMT_V6PREFIX                       : 64
(optional): MGMT_V6PREFIX_INTERNAL              : 
(required): MPLS_HANDOFF                        : false
(required): MPLS_LB_ID                          : 101
(required): MPLS_LOOPBACK_IP_RANGE              : 10.101.0.0/25
(optional): MSO_CONNECTIVITY_DEPLOYED           : 
(optional): MSO_CONTROLER_ID                    : 
(optional): MSO_SITE_GROUP_NAME                 : 
(optional): MSO_SITE_ID                         : 
(required): MULTICAST_GROUP_SUBNET              : 239.1.1.0/25
(required): NETFLOW_EXPORTER_LIST               : 
(required): NETFLOW_MONITOR_LIST                : 
(required): NETFLOW_RECORD_LIST                 : 
(required): NETWORK_VLAN_RANGE                  : 2300-2999
(optional): NTP_SERVER_IP_LIST                  : 
(optional): NTP_SERVER_VRF                      : 
(required): NVE_LB_ID                           : 1
(required): OSPF_AREA_ID                        : 0.0.0.0
(required): OSPF_AUTH_ENABLE                    : false
(required): OSPF_AUTH_KEY                       : 
(required): OSPF_AUTH_KEY_ID                    : 127
(optional): OVERLAY_MODE                        : config-profile
(optional): OVERLAY_MODE_PREV                   : 
(required): PHANTOM_RP_LB_ID1                   : 2
(required): PHANTOM_RP_LB_ID2                   : 3
(required): PHANTOM_RP_LB_ID3                   : 4
(required): PHANTOM_RP_LB_ID4                   : 5
(required): PIM_HELLO_AUTH_ENABLE               : false
(required): PIM_HELLO_AUTH_KEY                  : 
(optional): PM_ENABLE                           : false
(optional): PM_ENABLE_PREV                      : false
(required): POWER_REDUNDANCY_MODE               : ps-redundant
(optional): PREMSO_PARENT_FABRIC                : 
(required): PTP_DOMAIN_ID                       : 0
(required): PTP_LB_ID                           : 0
(required): REPLICATION_MODE                    : Multicast
(required): ROUTER_ID_RANGE                     : 10.2.0.0/23
(required): ROUTE_MAP_SEQUENCE_NUMBER_RANGE     : 1-65534
(required): RP_COUNT                            : 2
(required): RP_LB_ID                            : 254
(required): RP_MODE                             : asm
(required): RR_COUNT                            : 2
(required): SERVICE_NETWORK_VLAN_RANGE          : 3000-3199
(optional): SITE_ID                             : 
(optional): SNMP_SERVER_HOST_TRAP               : true
(optional): SPINE_COUNT                         : 0
(required): SSPINE_ADD_DEL_DEBUG_FLAG           : Disable
(optional): SSPINE_COUNT                        : 0
(optional): STATIC_UNDERLAY_IP_ALLOC            : false
(required): STRICT_CC_MODE                      : false
(required): SUBINTERFACE_RANGE                  : 2-511
(required): SUBNET_RANGE                        : 10.4.0.0/16
(required): SUBNET_TARGET_MASK                  : 30
(optional): SYSLOG_SERVER_IP_LIST               : 
(optional): SYSLOG_SERVER_VRF                   : 
(optional): SYSLOG_SEV                          : 
(optional): TCAM_ALLOCATION                     : true
(required): UNDERLAY_IS_V6                      : false
(required): USE_LINK_LOCAL                      : true
(required): V6_SUBNET_RANGE                     : fd00::a04:0/112
(required): V6_SUBNET_TARGET_MASK               : 126
(required): VPC_AUTO_RECOVERY_TIME              : 360
(required): VPC_DELAY_RESTORE                   : 150
(required): VPC_DELAY_RESTORE_TIME              : 60
(optional): VPC_DOMAIN_ID_RANGE                 : 1-1000
(optional): VPC_ENABLE_IPv6_ND_SYNC             : true
(required): VPC_PEER_KEEP_ALIVE_OPTION          : management
(optional): VPC_PEER_LINK_PO                    : 500
(required): VPC_PEER_LINK_VLAN                  : 3600
(required): VRF_LITE_AUTOCONFIG                 : Manual
(required): VRF_VLAN_RANGE                      : 2000-2299
(required): abstract_anycast_rp                 : anycast_rp
(required): abstract_bgp                        : base_bgp
(required): abstract_bgp_neighbor               : evpn_bgp_rr_neighbor
(required): abstract_bgp_rr                     : evpn_bgp_rr
(required): abstract_dhcp                       : base_dhcp
(required): abstract_extra_config_bootstrap     : extra_config_bootstrap_11_1
(required): abstract_extra_config_leaf          : extra_config_leaf
(required): abstract_extra_config_spine         : extra_config_spine
(required): abstract_feature_leaf               : base_feature_leaf_upg
(required): abstract_feature_spine              : base_feature_spine_upg
(required): abstract_isis                       : base_isis_level2
(required): abstract_isis_interface             : isis_interface
(required): abstract_loopback_interface         : int_fabric_loopback_11_1
(required): abstract_multicast                  : base_multicast_11_1
(required): abstract_ospf                       : base_ospf
(required): abstract_ospf_interface             : ospf_interface_11_1
(required): abstract_pim_interface              : pim_interface
(required): abstract_route_map                  : route_map
(required): abstract_routed_host                : int_routed_host
(required): abstract_trunk_host                 : int_trunk_host
(required): abstract_vlan_interface             : int_fabric_vlan_11_1
(required): abstract_vpc_domain                 : base_vpc_domain_11_1
(required): default_network                     : Default_Network_Universal
(required): default_vrf                         : Default_VRF_Universal
(optional): enableRealTimeBackup                : 
(optional): enableScheduledBackup               : 
(required): network_extension_template          : Default_Network_Extension_Universal
(required): scheduledTime                       : 
(required): temp_anycast_gateway                : anycast_gateway
(required): temp_vpc_domain_mgmt                : vpc_domain_mgmt
(required): temp_vpc_peer_link                  : int_vpc_peer_link_po
(required): vrf_extension_template              : Default_VRF_Extension_Universal
```

To get a better description of each parameter, we can add a **--verbose** flag (first 10 results only):

```bash
ndfcctl --no-tls template get Easy_Fabric --nvpairs --verbose | head -10
```

```
(optional): AAA_REMOTE_IP_ENABLED               : Enable only, when IP Authorization is enabled in the AAA Server               : false
(optional): AAA_SERVER_CONF                     : AAA Configurations                                                            : 
(required): ACTIVE_MIGRATION                                                                                                    : false
(optional): ADVERTISE_PIP_BGP                   : For Primary VTEP IP Advertisement As Next-Hop Of Prefix Routes                : false
(optional): AGENT_INTF                          : Interface to connect to Agent                                                 : eth0
(optional): ANYCAST_BGW_ADVERTISE_PIP           : To advertise Anycast Border Gateway PIP as VTEP. Effective on MSD fabric ...  : false
(required): ANYCAST_GW_MAC                      : Shared MAC address for all leafs (xxxx.xxxx.xxxx)                             : 2020.0000.00aa
(required): ANYCAST_LB_ID                       : Used for vPC Peering in VXLANv6 Fabrics (Min:0, Max:1023)                     : 10
(required): ANYCAST_RP_IP_RANGE                 : Anycast or Phantom RP IP Address Range                                        : 10.254.254.0/24
(optional): ANYCAST_RP_IP_RANGE_INTERNAL                                                                                        : 
```

Honestly, for a fabric type as complex as VXLAN EVPN fabrics, a safer path might be creating the fabric first, extract the parameters, and then test your automation with those parameters. At the very least, you'll want the NDFC GUI open to a sample fabric creation menu and align the parameters you see from the tool with the menu options on the screen.

The LAN_Classic fabric is a bit more manageable:

```bash
ndfcctl --no-tls template get LAN_Classic --nvpairs
```

```
(optional): AAA_REMOTE_IP_ENABLED               : false
(optional): AAA_SERVER_CONF                     : 
(optional): BOOTSTRAP_CONF                      : 
(optional): BOOTSTRAP_ENABLE                    : false
(optional): BOOTSTRAP_MULTISUBNET               : #Scope_Start_IP, Scope_End_IP, Scope_Default_Gateway, Scope_Subnet_Prefix
(optional): BOOTSTRAP_MULTISUBNET_INTERNAL      : 
(optional): CDP_ENABLE                          : false
(optional): DCI_SUBNET_RANGE                    : 10.10.1.0/24
(optional): DCI_SUBNET_TARGET_MASK              : 30
(optional): DEPLOYMENT_FREEZE                   : false
(optional): DHCP_ENABLE                         : false
(required): DHCP_END                            : 
(optional): DHCP_END_INTERNAL                   : 
(optional): DHCP_IPV6_ENABLE                    : DHCPv4
(optional): DHCP_IPV6_ENABLE_INTERNAL           : 
(required): DHCP_START                          : 
(optional): DHCP_START_INTERNAL                 : 
(optional): ENABLE_AAA                          : false
(optional): ENABLE_NETFLOW                      : false
(optional): ENABLE_NETFLOW_PREV                 : 
(optional): ENABLE_NXAPI                        : false
(optional): ENABLE_NXAPI_HTTP                   : false
(optional): FABRIC_FREEFORM                     : 
(required): FABRIC_NAME                         : 
(required): FABRIC_TECHNOLOGY                   : LANClassic
(required): FABRIC_TYPE                         : External
(optional): FEATURE_PTP                         : false
(required): FEATURE_PTP_INTERNAL                : false
(required): FF                                  : LANClassic
(optional): INBAND_MGMT                         : false
(optional): INBAND_MGMT_PREV                    : false
(required): IS_READ_ONLY                        : true
(optional): LOOPBACK0_IP_RANGE                  : 10.1.0.0/22
(required): MGMT_GW                             : 
(optional): MGMT_GW_INTERNAL                    : 
(required): MGMT_PREFIX                         : 24
(optional): MGMT_PREFIX_INTERNAL                : 
(optional): MGMT_V6PREFIX                       : 64
(optional): MGMT_V6PREFIX_INTERNAL              : 
(required): MPLS_HANDOFF                        : false
(required): MPLS_LB_ID                          : 101
(required): MPLS_LOOPBACK_IP_RANGE              : 10.102.0.0/25
(required): NETFLOW_EXPORTER_LIST               : 
(required): NETFLOW_MONITOR_LIST                : 
(required): NETFLOW_RECORD_LIST                 : 
(optional): PM_ENABLE                           : false
(optional): PM_ENABLE_PREV                      : false
(required): POWER_REDUNDANCY_MODE               : ps-redundant
(required): PTP_DOMAIN_ID                       : 0
(required): PTP_LB_ID                           : 0
(optional): SNMP_SERVER_HOST_TRAP               : true
(required): SUBINTERFACE_RANGE                  : 2-511
(optional): enableRealTimeBackup                : false
(optional): enableScheduledBackup               : false
(required): scheduledTime                       : 
```

As a set up for our next task, let's look at the GUI for a Brownfield fabric creation and then identify the parameters that we need in order to create it programmatically.

The following are shortcuts based on what we see in the GUI:

```bash
for i in NAME BGP 10. NXAPI NGOAM SITE; do ndfcctl --no-tls template get Easy_Fabric --nvpairs | fgrep $i; done
```

We'll see in the next section that output (since that's where we'll be making changes and pushing configs)...
