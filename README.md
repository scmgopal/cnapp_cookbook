# cnapp

## Overview

This cookbook **installs and configure Tomcat, mod_cluster and Apache** on a Node and **Deploy static files and application**  on top of it.

Please note that this cookbook is created for demonstration purpose and is not production ready. It has some known issues listed in **Known Issues** section.

## Pre-requisites
Softwares needed to setup dev environment using this cookbook:
* VirtualBox (https://www.virtualbox.org/wiki/Downloads)
* chefdk (https://downloads.chef.io/chefdk#windows)
* Vagrant (https://www.vagrantup.com/downloads.html)

Please use standard procedure t install these softwares.

## Setup

vagrant Setup
vagrant virtual box Centos 7, create one with below commands:
```
vagrant box add centos7min https://github.com/holms/vagrant-centos7-box/releases/download/7.1.1503.001/CentOS-7.1.1503-x86_64-netboot.box
vagrant init centos7min
vagrant up
```

First, create a throwaway secret to encrypt testing data.
```
openssl rand -base64 512 > test/integration/default/encrypted_data_bag_secret
```
and then create self signed certificate:
```
openssl genrsa -des3 -out dev.cnapp.com.key 4096
openssl req -new -key dev.cnapp.com.key -out dev.cnapp.com.csr

cp dev.cnapp.com.key dev.cnapp.com.key.org
openssl rsa -in dev.cnapp.com.key.org -out dev.cnapp.com.key

openssl x509 -req -days 365 -in dev.cnapp.com.csr -signkey dev.cnapp.com.key -out dev.cnapp.com.crt

```

and put it in below json format(This data bag should be available on Chef server before converging this cookbook):
```
{
  "id": "certificates",
  "dockerhub_url": "dev.devcnapp.com",
  "private_keys": "-----BEGIN RSA PRIVATE KEY-----\n....\n-----END RSA PRIVATE KEY-----",
  "public_certs": "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----",
  "rootca": "-----BEGIN CERTIFICATE-----\....\n-----END CERTIFICATE-----"
}

```
then create data bag using knife solo:

```
knife solo data bag create cnapp certificates --json-file cnapp.json --data-bag-path test/integration/default --secret-file encrypted_data_bag_secret
```

and then try it out...

```
kitchen converge
```
This will install Apache Httpd, Apache tomcat and configure mod_cluster for setting up communication between them.
Thi also deploys static content and application on top of the setup.

## Known Issues
This cookbook was developed in one day and should be used only for demonstration purpose. It has a few issues which needs to be fixed.
* SSL Certificate not configured in Code yet. (This should be configured in cookbook before using it for even Dev environment)
* "/" url should be redirected to /cmpanyNews/index.jsp
* ChefSpec and Inspec missing. Needs to be reviewed and tested.
* There are few hardcodings in recipes and templates like URLs and Paths. Ideally these should be moved to attributes and secrets to databags.
* Instead of stopping firewall, we should open port 80 for outside world.
* Tomcat restart should be handled in elegant way. Restart should not happen if nothing has changed. and shutdown should happen only when tomcat is already running.
* mod_cluster setup should be done in libraries/definition function.
