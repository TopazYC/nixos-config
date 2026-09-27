sudo mkdir -p /run/systemd/system/nix-daemon.service.d/
sudo tee /run/systemd/system/nix-daemon.service.d/override.conf <<EOF
[Service]
Environment="https_proxy=https://127.0.0.1:7897"
Environment="http_proxy=http://127.0.0.1:7897"
EOF
sudo systemctl daemon-reload
sudo systemctl restart nix-daemon
