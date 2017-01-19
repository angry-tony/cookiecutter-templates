
========================================
OpenStack Cluster Cookiecutter Templates
========================================

A cookiecutter_ templates for generating OpenStack infrastructure models (cluster level).

.. _cookiecutter: https://github.com/audreyr/cookiecutter


Installation
============

.. code-block:: bash

    pip install cookiecutter

    git clone https://github.com/Mirantis/mk2x-cookiecutter-reclass-model.git


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


Available deployments
=====================


kubernetes_mk
-------------

"cluster_domain"
"cluster_name"
"reclass_repository": Repository for this cluster model.

"salt_master_ip": Management IP of salt master, leave blank if not present.
"salt_master_management_ip": IP that is use for salt communication.

"kubernetes_control_address": VIP of control cluster.
"kubernetes_control_node01_address": IP address of Kubernetes control node.
"kubernetes_control_node02_address": IP address of Kubernetes control node.
"kubernetes_control_node03_address": IP address of Kubernetes control node.
"kubernetes_control_node01_deploy_address": PXE IP address of Kubernetes control node, leave blank if not present.
"kubernetes_control_node02_deploy_address": PXE IP address of Kubernetes control node, leave blank if not present.
"kubernetes_control_node03_deploy_address": PXE IP address of Kubernetes control node, leave blank if not present.

"kubernetes_keepalived_vip_interface": Interface that will be used for kubernetes_control_address.

"kubernetes_compute_node01_single_address": IP address of Kubernetes compute node.
"kubernetes_compute_node02_single_address": IP address of Kubernetes compute node.
"kubernetes_compute_node01_deploy_address": PXE IP address of Kubernetes compute node, leave blank if not present.
"kubernetes_compute_node02_deploy_address": PXE IP address of Kubernetes compute node, leave blank if not present.

"cfg01_name": salt master hostname.
"ctl01_name": ctl01 hostname.
"ctl02_name": ctl02 hostname.
"ctl03_name": ctl03 hostname.
"ctl_name": VIP hostname.
"cmp01_name": cmp01 hostname.
"cmp02_name": cmp02 hostname.

"calico_network": network used for calico containers.
"calico_netmask": netmask for calico_network.
"calico_enable_nat": enable NAT from calico containers.

"hyperkube_image": image used for kubernetes services.
"calico_cni_image": image with Calico cni plugins.
"calico_image": image of calico.


openstack_mk_contrail and openstack_mk_ovs
------------------------------------------

"cluster_domain": "cloud.company.com", domain part of FQDN
"cluster_name": "cloud_deploy01"
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
