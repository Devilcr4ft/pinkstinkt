#!/bin/bash
# filepath: d:\Workspaces\pinkstinkt\pinkstinkt\uninstall_grafana_influxdb.sh

echo "Stopping and disabling Grafana and InfluxDB services..."
sudo systemctl stop grafana-server
sudo systemctl disable grafana-server
sudo systemctl stop influxdb
sudo systemctl disable influxdb

echo "Removing Grafana and InfluxDB packages..."
sudo apt remove --purge -y grafana influxdb
sudo apt autoremove -y
sudo apt autoclean

echo "Deleting configuration and data files..."
sudo rm -rf /var/lib/grafana /etc/grafana
sudo rm -rf /var/lib/influxdb /etc/influxdb

echo "Removing repository files..."
sudo rm -f /etc/apt/sources.list.d/grafana.list
sudo rm -f /etc/apt/sources.list.d/influxdb.list

echo "Uninstallation complete."