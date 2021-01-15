export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
sudo ip addr add 192.168.4.2/24 dev enp0s8
sudo ip link set dev enp0s8 up
sudo ip route add 10.1.1.0/30 via 192.168.4.1
sudo ip route add 192.168.0.0/23 via 192.168.4.1
sudo ip route add 192.168.2.0/23 via 192.168.4.1