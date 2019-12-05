CREATE USER repuser WITH REPLICATION ENCRYPTED PASSWORD 'replication';
archive_command = 'test ! -f /var/lib/postgresql/data/mnt/server/archivedir/%f && cp %p /var/lib/postgresql/data/mnt/server/archivedir/%f'
repuser - v - P --xlog-method=stream