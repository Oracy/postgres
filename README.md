# Postgres Running with WAL

---

Postgres master and slave (standby) servers working with Docker.

To run this project follow steps below:

##### Prerequisites:

```bash
sudo apt install -y git
sudo apt install -y postgresql postgresql-contrib postgresql-client-common
sudo /etc/init.d/postgresql stop
```

Install [Docker](https://www.digitalocean.com/community/tutorials/como-instalar-e-usar-o-docker-no-ubuntu-18-04-pt)

```bash
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install -y docker-ce
sudo usermod -aG docker ${USER}
su - ${USER}
id -nG
sudo usermod -aG docker username
```
---

Install [Docker-Compose](https://docs.docker.com/compose/install/)

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
```


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
psql -h 127.0.0.1 -p 5432 -U docker
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
