FROM postgres:9.5

RUN apt update && \
    apt install -y vim-tiny \
    net-tools \
    iputils-ping

# COPY ./Slave/postgresql.conf /postgresql.conf
# COPY ./Slave/recovery.conf /recovery.conf

# COPY ./Scripts/init.sql /docker-entrypoint-initdb.d/

EXPOSE 5433