sudo mkdir -p /run/systemd/system/nix-daemon.service.d/
sudo tee /run/systemd/system/nix-daemon.service.d/override.conf <<EOF
[Service]
Environment="https_proxy=https://172.27.240.1:7890"
Environment="http_proxy=http://172.27.240.1:7890"
EOF
sudo systemctl daemon-reload
sudo systemctl restart nix-daemon
