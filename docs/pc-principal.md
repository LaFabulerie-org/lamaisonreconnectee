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
sudo chmod 666 /var/run/docker.sock
```

# Configuration de l'application

- Créer le fichier `.env.standalone` à la racine du répertoire `mrc-backend` en se basant sur le fichier `.env.example`. (Attention, sous Linux, les fichiers commençant par un `.` sont cachés)
- Créer le fichier `environment.ts` à la racine du répertoire `mrc-frontend/src/environments/` en se basant sur le fichier `src/environments/environment.example.ts`

Différentes valeurs sont à adapter en fonction de votre configuration :

| Type d'installation |  Backend <br> (fichier mrc-backend/.env.standalone) | Frontend <br> (fichier mrc-frontend/src/environments/environment.ts) |
|---------------------|-----------------------------------------------------|---------------------------------------------------------------------|
| Web | <ul><li>`EXECUTION_MODE` = `WEB`</li><li>`ORIGINS` = la liste des URLs frontend autorisées à se connecter au backend, ex : https://app.lamaisonreconnectee.fr</li><li>`SENDINBLUE_API_KEY` = la clé d'API fournit par [Sendinblue/Brevo](https://www.brevo.com/fr/) pour l'envoi d'email</li></ul>  | <ul><li>`serverHost` = l'URL qui permet d'accèder au backend</li><li>`isStandalone` = `false` (ne peut pas être `true`)<li>`houseless` = true (ne peut pas être `false`</li><li>`apiKey` = la clé d'API généré sur dans l'admin du backend</li></ul> |
| Standalone avec maquette physique | <ul><li>`EXECUTION_MODE` = `STANDALONE`</li><li>`ORIGINS` = Idem config web, ex. : http://192.168.1.42 ou encore http://10.3.141.203</li><li>`SENDINBLUE_API_KEY` = Idem config web</li></ul> |<ul><li>`serverHost` = idem config web, il y a de forte chance qu'ici l'url sous de la forme `http://<ADRESSE_IP_SERVER>:<PORT_SERVER>`, ex. http://192.168.1.15:8080</li><li>`isStandalone` = `true` (ne peut pas être `false`)<li>`houseless` = `false` (ne peut pas être `true`</li><li>`apiKey` = `null`, ne sert pas.</li></ul> | 
| Standalone sans maquette physique | Idem que avec maquette | Idem que avec maquette mais `houseless` = `true` |

Il ne peut il y aucune autre combinaison possible.


# Installation de l'application


A la racine du répertoire `mrc`, lancer la commande suivante :

```bash
./build_pc.sh
docker compose -f docker-compose-pc.yml up -d
```

Création d'un super-utilisateur pour se connecter aux interfaces d'administration 

```bash
docker compose -f docker-compose-pc.yml run mrc_backend python manage.py createsuperuser
```
Attention, le nom d'utilisateur et l'email doivent etre identique.

# Accès à votre maison reconnectée

- Frontend : `http://<IP_PC_PRINCIPAL>`
- Backoffice 'animateur' : `http://<IP_PC_PRINCIPAL>/<admin`
- Backoffice 'administrateur' (django) : `http://<IP_PC_PRINCIPAL>:8080/admin`
