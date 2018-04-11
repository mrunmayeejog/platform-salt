/var/log/pnda/*.log {
    su root {{ group_name }}
    daily
    compress
    size 10M
    rotate 5
    copytruncate
}
/var/log/pnda/*/*.log {
    su root {{ group_name }}
    daily
    compress
    size 10M
    rotate 5
    copytruncate
}