#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo -e "\e[31m[-] Run as root (sudo wazuh-start.sh)\e[0m"
   exit 1
fi

IP_ADDR=$(hostname -I | awk '{print $1}')
SERVICES=("wazuh-indexer" "wazuh-manager" "wazuh-dashboard")

echo "--- Wazuh Stack Startup Sequence Started ---"

for SERVICE in "${SERVICES[@]}"; do
    echo "[*] Starting $SERVICE..."
    systemctl start "$SERVICE"
    sleep 10

    STATUS=$(systemctl is-active "$SERVICE")
    if [ "$STATUS" == "active" ]; then
        echo -e "\e[32m[+] $SERVICE started successfully.\e[0m"
    else
        echo -e "\e[31m[-] Failed to start $SERVICE.\e[0m"
        journalctl -u "$SERVICE" -n 10
        exit 1
    fi
done

echo "-------------------------------------------------------"
echo -e "\e[36m[!] All services are up!\e[0m"
echo -e "\e[36m[!] Access the dashboard at: https://$IP_ADDR\e[0m"
echo "-------------------------------------------------------"

# パスを通す。
# sudo mv wazuh-start.sh /usr/local/bin/
# sudo chown root:root /usr/local/bin/wazuh-start.sh
# sudo chmod +x /usr/local/bin/wazuh-start.sh
