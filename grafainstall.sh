#!/bin/bash
# filepath: d:\Workspaces\pinkstinkt\pinkstinkt\install_grafana_influxdb.sh

# Update und grundlegende Pakete installieren
sudo apt update && sudo apt upgrade -y
sudo apt install -y wget curl gnupg software-properties-common

# InfluxDB 1.8 installieren
echo "Installing InfluxDB 1.8..."
wget -qO- https://repos.influxdata.com/influxdb.key | sudo apt-key add -
echo "deb https://repos.influxdata.com/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/influxdb.list
sudo apt update
sudo apt install -y influxdb
sudo systemctl enable influxdb
sudo systemctl start influxdb
echo "InfluxDB 1.8 installed and started."

# Benutzer und Datenbank in InfluxDB erstellen
echo "Configuring InfluxDB..."
influx -execute "CREATE USER zockerecke WITH PASSWORD 'CEkFurTX' WITH ALL PRIVILEGES"
influx -execute "CREATE DATABASE db01"
influx -execute "GRANT ALL ON db01 TO zockerecke"
echo "User 'zockerecke' and database 'db01' created in InfluxDB."

# Grafana installieren
echo "Installing Grafana..."
wget -q -O- https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt update
sudo apt install -y grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
echo "Grafana installed and started."

# Grafana-Provisionierung
GrafanaProvision() {
    echo "Configuring Grafana provisioning..."
    mkdir -p /etc/grafana/provisioning/datasources
    cat > /etc/grafana/provisioning/datasources/influx.yml << EOF
apiVersion: 1

datasources:
- name: RSMInfluxDB
  type: influxdb
  access: proxy
  url: http://localhost:8086
  user: zockerecke
  database: db01
  basicAuth: false
  isDefault: true
  jsonData:
     tlsAuth: false
     tlsAuthWithCACert: false
     dbName: db01
     tlsSkipVerify: true
  secureJsonData:
    password: CEkFurTX
    tlsCACert: ""
    tlsClientCert: ""
    tlsClientKey: ""
  version: 1
  editable: true
EOF
    echo "Grafana provisioning completed."
    sudo systemctl restart grafana-server
}

# Provisionierung ausführen
GrafanaProvision

# Status anzeigen
echo "Installation complete. Checking service statuses..."
sudo systemctl status influxdb --no-pager
sudo systemctl status grafana-server --no-pager

echo "Grafana läuft standardmäßig auf Port 3000 und InfluxDB auf Port 8086."