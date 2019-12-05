## Preparing the environment
su - postgres
echo "export PATH=/usr/pgsql-12/bin:$PATH PAGER=less" >> ~/.pgsql_profile
source ~/.pgsql_profile

# as postgres
psql -c "ALTER SYSTEM SET listen_addresses TO '*'";

echo "host replication replicator 192.168.0.3/32 md5" >> $PGDATA/pg_hba.conf

## Get the changes into effect through a reload.
psql -c "select pg_reload_conf()"