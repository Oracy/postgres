FROM postgres:12

RUN apt update && \
    apt install -y vim-tiny \
    net-tools

COPY ./Slave/postgresql.conf /postgresql.conf
COPY ./Slave/recovery.conf /recovery.conf

COPY ./Scripts/init.sql /docker-entrypoint-initdb.d/
COPY ./Scripts/set-config_slave.sh /docker-entrypoint-initdb.d/set-config_slave.sh

EXPOSE 5433