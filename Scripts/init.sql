CREATE USER docker WITH REPLICATION LOGIN ENCRYPTED PASSWORD 'docker';
-- CREATE DATABASE docker;
-- GRANT ALL PRIVILEGES ON DATABASE docker TO docker;
-- CREATE USER replicate WITH REPLICATION LOGIN ENCRYPTED PASSWORD 'docker';
-- CREATE ROLE replicator LOGIN REPLICATION ENCRYPTED PASSWORD 'replicator_password';
-- SELECT * FROM pg_create_physical_replication_slot('replicator');
CREATE USER repuser SUPERUSER LOGIN CONNECTION LIMIT 1 ENCRYPTED PASSWORD 'changeme';