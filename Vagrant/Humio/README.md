# Vagrant - Humio Test Environment

Vagrant enables users to create and configure lightweight, reproducible, and portable development
environments. What better way to utilize Vagrant than to setup a Humio instance, that can then be used
alongside other Vagrant boxes for getting data in.

## Installation

Use your OS's package manager to install (Vagrant and VirtualBox). The following examples
are based on Mac OSX.

```bash
brew install vagrant
brew install --cask virtualbox
vagrant plugin install docker
```

Tool Refs:
* [Vagrant](https://www.vagrantup.com/docs)

> **NOTE** that I'm using Virtualbox because I found it to be the quickest method for me to easily use
> vagrant. I tried with the parallels plugin, but found it very spotty. I have NOT tested this with
> VMware Fusion, however I do believe it will work, with some minor tweaks.

## Project Layout

```bash
├── README.md
├── Vagrantfile
├── etc
├── humio.conf
└── mounts
    ├── data
    └── kafka-data
```

The heart of this test environment is handled by the [Vagrantfile](./Vagrantfile). By default, Vagrant provides an
easy way to share files between the physical host and the newly spun up virtual machines. This allows
us to take advantage of this sharing, by using the Humio mount points (etc, mounts/{data,kafka-data}, humio.conf).
By using this, we only need to enter our Humio license key the first time we spin up this environment.
You can then freely destroy and recreate it, all while maintaining the Humio data. If you would like
to "start over", you can just remove all the files in the Humio mount points listed earlier.

## Usage

All subsequent commands should be ran from the this directory.

```bash
vagrant up
```
Log into Humio - 10.1.1.2:8080
> The first time you log in, you will enter your license key. You only have to do this once.

## Useful Commands

```bash
# If you have multiple virtualization providers installed, you may have to specify
# virtualbox when bringing your boxes up
vagrant up --provider=virtualbox

# To destroy your environment
vagrant destroy -f

# To SSH into a box
vagrant ssh

# To rebuild a box (aka - something got hosed on one box)
vagrant destroy -f
vagrant up
```
