```bash
# Freeze to specified version defined in env file.
source .env
```

# Install

```bash
yum install -y cyrus-sasl-devel
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
pip install --upgrade pip wheel setuptools
pip install acryl-datahub-actions==${ACTIONS_VERSION}
pip install acryl-datahub==${DATAHUB_VERSION}
pip install acryl-datahub[hive]==${DATAHUB_VERSION}
pip install acryl-datahub[mysql]==${DATAHUB_VERSION}
pip install acryl-datahub[kafka]==${DATAHUB_VERSION}
pip install acryl-datahub[elasticsearch]==${DATAHUB_VERSION}

curl -SL https://github.com/docker/compose/releases/download/v2.6.1/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

# Start

```bash
docker-compose -p datahub up -d
datahub docker check
```

+ create ingestion on WebUI

```bash
# get your cookies & headers via chrome browser. save to credential.py
# https://curlconverter.com/
# change endpoint url and recipe.json
python ingestions.py
```

# Backup

```bash
docker run --rm \
    --network="datahub_network" \
    --user 0 \
    -e DB_DUMP_TARGET=/db \
    -e DB_DUMP_SAFECHARS=true \
    -e DB_USER=root \
    -e DB_PASS=datahub \
    -e DB_SERVER=mysql \
    -e DB_PORT=3306 \
    -e 'DB_DUMP_CRON=2 6 * * *' \
    -v ${HOME}/datahub/backup/mysql:/db \
    databack/mysql-backup
```

# Restore

```bash
cd /root/datahub/backup/mysql
tar -xzf db_backup_2023-03-09T03-00-07Z.tgz
datahub docker quickstart --restore --restore-file /root/datahub/backup/mysql/backup_2023-03-09T03-00-07Z.sql
```

# Upgrade

```bash
datahub docker quickstart --stop

datahub docker quickstart --quickstart-compose-file custom/docker-compose.yml 
```

# Destory

```bash
# https://datahubproject.io/docs/quickstart#resetting-datahub
datahub docker nuke
```
