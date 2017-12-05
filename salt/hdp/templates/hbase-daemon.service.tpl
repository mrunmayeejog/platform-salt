[Unit]
Description=HBase REST service

[Service]
Type=simple
User=root
Group=root
UMask=007
TimeoutStopSec=300
ExecStart=/usr/hdp/current/hbase-master/bin/hbase-daemon.sh start {{ daemon_service }} -p {{ daemon_port }} --infoport {{ info_port }}
Restart=always
RestartSec=2
