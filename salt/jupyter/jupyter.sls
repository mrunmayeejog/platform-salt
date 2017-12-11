{% set pnda_home_directory = pillar['pnda']['homedir'] %}
{% set virtual_env_dir = pnda_home_directory + '/jupyter' %}
{% set pip_index_url = pillar['pip']['index_url'] %}
{% set jupyter_kernels_dir = '/usr/local/share/jupyter/kernels' %}
{% set app_packages_home = pnda_home_directory + '/app-packages' %}
{% set jupyter_extension_venv = pnda_home_directory + '/jupyter-extensions' %}
{% set pnda_user  = pillar['pnda']['user'] %}

{% if pillar['hadoop.distro'] == 'HDP' %}
{% set anaconda_home = '/opt/pnda/anaconda' %}
{% set spark_home = '/usr/hdp/current/spark-client' %}
{% set hadoop_conf_dir = '/etc/hadoop/conf' %}
{% else %}
{% set anaconda_home = '/opt/cloudera/parcels/Anaconda' %}
{% set spark_home = '/opt/cloudera/parcels/CDH/lib/spark' %}
{% set hadoop_conf_dir = '/etc/hadoop/conf.cloudera.yarn01' %}
{% endif %}


{% set ipython2_path = anaconda_home + '/lib/python2.7/site-packages/sql' %}
{% set ipython3_path = virtual_env_dir + '/lib/python3.4/site-packages/sql' %}



include:
  - python-pip
  - python-pip.pip3
  - .jupyter_deps


jupyter-create-venv:
  virtualenv.managed:
    - name: {{ virtual_env_dir }}
    - python: python3
    - requirements: salt://jupyter/files/requirements-jupyter.txt
    - index_url: {{ pip_index_url }}
    - require:
      - pip: python-pip-install_python_pip

jupyter-create_notebooks_directory:
  file.directory:
    - name: '{{ pnda_home_directory }}/jupyter_notebooks'
    - user: {{ pillar['pnda']['user'] }}

jupyter-copy_initial_notebooks:
  file.recurse:
    - source: 'salt://jupyter/files/notebooks'
    - name: '{{ pnda_home_directory }}/jupyter_notebooks'
    - require:
      - file: jupyter-create_notebooks_directory

jupyter-create_pam_login_script:
  file.managed:
    - source: salt://jupyter/templates/jupyterhub-create_notebook_dir.sh.tpl
    - name: /root/create_notebook_dir.sh
    - user: root
    - group: root
    - mode: 744
    - template: jinja
    - defaults:
      example_notebooks_dir: '{{ pnda_home_directory }}/jupyter_notebooks'
      pnda_user: {{ pnda_user }}

jupyter-create_pam_login_rule:
  file.append:
    - name: /etc/pam.d/login
    - text: |
        auth    required    pam_exec.so    debug log=/var/log/pnda/login.log /root/create_notebook_dir.sh

# install jupyter kernels (python2, python3, and pyspark)
jupyter-install_python2_kernel:
  cmd.run:
    - name: '{{ anaconda_home }}/bin/python -m ipykernel.kernelspec --name anacondapython2 --display-name "Python 2 (Anaconda)"'
    - require:
      - virtualenv: jupyter-create-venv

jupyter-create_pyspark_kernel_dir:
  file.directory:
    - name: {{ jupyter_kernels_dir }}/pyspark
    - makedirs: True

jupyter-copy_pyspark_kernel:
  file.managed:
    - source: salt://jupyter/templates/pyspark_kernel.json.tpl
    - name: {{ jupyter_kernels_dir }}/pyspark/kernel.json
    - template: jinja
    - require:
      - file: jupyter-create_pyspark_kernel_dir
    - defaults:
        anaconda_home: {{ anaconda_home }}
        spark_home: {{ spark_home }}
        hadoop_conf_dir: {{ hadoop_conf_dir }}
        app_packages_home: {{ app_packages_home }}
        jupyter_extension_venv: {{ jupyter_extension_venv }}

#copy data-generator.py script
jupyter-copy_data_generator_script:
  file.managed:
    - source: salt://jupyter/files/data_generator.py
    - name: {{ pnda_home_directory }}/data_generator.py
    - mode: 555




##### impala
dependency-configurations-python2:
 cmd.run:
    - name: sed -i "s/if 'mssql' not in str(conn.dialect):/if config.autocommit and ('mssql' not in str(conn.dialect)):/" {{ ipython2_path }}/run.py && sed -i '/def __init__(self, shell):/i \    autocommit = Bool(True, config=True, help="Set autocommit mode")\n' {{ ipython2_path }}/magic.py

dependency-configurations-python3:
  cmd.run:
    - name: sed -i "s/if 'mssql' not in str(conn.dialect):/if config.autocommit and ('mssql' not in str(conn.dialect)):/" {{ ipython3_path }}/run.py && sed -i '/def __init__(self, shell):/i \    autocommit = Bool(True, config=True, help="Set autocommit mode")\n' {{ ipython3_path }}/magic.py
