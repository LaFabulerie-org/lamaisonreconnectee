Le PC principal est un PC installé sous Linux comme [Ubuntu Server](https://ubuntu.com/download/server)

L'installation du système d'exploitation peut se faire grâce à une clé USB bootable.
Le PC principal doit s'appeler `mrc-pc` et l'utilisateur principal, `mrc`.

Une fois le système d'exploitation installé, installer les paquets suivants :

```bash
sudo apt update
sudo apt full-upgrade
sudo apt install  openssh-server openssh-client git libjpeg-dev cups ca-certificates curl gnupg
```

# Récupération du code source

```bash
git clone https://gitlab.com/maison-reconnectee/mrc.git
cd mrc
git submodule init
git submodule update
git submodule foreach 'git checkout master'
git submodule foreach 'git pull origin  master'
```

# Installation de l'imprimante thermique

Dans notre cas, il s'agit d'une imprimante UNIKA UK56007 compatible avec le protocol ESC/POS.

```bash
lsusb
Bus 001 Device 045: ID 1fc9:2016 NXP Semiconductors USB Printer
```

Éditer le fichier `/etc/udev/rules.d/99-escpos.rules`

```bash
sudo nano /etc/udev/rules.d/99-escpos.rules
```

Ajouter la ligne suivante :

```bash
SUBSYSTEM=="usb", ATTR{idVendor}=="1fc9", ATTR{idProduct}=="2016", MODE="0666", GROUP="dialout"
```

L'idVendor et idProduct sont à adapter en fonction de votre imprimante. Vous les obtenir en lançant la commande `lsusb` et en repérant la ligne correspondant à votre imprimante.
Ces valeurs devront aussi être renseignées dans le fichier `docker-compose-pc.yml` dans la section `devices` du service `mrc_printer`.

Redémarrer udev :

```bash
sudo service udev restart
```

Installer les pilotes de l'imprimante le cas échéant :

```bash
cd mrc-hardware
sudo usermod -a -G lpadmin mrc
sudo usermod -a -G dialout mrc
sudo ./POS-80
```

Le reste de la configuration se fait via l'interface web de CUPS : http://localhost:631

- onglet `Administration` > `Ajouter une imprimante`
- sélectionner `Printer POS-80` et cliquer sur `Continuer`, puis `Continuer`
- dans le champs `Marque`, sélectionner `POS` et cliquer sur `Continuer`
- dans le champs `Modèle`, sélectionner `POS-80` et cliquer sur `Ajouter l'imprimante`

# Installation de Docker

https://docs.docker.com/engine/install/ubuntu/

Ne pas oublier d'ajouter l'utilisateur `mrc` au groupe `docker` :

```bash
sudo usermod -aG docker mrc
```

Installation de [DockStation](https://dockstation.io/)

```bash
wget https://github.com/DockStation/dockstation/releases/download/v1.5.1/dockstation_1.5.1_amd64.deb
sudo apt install ./dockstation_1.5.1_amd64.deb
```

# Installation de l'application

- Créer le fichier `.env` à la racine du répertoire `mrc-backend` en se basant sur le fichier `.env.example`
- Créer le fichier `src/environments/environment.ts` à la racine du répertoire `mrc-frontend` en se basant sur le fichier `src/environments/environment.example.ts`

```bash
docker compose -f docker-compose-pc.yml build
docker compose -f docker-compose-pc.yml up -d
```

## Création d'un super-utilisateur pour se connecter à l'interface d'administration 

```bash
docker compose -f docker-compose-pc.yml run mrc_backend python manage.py createsuperuser
```
Attention, le nom d'utilisateur et l'email doivent etre identique.
