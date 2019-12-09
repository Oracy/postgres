echo 'Stopping containers "Master" and "Slave"'
docker stop master slave
echo '#######################################################################'

echo 'Removing containers "Master" and "Slave"'
docker rm master slave
echo '#######################################################################'

echo 'Removing images "Master_psql" and "Slave_psql"'
docker rmi master_psql:latest slave_psql:latest
echo '#######################################################################'

echo 'Removing volumes to create new containers "master_volume" "slave_volume"'
rm -rf master_volume slave_volume
echo '#######################################################################'

echo 'Starting containers'
docker-compose up -d
echo '#######################################################################'

echo 'Stopping Slave container'
docker stop slave
echo '#######################################################################'

echo 'Removing slave data'
rm -rf slave_volume/*
echo '#######################################################################'

echo 'Copying from master to slave'
cp -r ./master_volume/* ./slave_volume/
echo '#######################################################################'

echo 'Copying configuration files from master_volume to slave_volume'
cp ./Slave/*.conf slave_volume/data/
echo '#######################################################################'

echo 'Restarting Containers'
docker start slave
echo '#######################################################################'

echo '#######################################################################'
echo '#               To access database you should use ip:                 #'
echo '#                        Master': `docker inspect master | grep -E '"IPAddress": "\w' | awk {'print $2'} | sed -r 's/"//g' | sed -r 's/,//g'`':5432                      #'
echo '#                        Slave': `docker inspect slave | grep -E '"IPAddress": "\w' | awk {'print $2'} | sed -r 's/"//g' | sed -r 's/,//g'`':5433                       #'
echo '#######################################################################'
