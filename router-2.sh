export DEBIAN_FRONTEND=noninteractive
#Startup commands go here
#Enable routing
sudo sysctl -w net.ipv4.ip_forward=1
sudo ip link set dev enp0s8 up
sudo ip link set dev enp0s9 up
sudo ip add add 10.1.1.2/30 dev enp0s9
sudo ip add add 192.168.0.1/23 dev enp0s8
sudo ip route add 192.168.0.0/23 via 10.1.1.2
sudo ip route add 192.168.2.0/22 via 10.1.1.1
