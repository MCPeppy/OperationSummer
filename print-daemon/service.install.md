1. Copy `print-daemon` to Raspberry Pi.
2. Create `/etc/systemd/system/ops-print.service`:
```
[Unit]
Description=Operation Summer Print Daemon
After=network.target

[Service]
Environment=USER_ID=<FIREBASE_UID>
Environment=DEFAULT_PRINTER=HomePrinter
Environment=SERVICE_ACCOUNT_JSON=<json-string>
WorkingDirectory=/home/pi/print-daemon
ExecStart=/usr/bin/node index.js
Restart=always

[Install]
WantedBy=multi-user.target
```
3. `sudo systemctl enable --now ops-print`
