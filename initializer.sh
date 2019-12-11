echo 'Stopping containers "Master" and "Slave"' | tee -a ./logs/initializer.log
docker stop master slave 2>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mContainers Stopped \e[0m\n' | tee -a ./logs/initializer.log
else
    printf '\e[91mThere is no containers yet \e[0m\n' | tee -a ./logs/initializer.log
fi
echo '#######################################################################'


echo 'Removing containers "Master" and "Slave"' | tee -a ./logs/initializer.log
docker rm master slave 2>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mContainers Removed \e[0m\n' | tee -a ./logs/initializer.log
else
    printf '\e[91mThere is no containers yet \e[0m\n' | tee -a ./logs/initializer.log
fi
echo '#######################################################################'


echo 'Removing images "Master_psql" and "Slave_psql"' | tee -a ./logs/initializer.log
docker rmi master_psql:latest slave_psql:latest 1>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mImages Removed \e[0m\n' | tee -a ./logs/initializer.log
else
    printf '\e[91mThere is no images yet \e[0m\n' | tee -a ./logs/initializer.log
fi
echo '#######################################################################'


echo 'Removing volumes to create new containers "master_volume" "slave_volume"' | tee -a ./logs/initializer.log
sudo rm -rf master_volume slave_volume 1>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mFolders Removed \e[0m\n' | tee -a ./logs/initializer.log
else
    printf '\e[91mThere is no folders yet \e[0m\n' | tee -a ./logs/initializer.log
fi
echo '#######################################################################'


# echo 'Check if there is postgres installed'
# apt-cache policy postgresql | grep Installed | grep none
# if [ $? -eq 0 ]; then
#     printf '\e[92mPostgreSQL is already installed \e[0m\n' | tee -a ./logs/initializer.log
# else
# sudo apt install -y postgresql postgresql-contrib postgresql-client-common
# fi
# echo '#######################################################################'


echo 'Starting master container' | tee -a ./logs/initializer.log
docker-compose up -d master 1>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mMaster Started \e[0m\n' | tee -a ./logs/initializer.log
else
    printf '\e[91mMaster cant up \e[0m\n' | tee -a ./logs/initializer.log
fi
echo '#######################################################################'


echo 'Restarting Master container' | tee -a ./logs/initializer.log
docker restart master 1>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mMaster restarted \e[0m\n' | tee -a ./logs/initializer.log
else
    printf '\e[91mMaster failed \e[0m\n' | tee -a ./logs/initializer.log
fi
echo '#######################################################################'


echo 'Backuping master container' | tee -a ./logs/initializer.log
sleep 10
pg_basebackup -h 127.0.0.1 -p 5432 -D ./slave_volume -U replicator -P -v 1>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mBackup Ok \e[0m\n' | tee -a ./logs/initializer.log
else
    printf '\e[91mBackup Error \e[0m\n' | tee -a ./logs/initializer.log
fi
echo '#######################################################################'


echo 'Copying recovery file recovery.conf to slave_volume' | tee -a ./logs/initializer.log
sudo cp ./Slave/recovery.conf ./slave_volume 1>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mSlave/.*conf copied \e[0m\n' | tee -a ./logs/initializer.log
else
    printf '\e[91mSlave/.*conf Error on copy \e[0m\n' | tee -a ./logs/initializer.log
fi
echo '#######################################################################'


echo 'Starting Slave Container' | tee -a ./logs/initializer.log
sudo docker-compose up -d slave 1>> ./logs/initializer.log
if [ $? -eq 0 ]; then
    printf '\e[92mSlave started \e[0m\n' | tee -a ./logs/initializer.log
else
    printf '\e[91mSlave Error on Start \e[0m\n' | tee -a ./logs/initializer.log
fi


echo 'Check logs on ./logs/initializer.log'


echo '#######################################################################' | tee -a ./logs/initializer.log
echo '#               To access database you should use ip:                 #' | tee -a ./logs/initializer.log
echo '#                        Master': `docker inspect master | grep -E '"IPAddress": "\w' | awk {'print $2'} | sed -r 's/"//g' | sed -r 's/,//g'`':5432                      #' | tee -a ./logs/initializer.log
echo '#                        Slave': `docker inspect slave | grep -E '"IPAddress": "\w' | awk {'print $2'} | sed -r 's/"//g' | sed -r 's/,//g'`':5433                       #' | tee -a ./logs/initializer.log
echo '####################################################################### ' | tee -a ./logs/initializer.log
echo 'Finished' | tee -a ./logs/initializer.log