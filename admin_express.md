# Admin Express

Les données administratives (département, communes, EPCI, ...) proviennent du service admin express COG produit conjointement par l'INSEE et l'IGN.

## Modalités de téléchargement

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
