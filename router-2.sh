export DEBIAN_FRONTEND=noninteractive
#Startup commands go here
#Enable routing
sudo sysctl -w net.ipv4.ip_forward=1
sudo ip addr add 10.1.1.2/30 dev enp0s9
sudo ip link set dev enp0s9 up
sudo ip addr add 192.168.0.1/23 dev enp0s8
sudo ip link set dev enp0s8 up
sudo ip route add 192.168.4.0/24 via 10.1.1.1
sudo ip route add 192.168.2.0/23 via 10.1.1.1
