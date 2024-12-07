# REST API and Templates

With the re-platforming of NDFC to the Nexus Dashboard base, the REST API has undergone some restructuring from the DCNM 11.x versions. First and foremost, the Nexus Dashboard platform itself now manages the authentication semantics. Second, the "applications" (or services in ND speak) publish their own REST API independently. Third, NDFC now groups its REST API endpoints based on its underlying micro-services that build up the application. If you've used DCNM and its REST API, you'll recognize the functional names for the API endpoints but the URL structure is a bit different.

## API Endpoints

Okay, history aside, let's look at the REST API. To do that, open a new web browser tab and navigate to the NDFC REST API docs at DevNet's website:

```
https://developer.cisco.com/docs/nexus-dashboard-fabric-controller/12-0-2/#!api-reference-lan
```

Note: NDFC 12.1.1 was released the week before Cisco Live and this session is based on the previous release, 12.0.2. For the APIs covered in this workshop, there is no functional difference between the two versions.

The API reference (for LAN) on this page is auto-generated from the OpenAPI Spec defining the REST API.

For reference, here are the general categories of endpoints:

- Control - Fabrics: Fabric creation, update; config save, preview, deploy; switch removal/RMA
- Control - Inventory: Adding switches to fabric
- Control - Switches: Set switch roles
- "Top Down" LAN VRF Operations: Create, modify, delete VRF; Attach/detach VRFs; Bulk operations
- "Top Down" LAN Network Operations: Create, modify, delete networks; Attach/detach networks; Bulk operations
- Control - Interfaces: Create, modify, delete interfaces; Breakouts; Admin state
- Templates: Create, query, modify, delete templates
- Control - Policies: Create from template, delete policies
- etc...
- Various Operations Categories (e.g. Endpoint Locator, Alarms, Audit Logs)

So, while the API is not a model first design (like ACI, UCS, or Intersight), NDFC does provide REST API endpoints that parallel the typical workflows, which are also paralleled by the Terraform provider and Ansible collections we reviewed in the previous section.

## Templates

The power of NDFC - especially with regards to VXLAN EVPN fabrics - are the templates. Unlike basic config snippet templates, many of the templates within NDFC are actually Python-like entities that can perform complex configuration based on a number of factors (fabric settings, switch role, etc.). The fabric type that is specified when creating the fabric will determine the wide range of settings necessary to allow the fabric to function. A VXLAN fabric type has many settings related to the underlay while a classic Ethernet fabric has very few settings (most related to global switch settings).

There are, of course, very simple configuration templates, like the templates to enabled NX-OS features (feature_interface_vlan_11_1):

```
feature interface-vlan
```

Or perform the typical config snippet with variable substitution (base_ospf):

```
##
##template content

router ospf $$OSPF_TAG$$
  router-id $$LOOPBACK_IP$$

##

```

Or have some built-in Python like logic (create_vlan):

```
##template content

vlan $$VLAN$$

if ($$NAME$$ != \"\") {
  name $$NAME$$
}

if ($$MODE$$ == \"FABRICPATH\") {
  mode fabricpath
}

if ($$VNI$$ != \"\") {
  vn-segment $$VNI$$
}
```

For the purposes of this workshop as well as working with advanced configuration automation with NDFC, it's important to understand the general structure of the templates:

- **parameters**: the variables and their values that are populated to create a specific policy for a switch
- **content**: the actual CLI configlet or Python is used to generate the final NX-OS configuration.

It's a bit of a mind bender but what you and I might consider a configuration template really is the **content** of an NDFC template (which is metadata, parameters, and the content to define a particular policy).

A large portion of our activity in this workshop will be finding the NDFC template, extracting the parameters needed to configure the policy that is based on that NDFC template.

## Policies

Policies are simply the combination of a template, parameter data, and a switch to which we apply it. It's critically important to note that a policy is specific to a single, individual switch. Even if you are creating VLAN 10 on all switches, you'll need a separate policy for each and every switch - with the identical template name and identical parameter data.

## Policy Metadata

Policy ID - String to Uniquely ID the policy
Description - (optional) Description for the policy entry (e.g. 'Ansible Generated')

Switch Serial Number - Unique Identifier for Switch to which this policy is bound
Entity Name - (SWITCH, Ethernet1/1)
Entity Type - (SWITCH, INTERFACE)

Content Type - derives from Template Content Type (TEMPLATE_CLI, PYTHON)
Source - NDFC Entity generating the policy (UNDERLAY, LINK, etc)

Priority - NDFC construct to sort the order in which the generated CLI is applied. I've included a suggestion that I use as a rule of thumb for my labs and demos. No one other than myself endorses these so no implied warranty of any kind.

 - 100: features
 - 200: VLANs
 - 300: Routed Interfaces (and SVIs)
 - 400: Switch Interfaces
 - 500: Generic policy (default)

## References

- [Cisco DevNet Nexus Dashboard Fabric Controller REST API Docs](https://developer.cisco.com/docs/nexus-dashboard-fabric-controller/12-0-2/#!api-reference-lan)
