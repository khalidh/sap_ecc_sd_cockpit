# ECC-like SD Simulator for ABAP Cloud

Cette version simule un mini SD ECC dans ton environnement ABAP Cloud/BTP.

## Objets

- `ZSDC_KNA1`: client, equivalent simplifie de `KNA1`.
- `ZSDC_VBAK`: entete commande, equivalent simplifie de `VBAK`.
- `ZSDC_VBAP`: poste commande, equivalent simplifie de `VBAP`.
- `ZSDC_VBFA`: flux documentaire, equivalent simplifie de `VBFA`.
- `ZCL_SDC_DAO`: acces donnees.
- `ZCL_SDC_SEED`: chargement des donnees de demonstration.
- `ZCL_SDC_CONSOLE`: cockpit executable dans ADT.

## Execution

1. Pull abapGit avec starting folder `/cloud/src/`.
2. Activer les tables `ZSDC_*`.
3. Activer `ZCL_SDC_DAO`, `ZCL_SDC_SEED`, `ZCL_SDC_CONSOLE`.
4. Executer `ZCL_SDC_SEED` avec F9.
5. Executer `ZCL_SDC_CONSOLE` avec F9.

## Objectif migration

Cette simulation te permet de pratiquer:

- mapping de tables ECC vers tables custom BTP;
- lecture type DAO;
- separation donnees / logique / affichage;
- donnees de demo;
- evolution future vers CDS, RAP et service OData.
