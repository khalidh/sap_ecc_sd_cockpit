# SD Cockpit Fiori Elements

Application Fiori Elements V4 pour le service ABAP Cloud `ZUI_SDC_COCKPIT_O4`.

## Backend attendu

Importer et activer dans ABAP Cloud:

- `ZI_SDC_CUSTOMER`
- `ZI_SDC_SALES_ORDER`
- `ZI_SDC_SALES_ORDER_ITEM`
- `ZI_SDC_DOCUMENT_FLOW`
- `ZC_SDC_SALES_ORDER`
- `ZUI_SDC_COCKPIT`
- `ZUI_SDC_COCKPIT_O4`

Publier le service binding `ZUI_SDC_COCKPIT_O4`.

## Service

URI par defaut dans `webapp/manifest.json`:

```text
/sap/opu/odata4/sap/zui_sdc_cockpit_o4/srvd/sap/zui_sdc_cockpit/0001/
```

## Lancement local

Installer les dependances puis lancer:

```bash
npm install
npm start
```

En local, configure un proxy vers ton systeme ABAP si le service n'est pas servi depuis le meme host.
