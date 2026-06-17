# SAP ECC SD Cockpit

Application d'entrainement SD "ECC-like" pour ABAP Cloud/BTP, avec une copie documentaire de la version ECC classique.

Cette branche `exercise-tables-only` est volontairement limitee aux tables et classes de base. Elle sert a t'exercer a creer toi-meme la couche CDS, le service OData V4 et l'application Fiori Elements.

Package ADT conseille: `ZSAP_ECC_SD_COCKPIT`.

## Contenu

- `.abapgit.xml` et `cloud/src/`: structure importable par abapGit dans ton environnement ABAP Cloud.
- `cloud/src/zsdc_*.tabl.xml`: tables locales simulant `KNA1`, `VBAK`, `VBAP`, `VBFA`.
- `cloud/src/zcl_sdc_seed.clas.abap`: charge des donnees SD de demonstration.
- `cloud/src/zcl_sdc_console.clas.abap`: cockpit console executable dans ADT.
- `abap/src/zsd_cockpit_ecc_mvp.prog.abap`: version MVP ALV simple.
- `abap/src/zsd_cockpit_ecc.prog.abap`: version complete avec navigation.
- `abap/src/zsd_cockpit_ecc_seed.prog.abap`: charge des donnees de demonstration dans les tables `ZSDC_*`.
- `abap/src/zsd_cockpit_ecc_like.prog.abap`: cockpit ALV ECC-like base sur les tables `ZSDC_*`, sans Fiori/RAP/CDS.
- `abap/src/zcl_sd_cockpit_*.clas.abap`: classes ABAP Objects pour types, DAO, ALV et orchestration.
- `abap/src/zcx_sd_cockpit.clas.abap`: classe exception.
- `abap/docs/README_ZSAP_SD_COCKPIT_ECC.md`: guide d'architecture, installation ADT, SE93, SAP GUI et WebGUI.

## Demarrage rapide

1. Dans abapGit, connecter ce depot au package `ZSAP_ECC_SD_COCKPIT`.
2. Verifier que le depot utilise le dossier de depart `/cloud/src/` et la logique `PREFIX`.
3. Faire `Pull`.
4. Activer les tables `ZSDC_*`, puis les classes `ZCL_SDC_*`.
5. Executer `ZCL_SDC_SEED` avec F9 pour charger les donnees.
6. Executer `ZCL_SDC_CONSOLE` avec F9 pour afficher le cockpit.

## Exercice a realiser

Cette branche ne contient pas encore les objets suivants. C'est a toi de les creer avec VS Code et ADT:

1. Vues CDS interface: `ZI_SDC_CUSTOMER`, `ZI_SDC_SALES_ORDER`, `ZI_SDC_SALES_ORDER_ITEM`, `ZI_SDC_DOCUMENT_FLOW`.
2. Vue CDS consumption: `ZC_SDC_SALES_ORDER`.
3. Annotations UI pour List Report/Object Page.
4. Service definition: `ZUI_SDC_COCKPIT`.
5. Service binding OData V4: `ZUI_SDC_COCKPIT_O4`.
6. Application Fiori Elements basee sur l'entite principale `SalesOrder`.

## Mode ECC-like pur SAP GUI

Pour tester avec des outils SAP ECC classiques, importer `abap/src/` dans un systeme ECC/S/4 sandbox puis executer:

1. `ZSD_COCKPIT_ECC_SEED` dans `SE38` ou `SA38`.
2. `ZSD_COCKPIT_ECC_LIKE` dans `SE38` ou `SA38`.

Cette variante utilise uniquement les tables locales `ZSDC_*` et un ALV `REUSE_ALV_GRID_DISPLAY`.

Voir le guide complet: [abap/docs/README_ZSAP_SD_COCKPIT_ECC.md](abap/docs/README_ZSAP_SD_COCKPIT_ECC.md).
