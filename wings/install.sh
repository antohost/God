#!/bin/bash

echo "🔧 Installing Pterodactyl Wings..."

sudo apt update -y
sudo apt install -y curl tar unzip docker.io

# Create directory
sudo mkdir -p /etc/pterodactyl
cd /etc/pterodactyl

# Download Wings
sudo curl -Lo wings https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64
sudo chmod +x wings

echo "✅ Wings downloaded successfully!"

# Generate service file
sudo bash -c 'cat > /etc/systemd/system/wings.service <<EOF
[Unit]
Description=Pterodactyl Wings Daemon
After=docker.service
Requires=docker.service

[Service]
User=root
WorkingDirectory=/etc/pterodactyl
ExecStart=/etc/pterodactyl/wings
Restart=on-failure
StartLimitInterval=600

[Install]
WantedBy=multi-user.target
EOF'

echo "🔧 Reloading systemd..."
sudo systemctl daemon-reload
sudo systemctl enable wings

echo "🔥 Wings installed! Run manually with:"
echo "sudo wings"
