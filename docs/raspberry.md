Pour préparer le raspberry, utiliser le utilitaire [Raspberry Pi Imager](https://www.raspberrypi.com/software/)
afin de créer la carte SB:

- choisir le système d'exploitation Raspberry Pi OS (Legacy, 64-bit) Lite dans la section "Raspberry Pi OS (other)"
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
#(si vous avez des avertissements au moment de l'update) sudo apt-get --allow-releaseinfo-change update
sudo apt full-upgrade -y
sudo apt install -y git i2c-tools curl pigpio supervisor python3-pip
sudo raspi-config
  - activer l'interface I2C
sudo systemctl enable pigpiod
sudo systemctl start pigpiod
```

Ajout des ports I2C virtuels:
	
```bash
sudo nano /boot/config.txt
    (vers la ligne 42)
    dtparam=i2c_arm=on
    dtoverlay=i2c-gpio,bus=3,i2c_gpio_delay_us=1,i2c_gpio_sda=4,i2c_gpio_scl=27
    dtoverlay=i2c-gpio,bus=4,i2c_gpio_delay_us=1,i2c_gpio_sda=21,i2c_gpio_scl=13
```

# Transformer le Raspberry en point d'accès Wi-Fi

Les raspberry Pi 3B+ et 4 sont équipés d'un module Wi-Fi. Pour pouvoir les transformer 
en point d'accès Wi-Fi, il faut équiper le Raspberry d'un module Wi-Fi supplémentaire via un port USB. Pensez à bien installer les pilotes de votre carte Wifi supplémentaire.

Pour notre projet, nous avons choisi la carte [TP-Link Archer TU3](https://www.tp-link.com/fr/home-networking/usb-adapter/tl-wn823n/) avec un chipset Realtek RTL8812BU. Nous avons suivi les instructions suivantes : https://www.manuel-bauer.net/blog/install-driver-for-rtl8812bu-wifi-dongle-on-a-raspberry-pi

```bash
curl -sL https://install.raspap.com | bash -s -- --yes --openvpn 0 --adblock 0
```

Suivre les instructions d'installation de  [RaspAP](https://raspap.com/#quick) : toujours mettre 'Yes' sauf pour OpenVPN et WireGuard

Tout s'installe automatiquement et le Raspberry redémarre automatiquement

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

# Installation du programme

Récupérer le code source

```bash
git clone https://gitlab.com/maison-reconnectee/mrc-hardware.git mrc
cd mrc
```

Installation des dépendances

```bash
pip install -r requirements-hardware.txt

```

Configuration du programme

```bash
nano .env
  - mettre la bonne IP pour le PC principal
sudo ln -s /home/mrc/mrc/run-hw.conf /etc/supervisor/conf.d/run-hw.conf
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start run-hw
```

Les 3 dernières commandes permettent de démarrer le programme et de le rendre persistant. Elles ne sont qu'à exécuter lors de l'installation initiale.

