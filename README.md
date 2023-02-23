# Données géographiques réglementaires

Ce projet décrit les procédures d'accès aux données géographiques réglementaires du Parc national du Mercantour (par exemple les limites réglementaires du PNM, la liste des communes de l'aire optimale d'adhésion) ainsi qu'aux données administratives et réglementaires régionales (par exemple la liste de l'ensemble des communes de la région Sud PACA ou la liste des espaces protégés) enregistrées dans la base de données du PNM.

Les emprises réglementaires du PNM, quotidiennement utilisées dans des traitements de données, sont structurées pour faciliter et accélérer les traitements en base de données (par exemple : observations naturalistes sur le territoire d'une commune du Parc). En particulier, toutes les données géographiques spécifiques sont redécoupées suivant le pavage des mailles 1km réglementaires en projection légale et leur utilisation optimale s'appuie sur les principes exposés ci dessous.  
L'utilisation du schema `limites` (limites réglementaires et communes du PNM, intersections entre les géométries remarquables, projets SQL et QGIS) est décrite dans le sous dossier [limites](limites).

L'utilisation des données régionales est décrite dans les dossiers :

- [admin_express](admin_express): Service admin express COG (code officiel géographique) de l'INSEE et l'IGN.
- [INPN](INPN): Espaces protégés de la région Sud PACA.
