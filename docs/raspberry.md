Pour préparer le raspberry, utiliser le utilitaire [Raspberry Pi Imager](https://www.raspberrypi.com/software/)
afin de créer la carte SB:

- choisir le système d'exploitation Raspberry Pi OS (64-bit)
- sélectionner la carte SD
- dans les réglages avancés :
  - nom d'hôte : `mrc-rasp`
  - activer le SSH
  - utilisateur: `mrc`
  - mot de passe: ce que vous voulez
  - configurer le Wi-Fi en fonction de votre réseau

Une fois la carte SD prête, la mettre dans le Raspberry et le démarrer.

Trouver l'adresse IP du Raspberry sur votre réseau local (par exemple avec l'application [Fing](https://www.fing.com/products/fing-app) sur votre smartphone).

Se connecter en SSH au Raspberry:

```bash
ssh mrc@<adresse IP du Raspberry>
sudo apt update
#(si vous avez des avertissements au moment de l'update) sudo apt-get --allow-releaseinfo-change updat
sudo apt full-upgrade -y
sudo apt install -y git i2c-tools curl
sudo raspi-config
  - activer l'interface I2C
```

# Transformer le Raspberry en point d'accès Wi-Fi

Les raspberry Pi 3B+ et 4 sont équipés d'un module Wi-Fi. Pour pouvoir les transformer 
en point d'accès Wi-Fi, il faut équiper le Raspberry d'un module Wi-Fi supplémentaire via un port USB. Pensez à bien installer les pilotes de votre carte Wifi supplémentaire.

Suivre les instructions d'installation de  [RaspAP](https://raspap.com/#quick) : toujours mettre 'Yes' sauf pour OpenVPN et WireGuard

Tout s'installe automatiquement. A la fin de l'installation :

```bash
sudo reboot
```

A partir de maintenant, le Raspberry est un point d'accès Wi-Fi. Il n'est plus accessible avec l'adresse IP précédemment utilisée. 
Il faut se connecter au point d'accès Wi-Fi créé par le Raspberry (par défaut : `raspi-webgui`, mot de passe : `ChangeMe`).

Dans votre navigateur favori, accédez à l'adresse `http://10.3.141.1/`, utilisateur `admin`, mot de passe `secret`

Dans l'onglet `Hotspot` :

- onglet `Basic` : changer le SSID : mrc-wifi
- onglet `Security` : changer le mot de passe du WIFI

Connecter le Raspberry à Internet soit en Ethernet (cable RJ45), soit en Wi-Fi via l'onglet `Wifi Client` de RaspAP.

Si vous avez choisi de vous connecter en Wi-Fi a Internet, il faut configurer la priorité des connexions Wi-Fi dans l'onglet `DHCP Server`. 
Mettre `305` dans le champs `Metric`  et redémarrer le raspberry.

Rédemarrer le point d'accès.

Vous pouvez maintenant vous connecter au point d'accès nommé `mrc-wifi`


# Installation de Docker

```bash
ssh mrc@10.3.141.1
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh
dockerd-rootless-setuptool.sh install
sudo usermod -aG docker mrc
```

Editer le fichier de configuration de Docker :

```bash
sudo nano /etc/docker/daemon.json
```

Ajouter la ligne suivante :

```json
{
  "hosts": ["fd://","unix:///var/run/docker.sock","tcp://0.0.0.0:2375"]
}
```

Editer le fichier de configuration de démarrage de Docker :

```bash
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo nano /lib/systemd/system/docker.service
```

Remplacer la ligne suivante :

```bash
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
```

par :

```bash
ExecStart=/usr/bin/dockerd
```

Redémarrer Docker :

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
```

Installer Docker-compose :

```bash
sudo apt install docker-compose
```

# Installation de l'application 

Ajout des ports I2C virtuels:

```bash
sudo nano /boot/config.txt
    dtparam=i2c_arm=on
    dtoverlay=i2c-gpio,bus=3,i2c_gpio_delay_us=1,i2c_gpio_sda=4,i2c_gpio_scl=27
    dtoverlay=i2c-gpio,bus=4,i2c_gpio_delay_us=1,i2c_gpio_sda=21,i2c_gpio_scl=13
```

Récupérer le code source

```bash
git clone https://gitlab.com/maison-reconnectee/mrc.git
cd mrc
git submodule init
git submodule update
git submodule foreach 'git checkout master'
git submodule foreach 'git pull origin  master'
```

Construire les images Docker :

```bash
docker-compose -f docker-compose-rasp.yml build
```

Démarrer les conteneurs Docker :

```bash
docker-compose -f docker-compose-rasp.yml up -d
```

# Mettre à jour l'application :

```bash
cd mrc
docker-compose -f docker-compose-rasp.yml stop
docker container prune -f
git pull --recurse-submodules origin master
docker-compose -f docker-compose-rasp.yml build
docker-compose -f docker-compose-rasp.yml up -d
```
