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

# Grafana installieren
echo "Installing Grafana..."
wget -q -O- https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt update
sudo apt install -y grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
echo "Grafana installed and started."

# Status anzeigen
echo "Installation complete. Checking service statuses..."
sudo systemctl status influxdb --no-pager
sudo systemctl status grafana-server --no-pager

echo "Grafana läuft standardmäßig auf Port 3000 und InfluxDB auf Port 8086."