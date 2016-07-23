
================================================
{{ cookiecutter.project_name }} Reclass Model
================================================

config node
===========

{{ cookiecutter.cfg01_name }}

openstack control cluster
=========================

{{ cookiecutter.ctl01_name }}
{{ cookiecutter.ctl02_name }}
{{ cookiecutter.ctl03_name }}


salt model
=========================

To create new cluster use:

.. source-code:: bash

  ./make-cluster.sh prod.region01 classes/system/openstack classes/system/linux/system classes/system/horizon/server classes/system/salt/control

  # Example:
  ./make-cluster.sh region01 classes/system/openstack classes/system/linux/system classes/system/horizon/server classes/system/salt/control


To reclass existing tree use:

.. source-code:: bash

  ./reclass -h

  ./reclass.sh system.openstack system.openstack-mitaka classes/system/openstack/

  ./reclass.sh system.openstack cluster.region01 classes/cluster/region01/

  ./reclass.sh -r 's/openstack./openstack-mitaka./' system.openstack cluster.region03 classes/cluster/region03/system/openstack-mitaka/
