# DEVWKS-3155 Build Your Network Programmatically with Nexus Dashboard Fabric Controller

With the recent release of Nexus Dashboard Fabric Controller (NDFC) and its automation support via Ansible and Terraform, network engineers are able to leverage its rich capabilities to manage their networks at scale in a more declarative fashion.  For more comprehensive automation support, attendees will want to leverage NDFC's OpenAPI-based REST API. This session will provide a general understanding about the API endpoints available. On this foundation, you will then jump right into a detailed investigation of templates, policies, and how they are leveraged to build configurations for your network switches.  Automation Python examples will be made available via GitHub as part of this session.

## Expectations

This is a Cisco Live DevNet 3000-level (expert) course that runs 45 minutes. The time constraints will greatly focus our efforts on the unique knowledge that is being presented today. As such, there is a bit more foundational (and intermediate) knowledge that you are expected to know for the session:

- Python and [Requests Module](https://requests.readthedocs.io)
    - Classes, modules, and data types!  (Oh my!)
- Ansible
    - Understanding Playbooks, Modules.
- REST API (or general Web) workflows
    - Endpoints, Query parameters, HTTP GET/POST, JSON/YAML
- Nexus Dashboard Fabric Controller 12.x (or DCNM 11.x)
    - Save Intent, Recalculate Config, Deploy  
- (optional) VXLAN EVPN fabric and classic Ethernet topologies
    - Spines, Leafs, Core, Access
- (optional) Postman
    - Running Stored Requests, Environments for Credentials

## Outline

In this workshop, you will cover the following topics:

1. [NDFC Operational Overview](./01-intro.md)
1. [REST API and Templates](./02-templated.md)
1. [Environment Setup and Tutorial](./02a-setup.md)
1. [Building VXLAN EVPN Fabrics](./03-vxlan.md)
1. [Building Classic Ethernet Networks](./04-classic.md)

## Workshop Requirements

This workshop leverages the Cisco dCloud demo ["Cisco NDFC for VXLAN EVPN Multi-Site Deployments Lab v1"](https://dcloud2-rtp.cisco.com/content/demo/823572). As part of the live, in-person Cisco Live 2022 event, this workshop environment has been pre-provisioned for you.

VPN connectivity into this demo environment is **required**. The credentials for the environment are available once the environment has been deployed. Since this reservation was done on your behalf, the credentials and connection information will be provided to you on handouts.

This learning lab environment will provide you with all the pre-requisite software. For your information, those dependencies are:

- Python 3.9+
    - REST API dependencies in requirements.txt
- Ansible
- Terraform
- Nexus Dashboard Fabric Controller 12.0.2f
