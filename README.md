# SAP ECC SD Cockpit

Application ABAP ECC `ZSAP_SD_COCKPIT_ECC` pour cockpit SD executable en SAP GUI classique et SAP GUI for HTML/WebGUI.

Package ADT conseille: `ZSAP_ECC_SD_COCKPIT`.

## Contenu

- `.abapgit.xml` et `abap/src/`: structure importable par abapGit.
- `abap/src/zsd_cockpit_ecc_mvp.prog.abap`: version MVP ALV simple.
- `abap/src/zsd_cockpit_ecc.prog.abap`: version complete avec navigation.
- `abap/src/zcl_sd_cockpit_*.clas.abap`: classes ABAP Objects pour types, DAO, ALV et orchestration.
- `abap/src/zcx_sd_cockpit.clas.abap`: classe exception.
- `abap/docs/README_ZSAP_SD_COCKPIT_ECC.md`: guide d'architecture, installation ADT, SE93, SAP GUI et WebGUI.

## Demarrage rapide

1. Dans abapGit, connecter ce depot au package `ZSAP_ECC_SD_COCKPIT`.
2. Verifier que le depot utilise le dossier de depart `/abap/src/` et la logique `PREFIX`.
3. Faire `Pull`.
4. Activer les classes, puis les programmes.
5. Tester d'abord `ZSD_COCKPIT_ECC_MVP`.
6. Creer la transaction `ZSD_COCKPIT` sur le programme `ZSD_COCKPIT_ECC`.
7. Creer le statut GUI `ZSD_COCKPIT` avec les function codes `ZFLOW`, `ZDELV`, `ZBILL`.

Voir le guide complet: [abap/docs/README_ZSAP_SD_COCKPIT_ECC.md](abap/docs/README_ZSAP_SD_COCKPIT_ECC.md).
