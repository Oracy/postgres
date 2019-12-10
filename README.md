Postgres master and slave (standby) servers working with Docker.

To run this project you just need to:
```bash
sudo chmod +x initializer.sh
```
Then run this script as root
```bash
sudo su
./initializer.sh
```

Default user to test replication is: `docker` and password `docker`

Replication user is: `repuser` and password `replication`