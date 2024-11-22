docker-compose up -d

docker exec -it pg_master bash

echo "wal_level = replica" >> /var/lib/postgresql/data/postgresql.conf
echo "max_wal_senders = 3" >> /var/lib/postgresql/data/postgresql.conf
echo "wal_keep_size = 64" >> /var/lib/postgresql/data/postgresql.conf


echo "host replication all 0.0.0.0/0 md5" >> /var/lib/postgresql/data/pg_hba.conf


docker-compose restart master


docker exec -it pg_replica bash


pg_basebackup -h pg_master -D /var/lib/postgresql/data -U postgres -v -P --wal-method=stream


echo "standby_mode = 'on'" > /var/lib/postgresql/data/recovery.conf
echo "primary_conninfo = 'host=pg_master port=5432 user=postgres password=postgres'" >> /var/lib/postgresql/data/recovery.conf


docker-compose restart replica


