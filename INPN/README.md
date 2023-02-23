# Espaces protégés

Les données relatives aux espaces protégés de la région Sud PACA sont enregistrées dans la base de données. Ces données sont également accessibles via des flux WMS et WFS ou sur le géoportail.

## Origine des données

Les données proviennent du Service du Patrimoine Naturel du Muséum national d'Histoire naturelle (MNHN-SPN).  
[Description des couches SIG nationales de référence des espaces naturels](https://inpn.mnhn.fr/docs/transfertSIG.pdf)
Les données sont régulièrement mises à jour (mise à jour la plus récente: février 2023)

## Utilisation SQL et QGIS

Le projet QGIS `inpn` (schema `inpn`) permet de visualiser les tables du schema inpn:

- Parcs nationaux de métropole,
- Parcs naturels régionaux de la région Sud PACA,
- Réserves naturelles régionales de la région Sud PACA.

Toutes les tables du schema `inpn` sont en accès libre en lecture.

Les tables peuvent être importées individuellement dans un projet QGIS.  
Des symbologies (dont une par défaut) sont enregistrées pour chaque table dans la base de données. Pour ajouter ou proposer une modification de symbologie, contacter un administrateur de la base de données.  
TODO : autoriser les utilisateurs à gérer les styles qu'ils ont créés (row level security)

### Gestion historique des données

Les projets SQL et les couches QGIS qui référencent les tables INPN sont automatiquement synchronisés lorsque les tables INPN sont mises à jour (sauf si la structure des tables INPN est modifiée, ce qui peut nécessiter une mise à niveau du projet qui les utilise).  
Certains projets nécessitent que l'état des données INPN soit figé à un instant t. Ces projets ne doivent pas utiliser directement les tables INPN mais faire une copie des données (copie de table ou vue matérialisée) pour les protéger des mises à jour futuress des données source INPN.

## Flux WMS/WFS

Les données sont également accessibles via le [flux WFS](QGIS/inpn_wfs.xml) ou [WMS](QGIS/inpn_wms.xml) pour une utilisation directe dans QGIS. Ces services sont proposés par l'INPN via le service carmencarto. A la date de publication, les données disponibles en WFS sont plus anciennes que les shapefiles proposés au téléchargement.

## Geoportail

Pour visualiser les données avec un simple navigateur, utiliser le [géoportail](geoportail.gouv.fr).  
L'accès aux couches se fait par le menu Cartes > Données thématiques > Développement durable, énergie > Espaces protégés.

## Téléchargement des données (serveur INPN)

Le site de téléchargement INPN est ici :
https://inpn.mnhn.fr/telechargement/cartes-et-information-geographique/ep/pn

## Mise à jour du projet

Il est vivement recommandé de mettre à jour le projet git lorsque le schema ou le projet QGIS sont modifiés en base.

Le script [bin/dump_schema](bin/dump_schema) lit depuis la base de données la version courante du schema sql et l'enregistre dans [schema.sql](sql/schema.sql).  
Le script [bin/dump_project](bin/dump_project) télécharge la version courante du projet QGIS depuis la base de données et l'enregistre dans [inpn.qgs](QGIS/inpn.qgs).
