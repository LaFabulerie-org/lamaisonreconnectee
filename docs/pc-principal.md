Le PC principal est un PC installé sous Linux (Debian est un bon choix)

L'installation du système d'exploitation peut se faire grâce à une clé USB bootable.

Un fois le système d'exploitation installé, installer les paquets suivants :

```bash
sudo apt update
sudo apt full-upgrade
sudo apt install git libjpeg-dev cups ca-certificates curl gnupg
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

Éditer le fichier `/etc/udev/rules.d/99-escpos.rules`

```bash
sudo nano /etc/udev/rules.d/99-escpos.rules
```

Ajouter la ligne suivante :

```bash
SUBSYSTEM=="usb", ATTR{idVendor}=="1fc9", ATTR{idProduct}=="2016", MODE="0666", GROUP="dialout"
```

L'idVendor et idProduct sont à adapter en fonction de votre imprimante. Vous les obtenir en lançant la commande `lsusb` et en repérant la ligne correspondant à votre imprimante.

Redémarrer udev :

```bash
sudo service udev restart
```

Installer les pilotes de l'imprimante le cas échéant :

```bash
cd mrc_hardware
./POS-80
sudo usermod -a -G lpadmin mrc
sudo usermod -a -G dialout mrc
```

Le reste de la configuration se fait via l'interface web de CUPS : http://localhost:631

# Installation de Docker

```bash
```

# Installation de l'application

- Créer le fichier `.env` à la racine du répertoire `mrc-backend` en se basant sur le fichier `.env.example`
- Créer le fichier `src/environments/environment.ts` à la racine du répertoire `mrc-frontend` en se basant sur le fichier `src/environments/environment.example.ts`

```bash
docker-compose -f docker-compose-pc.yml build
docker-compose -f docker-compose-pc.yml up -d
```

# Création d'un super-utilisateur pour se connecter à l'interface d'administration 

```bash
docker-compose -f docker-compose-pc.yml run mrc_backend python manage.py createsuperuser
```
