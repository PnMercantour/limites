# Admin Express

Les données administratives (département, communes, EPCI, ...) proviennent du service admin express COG produit conjointement par l'INSEE et l'IGN.  
Les données en base donnent accès à la région Sud PACA, aux départements de la région, aux EPCI inclus dans les départements des Alpes de Haute Provence et des Alpes Maritimes (ainsi qu'aux EPCI contigus), aux communes (multipolygon) et aux chefs lieu (point) des communes de ces deux départements, aux anciennes communes de Larche et Meyronnes.

## Version

ADMIN-EXPRESS-COG-CARTO_3-1\_\_SHP_LAMB93_FXX_2022-04-15

## Utilisation

Le projet QGIS `Code officiel géographique` (schema `admin_express`) permet de parcourir les données administratives régionales (des relations sont établies entre les différentes couches pour faciliter la navigation à partir des outils QGIS d'identification des entités).

Toutes les tables du schema `admin_express` sont en accès libre en lecture.

A noter que les communes du territoire du PNM sont directement accessibles dans le schema limites.

## Modalités de téléchargement (pour les administrateurs)

Télécharger la livraison la plus récente du référentiel administratif, dans sa version COG (Code officiel géographique) CARTO (géométries simplifiées pour améliorer la performance des outils cartographiques).

https://geoservices.ign.fr/adminexpress#telechargementCogCarto

Utiliser QGIS ou OGR/GDAL pour filtrer les données et les pousser en base.

- Remplacer, sans reprojection, le SRS officiel de l'IGN par le SRS 2154. La précision des géométries est de 10cm.

- Filtrer les tables selon l'emprise désirée

  - communes 04 ou 06
  - communes associées/déléguées pertinentes (Meyronnes, Larche)
  - Chef lieu des communes ci-dessus (coordonnées de la mairie des communes)
  - EPCI intégrant ou jouxtant les communes 04 ou 06
  - Départements de la région Sud PACA
  - Région

On garde la structure des tables IGN pour simplifier l'import ultérieur de mises à jour.

- Charger les tables en base de données dans le schema `admin_express`

  - Convertir les noms de tables et les champs en minuscule
  - créer un index géographique

- Après chargement, ajouter les index et clés étrangères nécessaires.

## Mise à jour du projet

Les scripts [bin/dump_schema]() et [bin/dump_project]() lisent depuis la base de données la version courante du schema sql et du projet QGIS et les enregistrent dans ce projet git: [sql/schema.sql]() et [QGIS/Code officiel géographique.qgs]().
