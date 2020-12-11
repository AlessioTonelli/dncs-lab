export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
#Network interface config
sudo ip link set dev enp0s8 up
sudo ip add add 192.168.0.2/23 dev enp0s8
sudo ip route add 10.1.1.0/30 via 192.168.0.1
sudo ip route add 192.168.0.0/22 via 192.168.0.1
#Download package information from all configured sources
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y docker.io
sudo docker pull nginx
sudo docker run --name nginx -p 80:80 -d nginx