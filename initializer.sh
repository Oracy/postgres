echo 'Stopping containers "Master" and "Slave"' | tee ./logs/initializer.log
docker stop master slave 2>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mContainers Stopped \e[0m\n' | tee ./logs/initializer.log
else
    printf '\e[91mThere is no containers yet \e[0m\n' | tee ./logs/initializer.log
fi
echo '#######################################################################'

echo 'Removing containers "Master" and "Slave"' | tee ./logs/initializer.log
docker rm master slave 2>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mContainers Removed \e[0m\n' | tee ./logs/initializer.log
else
    printf '\e[91mThere is no containers yet \e[0m\n' | tee ./logs/initializer.log
fi
echo '#######################################################################'

echo 'Removing images "Master_psql" and "Slave_psql"' | tee ./logs/initializer.log
docker rmi master_psql:latest slave_psql:latest 2>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mImages Removed \e[0m\n' | tee ./logs/initializer.log
else
    printf '\e[91mThere is no images yet \e[0m\n' | tee ./logs/initializer.log
fi
echo '#######################################################################'

echo 'Removing volumes to create new containers "master_volume" "slave_volume"' | tee ./logs/initializer.log
sudo rm -rf master_volume slave_volume 2>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mFolders Removed \e[0m\n' | tee ./logs/initializer.log
else
    printf '\e[91mThere is no folders yet \e[0m\n' | tee ./logs/initializer.log
fi
echo '#######################################################################'

echo 'Starting containers' | tee ./logs/initializer.log
docker-compose up -d 2>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mContainers Started \e[0m\n' | tee ./logs/initializer.log
else
    printf '\e[91mContainers cant up \e[0m\n' | tee ./logs/initializer.log
fi
echo '#######################################################################'

echo 'Stopping Slave container' | tee ./logs/initializer.log
docker stop slave 2>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mSlave stopped \e[0m\n' | tee ./logs/initializer.log
else
    printf '\e[91mSlave not stopped \e[0m\n' | tee ./logs/initializer.log
fi
echo '#######################################################################'

echo 'Removing slave data' | tee ./logs/initializer.log
sudo rm -rf slave_volume/* 2>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mSlave Data has been Removed \e[0m\n' | tee ./logs/initializer.log
else
    printf '\e[91mThere is no Slave Data folder yet \e[0m\n' | tee ./logs/initializer.log
fi
echo '#######################################################################'

echo 'Copying from master to slave' | tee ./logs/initializer.log
sudo cp -r ./master_volume/* ./slave_volume/ 2>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mMaster Volume copied \e[0m\n' | tee ./logs/initializer.log
else
    printf '\e[91mMaster Volume Error on copy \e[0m\n' | tee ./logs/initializer.log
fi
echo '#######################################################################'

echo 'Copying configuration files from master_volume to slave_volume' | tee ./logs/initializer.log
sudo cp ./Slave/*.conf slave_volume/data/ 2>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mSlave/.*conf copied \e[0m\n' | tee ./logs/initializer.log
else
    printf '\e[91mSlave/.*conf Error on copy \e[0m\n' | tee ./logs/initializer.log
fi
echo '#######################################################################'

echo 'Restarting Containers' | tee ./logs/initializer.log
docker start slave 2>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mSlave started \e[0m\n' | tee ./logs/initializer.log
else
    printf '\e[91mSlave Error on Start \e[0m\n' | tee ./logs/initializer.log
fi

echo 'Check logs on ./logs/initializer.log'

echo '\e[92m#######################################################################' | tee ./logs/initializer.log
echo '#               To access database you should use ip:                 #' | tee ./logs/initializer.log
echo '#                        Master': `docker inspect master | grep -E '"IPAddress": "\w' | awk {'print $2'} | sed -r 's/"//g' | sed -r 's/,//g'`':5432                      #' | tee ./logs/initializer.log
echo '#                        Slave': `docker inspect slave | grep -E '"IPAddress": "\w' | awk {'print $2'} | sed -r 's/"//g' | sed -r 's/,//g'`':5433                       #' | tee ./logs/initializer.log
echo '#######################################################################' | tee ./logs/initializer.log
