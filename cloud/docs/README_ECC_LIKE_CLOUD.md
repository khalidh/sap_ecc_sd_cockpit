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
- `ZI_SDC_CUSTOMER`: vue CDS client.
- `ZI_SDC_SALES_ORDER`: vue CDS racine commande.
- `ZI_SDC_SALES_ORDER_ITEM`: vue CDS postes.
- `ZI_SDC_DOCUMENT_FLOW`: vue CDS flux documentaire.
- `ZC_SDC_SALES_ORDER`: vue consumption annotee pour Fiori Elements.
- `ZUI_SDC_COCKPIT`: service definition.
- `ZUI_SDC_COCKPIT_O4`: service binding OData V4.

## Execution

1. Pull abapGit avec starting folder `/cloud/src/`.
2. Activer les tables `ZSDC_*`.
3. Activer `ZCL_SDC_DAO`, `ZCL_SDC_SEED`, `ZCL_SDC_CONSOLE`.
4. Executer `ZCL_SDC_SEED` avec F9.
5. Executer `ZCL_SDC_CONSOLE` avec F9.

## Fiori Elements

Le service read-only expose les entites suivantes:

- `SalesOrder`: liste principale basee sur `ZC_SDC_SALES_ORDER`.
- `SalesOrderItem`: postes de commande.
- `DocumentFlow`: flux documentaire simplifie.
- `Customer`: clients.

Ordre conseille apres import abapGit:

1. Activer les tables `ZSDC_*`.
2. Activer les vues `ZI_SDC_*`.
3. Activer `ZC_SDC_SALES_ORDER`.
4. Activer `ZUI_SDC_COCKPIT`.
5. Activer puis publier `ZUI_SDC_COCKPIT_O4`.
6. Executer `ZCL_SDC_SEED` si les tables sont vides.

URL OData V4 typique apres publication:

```text
/sap/opu/odata4/sap/zui_sdc_cockpit_o4/srvd/sap/zui_sdc_cockpit/0001/
```

Deux options d'interface:

- utiliser le squelette `app/sd-cockpit-fiori/`;
- ou lancer Fiori tools et creer une application Fiori Elements List Report/Object Page sur l'entite `SalesOrder`.

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
