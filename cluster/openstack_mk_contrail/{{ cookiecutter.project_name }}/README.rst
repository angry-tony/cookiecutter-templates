
================================================
{{ cookiecutter.project_name }} Reclass Model
================================================

config node
===========

{{ cookiecutter.salt_master_hostname }}

openstack control cluster
=========================

{{ cookiecutter.openstack_control_node01_address }}
{{ cookiecutter.openstack_control_node02_address }}
{{ cookiecutter.openstack_control_node03_address }}


salt model
=========================

To create new cluster use:

.. source-code:: bash

  ./reclass-clone.sh cluster.prod.region01 classes/system/openstack classes/system/linux/system classes/system/horizon/server classes/system/salt/control

  # Example:
  ./reclass-clone.sh cluster.region01 classes/system/openstack classes/system/linux/system classes/system/horizon/server classes/system/salt/control


To reclass existing tree use:

.. source-code:: bash

  ./reclass -h

  # move nodes under new cluster class
  ./reclass.sh system.linux.system cluster.region01 classes/system/reclass/storage/system/region01*

  # rename class definitions
  ./reclass.sh system.openstack system.openstack-mitaka classes/system/openstack/

  # update cluster classes with cluster preffix
  ./reclass.sh system.openstack cluster.region01 classes/cluster/region01/

  # update cluster classes with cluster preffix & rename class paths
  ./reclass.sh -r 's/openstack./openstack-mitaka./' system.openstack cluster.region03 classes/cluster/region03/system/openstack-mitaka/
