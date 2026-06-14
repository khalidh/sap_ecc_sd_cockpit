# SAP ECC SD Cockpit

Application d'entrainement SD "ECC-like" pour ABAP Cloud/BTP, avec une copie documentaire de la version ECC classique.

Package ADT conseille: `ZSAP_ECC_SD_COCKPIT`.

## Contenu

- `.abapgit.xml` et `cloud/src/`: structure importable par abapGit dans ton environnement ABAP Cloud.
- `cloud/src/zsdc_*.tabl.xml`: tables locales simulant `KNA1`, `VBAK`, `VBAP`, `VBFA`.
- `cloud/src/zcl_sdc_seed.clas.abap`: charge des donnees SD de demonstration.
- `cloud/src/zcl_sdc_console.clas.abap`: cockpit console executable dans ADT.
- `abap/src/zsd_cockpit_ecc_mvp.prog.abap`: version MVP ALV simple.
- `abap/src/zsd_cockpit_ecc.prog.abap`: version complete avec navigation.
- `abap/src/zcl_sd_cockpit_*.clas.abap`: classes ABAP Objects pour types, DAO, ALV et orchestration.
- `abap/docs/README_ZSAP_SD_COCKPIT_ECC.md`: guide d'architecture, installation ADT, SE93, SAP GUI et WebGUI.

## Demarrage rapide

1. Dans abapGit, connecter ce depot au package `ZSAP_ECC_SD_COCKPIT`.
2. Verifier que le depot utilise le dossier de depart `/cloud/src/` et la logique `PREFIX`.
3. Faire `Pull`.
4. Activer les tables `ZSDC_*`, puis les classes `ZCL_SDC_*`.
5. Executer `ZCL_SDC_SEED` avec F9 pour charger les donnees.
6. Executer `ZCL_SDC_CONSOLE` avec F9 pour afficher le cockpit.

Voir le guide Cloud: [cloud/docs/README_ECC_LIKE_CLOUD.md](cloud/docs/README_ECC_LIKE_CLOUD.md).
