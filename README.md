# Postgres Running with WAL

---

Postgres master and slave (standby) servers working with Docker.

To run this project follow steps below:

```bash
# make script executable
sudo chmod +x initializer.sh
# run this script
./initializer.sh
```

Password for user `docker` is `docker`

After script finish, add line below into `./master_volume/postgres/postgresql.conf`

```
sudo vi ./master_volume/postgres/postgresql.conf
max_replication_slots = 1
```

Restart master `docker restart master`

Then access remotely master server to create replication slot to avoid problem if slave serve go down and lost some WAL position, and then REDO from this replication slot.
```bash
psql -h 127.0.0.1 -p 5432 -U docker -d postgres
select * from pg_replication_slots;
```

Expected result:

slot_name | plugin | slot_type | datoid | database | active | active_pid | xmin | catalog_xmin | restart_lsn 
-----------|--------|-----------|--------|----------|--------|------------|------|--------------|-------------
|||||||||

Create slot on master:
`select * from pg_create_physical_replication_slot('standby_replication_slot');`

Expected result:

slot_name         | xlog_position 
--------------------------|---------------
standby_replication_slot | 

Restart slave server after command above `docker restart slave`

After some seconds run command below to check if everything is fine.
`select * from pg_replication_slots;`

Expected result:

slot_name         | plugin | slot_type | datoid | database | active | active_pid | xmin | catalog_xmin | restart_lsn 
--------------------------|--------|-----------|--------|----------|--------|------------|------|--------------|-------------
standby_replication_slot |        | physical  |        |          | t      |         44 |      |              | 0/3000108
