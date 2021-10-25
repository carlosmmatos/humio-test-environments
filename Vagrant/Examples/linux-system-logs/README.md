# Vagrant - Humio Linux Test Environment

When dealing with Linux logs, it tends to be a little bit easier to work with systemd/init,
therefore a Virtual Machine is preferred over containers. Vagrant helps even more by providing
lightweight, stripped down VM's without all the bloatware. This allows us easy control for adding
packages and working with systemd services.

## Installation

Use your OS's package manager to install (Vagrant, VirtualBox, Ansible). The following examples
are based on Mac OSX.

```bash
brew install vagrant
brew install ansible
brew install --cask virtualbox
vagrant plugin install docker
```

\*Tool Refs:
* [Vagrant](https://www.vagrantup.com/docs)
* [Ansible](https://docs.ansible.com/ansible/2.9/index.html)

> **NOTE** that I'm using Virtualbox because I found it to be the quickest method for me to easily use
> vagrant. I tried with the parallels plugin, but found it very spotty. I have NOT tested this with
> VMware Fusion, however I do believe it will work, with some minor tweaks.

## Project Layout

```bash
.
├── README.md
├── Vagrantfile
├── ansible.cfg
├── etc
├── humio.conf
├── mounts
│   ├── data
│   └── kafka-data
└── provisioning
    ├── filebeat-playbook.yml
    ├── files
    ├── harden.yml
    ├── inventory
    ├── requirements.yml
    ├── rsyslog-playbook.yml
    ├── templates
    └── vars
```

The heart of this test environment is handled by the [Vagrantfile](./Vagrantfile). However, there are a few key
items to discuss:

1. By default, Vagrant provides an easy way to share files between the physical host and the newly
spun up virtual machines. This allows us to take advantage of this sharing, by using the Humio
mount points (etc, mounts/{data,kafka-data}, humio.conf). By using this, we only need to enter our
Humio license
key the first time we spin up this environment. You can then freely destroy and recreate it, all
while maintaining the Humio data. If you would like to "start over", you can just remove all the
files in the Humio mount points listed earlier.

2. Ansible is a great tool for provision systems quickly. In this case, you can use Ansible to
help setup your method of log shipping (either Rsyslog or Filebeat currently). The `provisioning`
directory contains the playbooks and other files needed to faciliate this. The inventory file is
preconfigured for the hosts being created. There is also a `.ssh` directory that contains a key-pair
that is used by Ansible during provisioning.

3. The Ansible provisioning is a collection of roles + tasks. All the configuration changes, or
default values can be found in `provisioning/vars/main.yml`.

## Usage

All subsequent commands should be ran from the this directory.
#### First time usage in order to set up Humio and receive your ingest token for provisioning.

```bash
# Bring up Humio - to be able to enter license + create repos/ingest tokens
vagrant up humio

# Install Ansible dependencies
# NOTE: Installing collections with ansible-galaxy is only supported in ansible 2.9+
ansible-galaxy install -r provisioning/requirements.yml
```

1. Log into Humio - 10.1.1.2:8080
2. Enter the License key, create a repo, and grab an ingest token before proceeding
___
#### Bringing up the Boxes
```bash
# Bring up all the boxes
vagrant up
```
#### Provisioning the Boxes
> *NOTE: You must have an ingest token in order to configure your log shipper method!*
```bash
# After all boxes have successfully finished - Provision the clients
# In this example, we are going to be using the Filebeat log shipper method
ansible-playbook -i provisioning/inventory provisioning/filebeat-playbook.yml -e "ingest_token=INGEST_TOKEN"
```

Verify in Humio that you are now receiving data.

## Useful Commands

```bash
# If you have multiple virtualization providers installed, you may have to specify
# virtualbox when bringing your boxes up
vagrant up --provider=virtualbox

# To destroy your environment
vagrant destroy -f

# You can also just choose a specific box
vagrant destroy <humio|centos|ubuntu|fedora> -f

# To SSH into a box
vagrant ssh <humio|centos|ubuntu|fedora>

# To rebuild a box (aka - something got hosed on one box)
vagrant destroy <humio|centos|ubuntu|fedora> -f
vagrant up <humio|centos|ubuntu|fedora>

# To ensure your Ansible connections are fine with the clients
ansible -i provisioning/inventory clients -m ping

# Run the harden playbook to generate log traffic
ansible-playbook -i provisioning/inventory provisioning/harden.yml
```
