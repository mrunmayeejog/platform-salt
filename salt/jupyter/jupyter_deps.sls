{% set pip_index_url = pillar['pip']['index_url'] %}
{% set pnda_home_directory = pillar['pnda']['homedir'] %}

{% if grains['hadoop.distro'] == 'HDP' %}
{% set anaconda_home = '/opt/pnda/anaconda' %}
{% else %}
{% set anaconda_home = '/opt/cloudera/parcels/Anaconda' %}
{% endif %}

{% set pnda_mirror = pillar['pnda_mirror']['base_url'] %}
{% set deb_packages_path = pnda_mirror + '/mirror_deb' %}
{% set misc_packages_path = pillar['pnda_mirror']['misc_packages_path'] %}
{% set misc_mirror_location = pnda_mirror + misc_packages_path %}

{% if grains['os'] == 'Ubuntu' %}

dependency-installation-libpq:
  pkg.installed:
    - name: {{ pillar['libpq-dev']['package-name'] }}
    - version: {{ pillar['libpq-dev']['version'] }}
    - ignore_epoch: True

{% else %}

dependency-install_gcc-dep:
  pkg.installed:
    - name: {{ pillar['gcc']['package-name'] }}
    - version: {{ pillar['gcc']['version'] }}
    - ignore_epoch: True

dependency-install_postgresql-devel:
  pkg.installed:
    - name: {{ pillar['postgresql-devel']['package-name'] }}
    - version: {{ pillar['postgresql-devel']['version'] }}
    - ignore_epoch: True
{% endif %}


jupyter-install_anaconda_deps:
  cmd.run:
     - name: export PATH={{ anaconda_home }}/bin:$PATH;pip install --index-url {{ pip_index_url }} cm-api==14.0.0 avro==1.8.1 ipython-sql==0.3.8 pymysql==0.7.11 impyla==0.14.0 psycopg2==2.7.3.2 thrift==0.9.3
