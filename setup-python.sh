#!/usr/bin/env bash

# Even though this is set up as a bash script, you must 'source' it to
# work properly and be in a position to move forward.

# Create Python Virtual Environment
python3.10 -m venv venv
source venv/bin/activate

# Install Python required modules
pip install -r requirements.txt

# Install Ansible required collections
ansible-galaxy collection install -r requirements.yaml

# Install Python utilities for NDFC
pip install utils/dcnm_lan_fabric-0.2.4-py3-none-any.whl

# Set up NDFCCTL connection credentials
export NDFC_HOST=198.18.134.200
export NDFC_USER=admin
export NDFC_PASS=C1sco12345

# Set up Ansible switch discovery credentials
export SWITCH_USER=admin
export SWITCH_PASS=C1sco12345
