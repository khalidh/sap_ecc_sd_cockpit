# SAP ECC SD Cockpit

Application ABAP ECC `ZSAP_SD_COCKPIT_ECC` pour cockpit SD executable en SAP GUI classique et SAP GUI for HTML/WebGUI.

## Contenu

- `abap/src/zsd_cockpit_ecc_mvp.prog.abap`: version MVP ALV simple.
- `abap/src/zsd_cockpit_ecc.prog.abap`: version complete avec navigation.
- `abap/src/zcl_sd_cockpit_*.clas.abap`: classes ABAP Objects pour types, DAO, ALV et orchestration.
- `abap/src/zcx_sd_cockpit.clas.abap`: classe exception.
- `abap/docs/README_ZSAP_SD_COCKPIT_ECC.md`: guide d'architecture, installation ADT, SE93, SAP GUI et WebGUI.

## Demarrage rapide

1. Creer les objets ABAP dans Eclipse ADT.
2. Activer les classes, puis les programmes.
3. Tester d'abord `ZSD_COCKPIT_ECC_MVP`.
4. Creer la transaction `ZSD_COCKPIT` sur le programme `ZSD_COCKPIT_ECC`.
5. Creer le statut GUI `ZSD_COCKPIT` avec les function codes `ZFLOW`, `ZDELV`, `ZBILL`.

Voir le guide complet: [abap/docs/README_ZSAP_SD_COCKPIT_ECC.md](abap/docs/README_ZSAP_SD_COCKPIT_ECC.md).
