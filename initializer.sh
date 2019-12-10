echo 'Stopping containers "Master" and "Slave"'
docker stop master slave
if [ $? -eq 0 ]; then
    printf '\e[92mContainers Stopped \e[0m\n'
else
    printf '\e[91mThere is no containers yet \e[0m\n'
fi
echo '#######################################################################'

echo 'Removing containers "Master" and "Slave"'
docker rm master slave
if [ $? -eq 0 ]; then
    printf '\e[92mContainers Removed \e[0m\n'
else
    printf '\e[91mThere is no containers yet \e[0m\n'
fi
echo '#######################################################################'

echo 'Removing images "Master_psql" and "Slave_psql"'
docker rmi master_psql:latest slave_psql:latest
if [ $? -eq 0 ]; then
    printf '\e[92mImages Removed \e[0m\n'
else
    printf '\e[91mThere is no images yet \e[0m\n'
fi
echo '#######################################################################'

echo 'Removing volumes to create new containers "master_volume" "slave_volume"'
rm -rf master_volume slave_volume
if [ $? -eq 0 ]; then
    printf '\e[92mFolders Removed \e[0m\n'
else
    printf '\e[91mThere is no folders yet \e[0m\n'
fi
echo '#######################################################################'

echo 'Starting containers'
docker-compose up -d
if [ $? -eq 0 ]; then
    printf '\e[92mContainers Started \e[0m\n'
else
    printf '\e[91mContainers cant up \e[0m\n'
fi
echo '#######################################################################'

echo 'Stopping Slave container'
docker stop slave
if [ $? -eq 0 ]; then
    printf '\e[92mSlave stopped \e[0m\n'
else
    printf '\e[91mSlave not stopped \e[0m\n'
fi
echo '#######################################################################'

echo 'Removing slave data'
rm -rf slave_volume/*
if [ $? -eq 0 ]; then
    printf '\e[92mSlave Data has been Removed \e[0m\n'
else
    printf '\e[91mThere is no Slave Data folder yet \e[0m\n'
fi
echo '#######################################################################'

echo 'Copying from master to slave'
cp -r ./master_volume/* ./slave_volume/
if [ $? -eq 0 ]; then
    printf '\e[92mMaster Volume copied \e[0m\n'
else
    printf '\e[91mMaster Volume Error on copy \e[0m\n'
fi
echo '#######################################################################'

echo 'Copying configuration files from master_volume to slave_volume'
cp ./Slave/*.conf slave_volume/data/
if [ $? -eq 0 ]; then
    printf '\e[92mSlave/.*conf copied \e[0m\n'
else
    printf '\e[91mSlave/.*conf Error on copy \e[0m\n'
fi
echo '#######################################################################'

echo 'Restarting Containers'
docker start slave
if [ $? -eq 0 ]; then
    printf '\e[92mSlave started \e[0m\n'
else
    printf '\e[91mSlave Error on Start \e[0m\n'
fi

echo '\e[92m#######################################################################'
echo '#               To access database you should use ip:                 #'
echo '#                        Master': `docker inspect master | grep -E '"IPAddress": "\w' | awk {'print $2'} | sed -r 's/"//g' | sed -r 's/,//g'`':5432                      #'
echo '#                        Slave': `docker inspect slave | grep -E '"IPAddress": "\w' | awk {'print $2'} | sed -r 's/"//g' | sed -r 's/,//g'`':5433                       #'
echo '#######################################################################'
