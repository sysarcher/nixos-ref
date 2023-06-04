# note: the names UPLINK and DOWNLINK are reversed (sorry!)
UPLINK=eno2
DOWNLINK=eno1

sudo -E iptables --flush
sudo -E iptables -P INPUT ACCEPT
sudo -E iptables -P FORWARD ACCEPT
sudo -E iptables -P OUTPUT ACCEPT
sudo -E iptables -A INPUT -i $DOWNLINK -p udp -m udp --dport 53 -j ACCEPT
sudo -E iptables -A INPUT -i $UPLINK -p udp -m udp --dport 53 -j ACCEPT
sudo -E iptables -A FORWARD -i $DOWNLINK -o $UPLINK -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo -E iptables -A FORWARD -i $UPLINK -o $DOWNLINK -j ACCEPT
sudo -E iptables -t nat -A POSTROUTING -o $UPLINK -j MASQUERADE
sudo -E iptables -t nat -A POSTROUTING -o $DOWNLINK -j MASQUERADE
