# DNCS-LAB

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


        +-----------------------------------------------------+
        |                                                     |
        |                                                     |eth0
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |            eth0|            |eth2     eth2|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |eth1                       |eth1
        |  N  |                      |                           |
        |  A  |                      |                           |
        |  G  |                      |                     +-----+----+
        |  E  |                      |eth1                 |          |
        |  M  |            +-------------------+           |          |
        |  E  |        eth0|                   |           |  host-c  |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |eth2         |eth3                |eth0
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |eth1         |eth1                |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |    eth0|          |     |          |             |
        |     +--------+  host-a  |     |  host-b  |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |eth0                   |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+



```

# Requirements
 - Python 3
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/fabrizio-granelli/dncs-lab`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab]$ vagrant status                                                                                                                                                                
Current machine states:

router                    running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`
`vagrant ssh host-c`

# Assignment
This section describes the assignment, its requirements and the tasks the student has to complete.
The assignment consists in a simple piece of design work that students have to carry out to satisfy the requirements described below.
The assignment deliverable consists of a Github repository containing:
- the code necessary for the infrastructure to be replicated and instantiated
- an updated README.md file where design decisions and experimental results are illustrated
- an updated answers.yml file containing the details of your project

## Design Requirements
- Hosts 1-a and 1-b are in two subnets (*Hosts-A* and *Hosts-B*) that must be able to scale up to respectively 214 and 270 usable addresses
- Host 2-c is in a subnet (*Hub*) that needs to accommodate up to 348 usable addresses
- Host 2-c must run a docker image (dustnic82/nginx-test) which implements a web-server that must be reachable from Host-1-a and Host-1-b
- No dynamic routing can be used
- Routes must be as generic as possible
- The lab setup must be portable and executed just by launching the `vagrant up` command

## Tasks
- Fork the Github repository: https://github.com/fabrizio-granelli/dncs-lab
- Clone the repository
- Run the initiator script (dncs-init). The script generates a custom `answers.yml` file and updates the Readme.md file with specific details automatically generated by the script itself.
  This can be done just once in case the work is being carried out by a group of (<=2) engineers, using the name of the 'squad lead'. 
- Implement the design by integrating the necessary commands into the VM startup scripts (create more if necessary)
- Modify the Vagrantfile (if necessary)
- Document the design by expanding this readme file
- Fill the `answers.yml` file where required (make sure that is committed and pushed to your repository)
- Commit the changes and push to your own repository
- Notify the examiner (fabrizio.granelli@unitn.it) that work is complete specifying the Github repository, First Name, Last Name and Matriculation number. This needs to happen at least 7 days prior an exam registration date.

# Notes and References
- https://rogerdudler.github.io/git-guide/
- http://therandomsecurityguy.com/openvswitch-cheat-sheet/
- https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/
- https://www.vagrantup.com/intro/getting-started/

# Design
- 214 indirizzi per host-A
- 270 indirizzi per host-B
- 348 indirizzi per host-C
- L'host-c deve essere in grado anche di far andare una docker image (dustnic82/nginx-test) la quale implementa un web-server che deve essere raggiungibile 
  dall'host-a e dall'host-b
- Non devono essere usate rotte dinamiche
- I router devono essere più generici possibili

## Schema della rete
![Image](rete.png)

## Subnetting
- Per la rete riguardante l'host-c dobbiamo gestire un numero di host pari a 348, per questo abbiamo bisogno di una indirizzo di rete che sia un \23 in quanto riesce a gestire un numero di host pari a (2^9)-2 = 510 indirizzi. In questo caso attribuiremo la rete 192.168.0.0\23.
- Per la rete riguardante l'host-b dobbiamo gestire un numero di host pari a 270, per questo abbiamo bisogno di una indirizzo di rete che sia un \23 in quanto riesce a gestire un numero di host pari a (2^9)-2 = 510 indirizzi. In questo caso attribuiremo la rete 192.168.2.0\23.
- Per la rete riguardante l'host-a dobbiamo gestire un numero di host pari a 214, per questo abbiamo bisogno di una indirizzo di rete che sia un \24 in quanto riesce a gestire un numero di host pari a (2^8)-2 = 254 indirizzi. In questo caso attribuiremo la rete 192.168.4.0\24.
- Per la rete tra i due router usiamo una \30 in quanto si riescono a gestire (2^2)-2 = 2 indirizzi.

## Configurazione IP
Essendo che abbiamo due reti attaccate allo stesso switch dobbiamo far si che tale switch riesca a gestire entrabe le reti tramite delle VLANs e dobbiamo creare due porte nel router-1 che funzionino ognuna da broadcast, rispettivamente per ogni rete connessa ad esso. La porta dello switch che si collega con il router-1 sarà una trunk-port, essa riuscirà a gestire il traffico delle VLANs e indirizzare i pacchetti verso il router.
```
Router-1       10.1.1.1\30           enp0s9
Router-2       10.1.1.2\30           enp0s9
Router-2       192.168.0.1\23        enp0s8
Host-c         192.168.0.2\23        enp0s8
Router-1       192.168.4.1\24        enp0s8.2
Router-1       192.168.2.1\23        enp0s8.3
Host-a         192.168.4.2\24        enp0s8
Host-b         192.168.2.2\23        enp0s8
```
## File vagrant
Una volta aperto il vagrant file la prima cosa da modificare è il "path" di ogni componente come ad esempio: 
```
router1.vm.provision "shell", path: "router-1.sh"
```
Inoltre nell'host-c va aumentata la memoria del dispositivo facendola passare da 256 MB a 512 MB per poter far gigare la docker-image:
```
vb.memory = 512
```
# Configurazione dispositivi

## Switch
Nel file `switch.sh` dobbiamo inserire delle linee di codice per far si che siano aggiunte le porte dello switch per i vari collegamenti, come ad esempio l'aggiunta della porta broadcast che collega tale dispositivo al router-1. Inoltre dobbiamo aggiungere le due porte per collegare le rispettive reti degli host-a e host-b. Il comando `sudo ip link set dev ...` farà si che tali porte siano attive nel momento in cui andremo ad effettuare il comando `vagrant up`.
```
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y tcpdump
apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common
#Startup commands for switch go here
sudo ovs-vsctl add-br switch
sudo ovs-vsctl add-port switch enp0s8
sudo ovs-vsctl add-port switch enp0s9 tag="2"
sudo ovs-vsctl add-port switch enp0s10 tag="3"
sudo ip link set dev enp0s8 up
sudo ip link set dev enp0s9 up
sudo ip link set dev enp0s10 up
```
## Router-1
Nel file `router-1.sh` dobbiamo inserire delle linee di codice per far si che siano aggiunte le porte del router per i vari collegamenti con i rispettivi indirizzi ip. Inoltre dobbiamo far si che la porta che collega il router con le due reti sottostanti sia divisa in due parti per gestire entrambi i traffici con due indirizzi broadcast diversi, rispettivamente uno per la rete collegata all'host-a e l'altro per il collegamento con la rete dell'host-b. Per fare tutto ciò utilizzeremo i seguenti comandi: `sudo ip link add link enp0s8 name enp0s8.2 type vlan id 2`, `sudo ip link add link enp0s8 name enp0s8.3 type vlan id 3`.
Il comando `sudo ip link set dev ...` farà si che tali porte siano attive nel momento in cui andremo ad effettuare il comando `vagrant up`. Infine bisogna creare la rotta statica per poter far si che dagli host-a e host-b si riesca a raggiungere l'host-c, il comando è il seguente: `sudo ip route add 192.168.0.0/23 via 10.1.1.2`.
```
export DEBIAN_FRONTEND=noninteractive
#Startup commands go here
#Enable routing
sudo sysctl -w net.ipv4.ip_forward=1
#Network and VLAN interface config
sudo ip addr add 10.1.1.1/30 dev enp0s9
sudo ip link set dev enp0s9 up
sudo ip link add link enp0s8 name enp0s8.2 type vlan id 2
sudo ip link add link enp0s8 name enp0s8.3 type vlan id 3
sudo ip addr add 192.168.4.1/24 dev enp0s8.2
sudo ip addr add 192.168.2.1/23 dev enp0s8.3
sudo ip link set dev enp0s8 up
sudo ip route add 192.168.0.0/23 via 10.1.1.2
```

## Router-2
Nel file `router-2.sh` dobbiamo inserire delle linee di codice per far si che siano aggiunte le porte del router per i vari collegamenti con i rispettivi indirizzi ip. Il comando `sudo ip link set dev ...` farà si che tali porte siano attive nel momento in cui andremo ad effettuare il comando `vagrant up`. Infine bisogna creare la rotta statica per poter far si che dall'host-c si riesca a raggiungere gli host-a e host-b, i comandi sono i seguenti: `sudo ip route add 192.168.4.0/24 via 10.1.1.1`, `sudo ip route add 192.168.2.0/23 via 10.1.1.1`.
```
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
```

## Host-a
Nel file `host-a.sh` dobbiamo inserire i comandi per poter attribuire l'indirizzo ip, per attivare la porta collegata allo switch ed infine introdurre i comandi per le rotte statiche, in modo che il pacchetto che ha come destinazione un host di un'altra rete venga invitato all'indirizzo corretto del router. Il comando per ques'ultima operazione è il seguente: `sudo ip route add [indirizzorete\lunghezza] via [indirizzorouter]`, da ripetere per ogni rete non direttamente connessa a tale host.
```
export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
sudo ip addr add 192.168.4.2/24 dev enp0s8
sudo ip link set dev enp0s8 up
sudo ip route add 10.1.1.0/30 via 192.168.4.1
sudo ip route add 192.168.0.0/23 via 192.168.4.1
sudo ip route add 192.168.2.0/23 via 192.168.4.1
```
## Host-b
Nel file `host-b.sh` dobbiamo inserire i comandi per poter attribuire l'indirizzo ip, per attivare la porta collegata allo switch ed infine introdurre i comandi per le rotte statiche, in modo che il pacchetto che ha come destinazione un host di un'altra rete venga invitato all'indirizzo corretto del router. Il comando per ques'ultima operazione è il seguente: `sudo ip route add [indirizzorete\lunghezza] via [indirizzorouter]`, da ripetere per ogni rete non direttamente connessa a tale host.
```
export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
sudo ip addr add 192.168.2.2/23 dev enp0s8
sudo ip link set dev enp0s8 up
sudo ip route add 10.1.1.0/30 via 192.168.2.1
sudo ip route add 192.168.0.0/23 via 192.168.2.1
sudo ip route add 192.168.4.0/24 via 192.168.2.1
```
## Host-c
Nel file `host-c.sh` dobbiamo inserire i comandi per poter attribuire l'indirizzo ip, per attivare la porta collegata allo switch ed infine introdurre i comandi per le rotte statiche, in modo che il pacchetto che ha come destinazione un host di un'altra rete venga invitato all'indirizzo corretto del router. Il comando per ques'ultima operazione è il seguente: `sudo ip route add [indirizzorete\lunghezza] via [indirizzorouter]`, da ripetere per ogni rete non direttamente connessa a tale host. Inoltre su questo host abbiamo aggiunto anche i comandi per installare ed attivare `docker.io` con il relativo `dustnic82/nginx-test`.
```
export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
#Network interface config
sudo ip add add 192.168.0.2/23 dev enp0s8
sudo ip link set dev enp0s8 up
sudo ip route add 10.1.1.0/30 via 192.168.0.1
sudo ip route add 192.168.4.0/24 via 192.168.0.1
sudo ip route add 192.168.2.0/23 via 192.168.0.1
#Download package information from all configured sources
sudo apt-get update
#Install and run Docker.io
sudo apt -y install docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo docker pull dustnic82/nginx-test
sudo docker run --name nginx -p 80:80 -d dustnic82/nginx-test
```
## Risultato finale
Per capire se il tutto funziona, bisogna entrare in ogni host con il comando `vagrant ssh [nomehost]` e provare a pingare gli altri host con il comando `ping [indirizzohost]`. Infine entrando nell'host-a o nell'host-b, usiamo il comando `curl 192.168.0.2` che ci darà il seguente output.
```
<!DOCTYPE html>
<html>
<head>
<title>Hello World</title>
<link href="data:image/png;base64,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" rel="icon" type="image/png" />
<style>
body {
  margin: 0px;
  font: 20px 'RobotoRegular', Arial, sans-serif;
  font-weight: 100;
  height: 100%;
  color: #0f1419;
}
div.info {
  display: table;
  background: #e8eaec;
  padding: 20px 20px 20px 20px;
  border: 1px dashed black;
  border-radius: 10px;
  margin: 0px auto auto auto;
}
div.info p {
    display: table-row;
    margin: 5px auto auto auto;
}
div.info p span {
    display: table-cell;
    padding: 10px;
}
img {
    width: 176px;
    margin: 36px auto 36px auto;
    display:block;
}
div.smaller p span {
    color: #3D5266;
}
h1, h2 {
  font-weight: 100;
}
div.check {
    padding: 0px 0px 0px 0px;
    display: table;
    margin: 36px auto auto auto;
    font: 12px 'RobotoRegular', Arial, sans-serif;
}
#footer {
    position: fixed;
    bottom: 36px;
    width: 100%;
}
#center {
    width: 400px;
    margin: 0 auto;
    font: 12px Courier;
}

</style>
<script>
var ref;
function checkRefresh(){
    if (document.cookie == "refresh=1") {
        document.getElementById("check").checked = true;
        ref = setTimeout(function(){location.reload();}, 1000);
    } else {
    }
}
function changeCookie() {
    if (document.getElementById("check").checked) {
        document.cookie = "refresh=1";
        ref = setTimeout(function(){location.reload();}, 1000);
    } else {
        document.cookie = "refresh=0";
        clearTimeout(ref);
    }
}
</script>
</head>
<body onload="checkRefresh();">
<img alt="NGINX Logo" src="http://d37h62yn5lrxxl.cloudfront.net/assets/nginx.png"/>
<div class="info">
<p><span>Server&nbsp;address:</span> <span>172.17.0.2:80</span></p>
<p><span>Server&nbsp;name:</span> <span>31ac70a30914</span></p>
<p class="smaller"><span>Date:</span> <span>16/Jan/2021:23:36:01 +0000</span></p>
<p class="smaller"><span>URI:</span> <span>/</span></p>
</div>
<br>
<div class="info">
    <p class="smaller"><span>Host:</span> <span>192.168.0.2</span></p>
    <p class="smaller"><span>X-Forwarded-For:</span> <span></span></p>
</div>

<div class="check"><input type="checkbox" id="check" onchange="changeCookie()"> Auto Refresh</div>
    <div id="footer">
        <div id="center" align="center">
            Request ID: a2643e5f70e248c000aaa0492a61d9b4<br/>
            &copy; NGINX, Inc. 2018
        </div>
    </div>
</body>
</html>
```
