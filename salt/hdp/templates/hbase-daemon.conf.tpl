# Ubuntu upstart file at /etc/init/hbase-conf.conf

description "HBase daemon service"

start on runlevel [2345]
stop on [!12345]

respawn
respawn limit 2 5

umask 007

kill timeout 300

exec bash /usr/hdp/current/hbase-master/bin/hbase-daemon.sh start {{ daemon_service }} -p {{ daemon_port }} --infoport {{ info_port }}
