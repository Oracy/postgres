FROM postgres:10

RUN apt update && \
    apt install -y vim-tiny \
    net-tools \
    iputils-ping

COPY ./Master/postgresql.conf /postgresql.conf
COPY ./Master/pg_hba.conf /pg_hba.conf

COPY ./Scripts/set-config_master.sh /docker-entrypoint-initdb.d/set-config_master.sh
COPY ./Scripts/init.sql /docker-entrypoint-initdb.d/

EXPOSE 5432