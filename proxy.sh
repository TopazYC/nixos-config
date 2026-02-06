sudo mkdir -p /run/systemd/system/nix-daemon.service.d/
sudo tee /run/systemd/system/nix-daemon.service.d/override.conf <<EOF
[Service]
Environment="https_proxy=https://localhost:7890"
Environment="http_proxy=http://localhost:7890"
EOF
sudo systemctl daemon-reload
sudo systemctl restart nix-daemon
