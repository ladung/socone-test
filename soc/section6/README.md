# Allow VMs to access the internet
## On Host 1
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -I FORWARD -i br0 -j ACCEPT

# Permit users on VM1 access to VM3 but Block access to VM2
## On VM1
iptables -A OUTPUT -d 192.168.1.21 -p tcp -m tcp --dports 22 -j ACCEPT -m comment --comment "allow vm1 to vm3"
iptables -A OUTPUT -d 192.168.1.12 -p tcp -m tcp --dports 22 -j ACCEPT -m comment --comment "block vm1 to vm2"

## On VM3
iptables -A INPUT -s 192.168.1.11 -p tcp -m tcp --dports 22 -j ACCEPT -m comment --comment "allow vm1 to vm3"

## On VM2
iptables -A INPUT -s 192.168.1.11 -p tcp -m tcp --dports 22 -j DROP -m comment --comment "block vm1 to vm 2"

