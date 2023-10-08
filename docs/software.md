Le projet de la Maison (Re)connectée s'articule autour de 3 parties logiciels :

## Code source

| Partie | Description | Technologies utilisées| Dépendances | Dépôt de code |
| --- | --- | --- | --- | --- |
Hardware | Partie logicielle embarquée sur le raspberry de la maquette | Python, MQTT| [Ici](https://gitlab.com/maison-reconnectee/mrc-hardware/-/blob/master/requirements-hardware.txt) et [là](https://gitlab.com/maison-reconnectee/mrc-hardware/-/blob/master/requirements-printer.txt)  | [GitLab](https://gitlab.com/maison-reconnectee/mrc-hardware)
Backend | Coeur du système qui sert à la fois sur la maquette physique (installé sur le PC principal) mais aussi sur Internet. C'est aussi la partie 'site vitrine' | Django, API Rest | [Ici](https://gitlab.com/maison-reconnectee/mrc-backend/-/blob/master/requirements.txt) | [GitLab](https://gitlab.com/maison-reconnectee/mrc-backend)
Frontend | Interface utilisateur qui sert à la fois sur la maquette physique(installé sur le PC principal) mais aussi sur Internet. C'est aussi la partie 'site vitrine' | Typescript, Angular | [Ici](https://gitlab.com/maison-reconnectee/mrc-frontend/-/blob/master/package.json)| [GitLab](https://gitlab.com/maison-reconnectee/mrc-frontend)

### Outils de build

Les dépendances sont gérées par [pip](https://pypi.org/project/pip/) pour les parties python et par [npm](https://www.npmjs.com/) pour la partie javascript. L'application typescript est gérée via [angular-cli](https://cli.angular.io/).

### Base de données

Lla base de données est une base de données SQLite aussi bien pour l'application web «en ligne» que l'application "maquette physique".


### API tiers

L'application utilise l'API de [Brevo](https://www.brevo.com/) (ex Sendinblue) pour envoyer les mails.


## Architecture logicielle

Schéma à venir

## Déploiement

Les 3 logiciels sont conteneurisé via [docker](https://www.docker.com/). Le déploiement est géré par [docker-compose](https://docs.docker.com/compose/).





