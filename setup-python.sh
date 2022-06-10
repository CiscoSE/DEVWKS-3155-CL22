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
