# ECC-like SD Simulator for ABAP Cloud - Tables Only

Cette branche simule un mini SD ECC dans ton environnement ABAP Cloud/BTP.

Elle est volontairement incomplete: elle contient les tables et les classes de base, mais pas encore les vues CDS, le service OData V4 ni l'application Fiori Elements. Le but est de t'entrainer a construire cette couche toi-meme.

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

## Exercice CDS et Fiori Elements

Apres avoir valide les tables et la console, cree progressivement:

1. `ZI_SDC_CUSTOMER`: vue CDS client.
2. `ZI_SDC_SALES_ORDER`: vue CDS racine commande.
3. `ZI_SDC_SALES_ORDER_ITEM`: vue CDS postes.
4. `ZI_SDC_DOCUMENT_FLOW`: vue CDS flux documentaire.
5. `ZC_SDC_SALES_ORDER`: vue consumption annotee pour Fiori Elements.
6. `ZUI_SDC_COCKPIT`: service definition.
7. `ZUI_SDC_COCKPIT_O4`: service binding OData V4.
8. Une app Fiori Elements List Report/Object Page sur `SalesOrder`.

URL OData V4 typique attendue apres publication:

```text
/sap/opu/odata4/sap/zui_sdc_cockpit_o4/srvd/sap/zui_sdc_cockpit/0001/
```

Dans Fiori tools:

1. `Fiori: Open Application Generator`.
2. Choisir `List Report Page`.
3. Choisir ton systeme `BTP_Trial_ABAP_TRL`.
4. Choisir le service `ZUI_SDC_COCKPIT_O4`.
5. Choisir l'entite principale `SalesOrder`.

## Objectif migration

Cette simulation te permet de pratiquer:

- mapping de tables ECC vers tables custom BTP;
- lecture type DAO;
- separation donnees / logique / affichage;
- donnees de demo;
- evolution future vers CDS, RAP et service OData.
