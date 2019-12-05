# Postgres

---

[Replication](https://wiki.postgresql.org/wiki/Streaming_Replication)

##### Step by Step

1. Install postgres on Master and Slave servers as usual (I am using docker-compose to handle that in the same machine). Just getting image from postgres oficial repository.
    * `docker-compose up -d`
2. Create database `docker` on both containers using script, [init.sql](./Scripts/init.sql).
3. Create an user named replication with REPLICATION privileges script, [replication.sql](./Scripts/replication.sql).
4. Set up connections and authentication on the primary so that the standby server can successfully connect to the replication pseudo-database on the primary script, [postgresql_conf_master.sh](./Scripts/postgresql_conf_master.sh).
5. Set up the streaming replication related parameters on the primary server with script, [postgresql_conf_master.sh](./Scripts/postgresql_conf_master.sh).
6. Start postgres on the primary server.
    * `docker restart master`
7. If necessary make a base backup from master to slave database.
    7.1. Do it with pg_(start|stop)_backup and rsync on the primary.
    ```bash
        $ psql -c "SELECT pg_start_backup('label', true)"
        $ rsync -ac ${PGDATA}/ standby:/srv/pgsql/standby/ --exclude postmaster.pid
        $ psql -c "SELECT pg_stop_backup()"
    ```
    7.2. Other way
    ```bash
        $ pg_basebackup -h 172.31.0.2 -D /srv/pgsql/standby -P -U replication --xlog-method=stream
    ```
8. Set up replication-related parameters, connections and authentication in the standby server like the primary, so that the standby might work as a primary after failover.
9. Enable read-only queries on the standby server. But if wal_level is archive on the primary, leave hot_standby unchanged (i.e., off) []().

- A primary server runs the active database. This database accepts connections from clients and permits read-write operations.
- One or more standby servers run a copy of the active database. These databases are configured to accept connections from clients and permit read-only operations. If the primary database server fails, the system can fail over to the standby server, which makes the standby server the active primary server.



    * Postgres uses write-ahead logging (WAL) to continuously archive database transactions. For each change made to the data files, WAL writes an entry in a log file. The system uses these log entries to perform point-in- time restoration from archives and to keep the standby server up to date. This means that when you set up Hot Standby, you're also setting up archiving.
    * The process of updating the standby server with WAL entries is called streaming replication. This process operates asynchronously, which means it can take some time for the standby server to receive an update from the primary server. Though this delay can be very short, synchronization between the servers is not instantaneous. If your application requires strict consistency between the database instances, you should consider another approach.
    * Postgres doesn't provide functionality to automatically fail over when the primary server fails. This is a manual operation unless you use a third-party solution to manage failover.
    * Load balancing is not automatic with Hot Standby. If load balancing is a requirement for your application, you must provide a load-balancing solution that uses the primary server for read-write operations and the standby server for read-only operations.
