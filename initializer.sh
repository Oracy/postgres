echo 'Stopping containers "Master" and "Slave"'
docker stop master slave

echo 'Removing containers "Master" and "Slave"'
docker rm master slave

echo 'Removing images "Master_psql" and "Slave_psql"'
docker rmi master_psql:latest slave_psql:latest

echo 'Removing volumes to create new containers "master_volume" "slave_volume"'
rm -rf master_volume slave_volume

echo 'Starting containers'
docker-compose up -d

echo 'Stopping Slave container'
docker stop slave

echo 'Removing slave data'
rm -rf slave_volume/*

echo 'Copying from master to slave'
cp -r ./master_volume/* ./slave_volume/

echo 'Copying configuration files from master_volume to slave_volume'
cp ./Slave/*.conf slave_volume/data/

echo 'Restarting Containers'
docker start slave