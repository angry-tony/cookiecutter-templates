cookiecutter-reclass-model
============================

A cookiecutter_ template for tcp cloud OpenStack infrastructure model full
possible setup.

.. _cookiecutter: https://github.com/audreyr/cookiecutter


Installation
============

.. code-block:: bash

    pip install cookiecutter

    git clone git@git.tcpcloud.eu:cookiecutter-templates/cookiecutter-openstack-full-reclass-model.git


Usage
=====

Create new environment definition from `cookiecutter.json.example` and process:

.. code-block:: bash

    CUSTOMER_ENV=<Name>
    cp cookiecutter.json.example ${CUSTOMER_ENV}.json
    ln -s ${CUSTOMER_ENV}.json cookiecutter.json

    # update [FIXME, 'Company.com', etc...]
    $EDITOR cookiecutter.json

    cookiecutter $PWD --output-dir ../../reclass-models [--config-file ${CUSTOMER_ENV}.yaml] [-f] [--no-input]

Advanced, on additional runs, revert files containing generated credentials (ensure you have current state committed in git repo before cookiecutter updates). 
Use `git diff` to find out possible updates:

.. code-block:: bash

  M=$(find . -name credentials.yml;ls classes/system/openssh/client/*)
  git diff $M
  git checkout -- $M

  #find . -name credentials.yml |xargs -I'{}' "git checkout -- {}"
  #git checkout -- classes/system/openssh/client/*



Development and testing
=======================

Before you commit and push back to repo run a test run:

.. code-block:: bash

  cookiecutter $PWD --output-dir /tmp -f --no-input


Parameters
----------

Following parameters need to be provided

* "project_name": "project--salt-model", name of
* "domain_name": "cloud.company.com", domain part of FQDN
* "admin_email": "root@localhost", keystone admin
* "openstack_version": "kilo", openstack version
* "cluster_public_host": "cloud.company.com", openstack API endpoint
* "ssl_endpoint": false,
* "ssl_key": "",
* "ssl_cert": "",
* "ssl_chain": "",
* "opencontrail_version": "2.2", opencontrail version
* "opencontrail_dns": "8.8.8.8",
* "opencontrail_analytics_cluster": true, split analytics to separate cluster
* "metering_cluster": true, deploy multi-node metering instead of single-node
* "ceilometer_cluster": true, deploy multi-node ceilometer instead of single-node
* "sensu_mail_handler": false, deploy sensu mail handler (using admin_email)
* "apt_repository": "", APT repository base URL
* "apt_branch": "nightly", APT repository branch (nightly, testing, stable)
* "cfg01_name": "cfg01", hostnames
* "ctl01_name": "ctl01",
* "ctl02_name": "ctl02",
* "ctl03_name": "ctl03",
* "ntw01_name": "ntw01",
* "ntw02_name": "ntw02",
* "ntw03_name": "ntw03",
* "nal01_name": "nal01",
* "nal02_name": "nal02",
* "nal03_name": "nal03",
* "dbs01_name": "dbs01",
* "dbs02_name": "dbs02",
* "dbs03_name": "dbs03",
* "mdb01_name": "mdb01",
* "mdb02_name": "mdb02",
* "mdb03_name": "mdb03",
* "log01_name": "log01",
* "mon01_name": "mon01",
* "mtr01_name": "mtr01",
* "mtr02_name": "mtr02",
* "prx01_name": "prx01",
* "prx02_name": "prx02",
* "bil01_name": "bil01",
* "cmp01_name": "cmp01",
* "cmp02_name": "cmp02",
* "cfg01_ip": "", IP addresses
* "ctl_vip": "",
* "ctl01_ip": "",
* "ctl02_ip": "",
* "ctl03_ip": "",
* "ntw_vip": "",
* "ntw01_ip": "",
* "ntw02_ip": "",
* "ntw03_ip": "",
* "nal_vip": "",
* "nal01_ip": "",
* "nal02_ip": "",
* "nal03_ip": "",
* "dbs_vip": "",
* "dbs01_ip": "",
* "dbs02_ip": "",
* "dbs03_ip": "",
* "mdb_vip": "",
* "mdb01_ip": "",
* "mdb02_ip": "",
* "mdb03_ip": "",
* "log01_ip": "",
* "mon01_ip": "",
* "mtr_vip": "",
* "mtr01_ip": "",
* "mtr02_ip": "",
* "prx01_ip": "",
* "prx02_ip": "",
* "bil01_ip": "",
* "cmp_gw": "",
* "cmp_iface": "",
* "cmp01_ip": "",
* "cmp02_ip": ""
