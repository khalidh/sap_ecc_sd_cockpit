# ZSAP_SD_COCKPIT_ECC

Cockpit SAP SD pour SAP ECC, executable en SAP GUI classique et SAP GUI for HTML.

## Architecture

Objet transactionnel:

- Transaction: `ZSD_COCKPIT`
- Package ADT conseille: `ZSAP_ECC_SD_COCKPIT`
- Programme principal navigable: `ZSD_COCKPIT_ECC`
- Programme MVP minimal: `ZSD_COCKPIT_ECC_MVP`
- Classe types: `ZCL_SD_COCKPIT_TYPES`
- Classe exception: `ZCX_SD_COCKPIT`
- Classe acces donnees: `ZCL_SD_COCKPIT_DAO`
- Classe affichage ALV: `ZCL_SD_COCKPIT_ALV`
- Classe orchestration: `ZCL_SD_COCKPIT_APP`

Separation:

- `ZCL_SD_COCKPIT_TYPES`: structures internes et tables typees.
- `ZCL_SD_COCKPIT_DAO`: Open SQL sur `VBAK`, `VBAP`, `VBEP`, `VBKD`, `KNA1`, `MAKT`, `VBFA`, `LIKP`, `LIPS`, `VBRK`, `VBRP`.
- `ZCL_SD_COCKPIT_ALV`: field catalog et affichage `REUSE_ALV_GRID_DISPLAY`, choisi pour une compatibilite ECC/WebGUI plus large.
- `ZCL_SD_COCKPIT_APP`: logique de navigation: commande -> postes -> echeances, et commandes toolbar vers flux/livraisons/factures.

## Sources

Le depot est structure en deux zones:

- `cloud/src/`: version ABAP Cloud/BTP importable par abapGit dans ton systeme actuel.
- `abap/src/`: version ECC classique documentaire, utile pour un futur vrai systeme ECC/S/4 on-premise.

Importer via abapGit depuis `cloud/src/` dans ton systeme actuel.

La version ECC classique contient les objets suivants:

- `abap/src/zcl_sd_cockpit_types.clas.abap`
- `abap/src/zcx_sd_cockpit.clas.abap`
- `abap/src/zcl_sd_cockpit_dao.clas.abap`
- `abap/src/zcl_sd_cockpit_alv.clas.abap`
- `abap/src/zcl_sd_cockpit_app.clas.abap`
- `abap/src/zsd_cockpit_ecc.prog.abap`
- `abap/src/zsd_cockpit_ecc_mvp.prog.abap`

## Installation avec abapGit

1. Ouvrir la vue abapGit dans Eclipse ADT.
2. Ajouter le depot `https://github.com/khalidh/sap_ecc_sd_cockpit.git`.
3. Choisir le package `ZSAP_ECC_SD_COCKPIT`.
4. Utiliser la branche `main`.
5. Verifier la configuration:
   - Starting folder: `/cloud/src/`
   - Folder logic: `PREFIX`
6. Lancer `Pull`.
7. Activer les tables `ZSDC_*`, puis les classes `ZCL_SDC_*`.
8. Executer `ZCL_SDC_SEED` avec F9 pour charger les donnees.
9. Executer `ZCL_SDC_CONSOLE` avec F9 pour afficher le cockpit.

La version `cloud/src/` evite `VBAK`, `TABLES`, `SELECTION-SCREEN` et `REUSE_ALV_GRID_DISPLAY`. Elle utilise des tables locales `ZSDC_*` pour simuler ECC dans ABAP Cloud.

## Notes ECC classique

La version `abap/src/` reste disponible pour un futur vrai SAP ECC ou S/4HANA on-premise avec SD installe. Elle ne doit pas etre importee dans ton environnement ABAP Cloud actuel.
