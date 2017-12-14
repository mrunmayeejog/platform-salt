{% set pip_index_url = pillar['pip']['index_url'] %}

{% if grains['hadoop.distro'] == 'HDP' %}
{% set anaconda_home = '/opt/pnda/anaconda' %}
{% else %}
{% set anaconda_home = '/opt/cloudera/parcels/Anaconda' %}
{% endif %}

{% set pnda_mirror = pillar['pnda_mirror']['base_url'] %}
{% set deb_packages_path = pnda_mirror + '/mirror_deb' %}
{% set rpm_packages_path = pnda_mirror + '/mirror_rpm' %}
{% set pnda_home_directory = pillar['pnda']['homedir'] %}

{% if grains['os'] == 'Ubuntu' %}
{% set dependency_name_libgssrpc = 'libgssrpc4_1.12+dfsg-2ubuntu5.3_amd64.deb' %}
{% set dependency_name_libkdb5 = 'libkdb5-7_1.12+dfsg-2ubuntu5.3_amd64.deb' %}
{% set dependency_name_libkadm5srv = 'libkadm5srv-mit9_1.12+dfsg-2ubuntu5.3_amd64.deb' %}
{% set dependency_name_libkadm5clnt = 'libkadm5clnt-mit9_1.12+dfsg-2ubuntu5.3_amd64.deb' %}
{% set dependency_name_comerr = 'comerr-dev_2.1-1.42.9-3ubuntu1.3_amd64.deb' %}
{% set dependency_name_krb5 = 'krb5-multidev_1.12+dfsg-2ubuntu5.3_amd64.deb' %}
{% set dependency_name_libpq = 'libpq-dev_9.3.20-0ubuntu0.14.04_amd64.deb' %}

lib_install-dependency-1:
  cmd.run:
    - cwd: {{ pnda_home_directory }}
    - name: wget {{ deb_packages_path }}/{{ dependency_name_libgssrpc }} && dpkg -i {{ dependency_name_libgssrpc }}

lib_install-dependency-2:
  cmd.run:
    - cwd: {{ pnda_home_directory }}
    - name: wget {{ deb_packages_path }}/{{ dependency_name_libkdb5 }} && dpkg -i {{ dependency_name_libkdb5 }}

lib_install-dependency-3:
  cmd.run:
    - cwd: {{ pnda_home_directory }}
    - name: wget {{ deb_packages_path }}/{{ dependency_name_libkadm5srv }} && dpkg -i {{ dependency_name_libkadm5srv }}

lib_install-dependency-4:
  cmd.run:
    - cwd: {{ pnda_home_directory }}
    - name: wget {{ deb_packages_path }}/{{ dependency_name_libkadm5clnt }} && dpkg -i {{ dependency_name_libkadm5clnt }}

lib_install-dependency-5:
  cmd.run:
    - cwd: {{ pnda_home_directory }}
    - name: wget {{ deb_packages_path }}/{{ dependency_name_comerr }} && dpkg -i {{ dependency_name_comerr }}

lib_install-dependency-6:
  cmd.run:
    - cwd: {{ pnda_home_directory }}
    - name: wget {{ deb_packages_path }}/{{ dependency_name_krb5 }} && dpkg -i {{ dependency_name_krb5 }}

lib_install-dependency-7:
  cmd.run:
    - cwd: {{ pnda_home_directory }}
    - name: wget {{ deb_packages_path }}/{{ dependency_name_libpq }} && dpkg -i {{ dependency_name_libpq }}

{% else %}

{% set dependency_name_postgresql = 'postgresql-9.2.23-3.el7_4.x86_64.rpm' %}
{% set dependency_name_postgresql_devel = 'postgresql-devel-9.2.23-3.el7_4.x86_64.rpm' %}
{% set dependency_name_postgresql_lib = 'postgresql-libs-9.2.23-3.el7_4.x86_64.rpm' %}

lib_install-dependency-8:
  cmd.run:
    - cwd: {{ pnda_home_directory }}
    - name: wget {{ rpm_packages_path }}/{{ dependency_name_postgresql_lib }} && rpm -ifvh --replacepkgs {{ dependency_name_postgresql_lib }}

lib_install-dependency-9:
  cmd.run:
    - cwd: {{ pnda_home_directory }}
    - name: wget {{ rpm_packages_path }}/{{ dependency_name_postgresql }} && rpm -ifvh --replacepkgs {{ dependency_name_postgresql }}

lib_install-dependency-10:
  cmd.run:
    - cwd: {{ pnda_home_directory }}
    - name: wget {{ rpm_packages_path }}/{{ dependency_name_postgresql_devel }} && rpm -ifvh --replacepkgs {{ dependency_name_postgresql_devel }}

{% endif %}


jupyter-install_anaconda_deps:
  cmd.run:
     - name: export PATH={{ anaconda_home }}/bin:$PATH;pip install --index-url {{ pip_index_url }} cm-api==14.0.0 avro==1.8.1 ipython-sql==0.3.8 sql-magic==0.0.3 pymysql==0.7.11 impyla==0.14.0 psycopg2==2.7.3.2 thrift==0.9.3
