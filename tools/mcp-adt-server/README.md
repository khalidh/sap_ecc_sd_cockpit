# SAP ADT MCP Server

Serveur MCP local pour connecter Codex a un systeme ABAP via les endpoints HTTP ADT, les memes services backend qu'Eclipse ADT utilise.

## Prerequis SAP

- Le systeme ABAP doit etre accessible en HTTPS/HTTP depuis cette machine.
- Le service SICF `/sap/bc/adt` doit etre actif.
- Ton utilisateur SAP doit avoir les autorisations ADT necessaires.
- Dans Eclipse ADT, l'URL du systeme ressemble souvent a `https://host:port`.

## Configuration Codex

### ECC / on-premise avec Basic Auth

Ajoute ce bloc dans `/home/khalid/.codex/config.toml`, puis redemarre Codex:

```toml
[mcp_servers.abap_adt]
command = "node"
args = ["/home/khalid/projets-vscode/SAP_ECC_SD_Cockpit/tools/mcp-adt-server/server.js"]

[mcp_servers.abap_adt.env]
SAP_ADT_URL = "https://your-sap-host:44300"
SAP_ADT_AUTH = "basic"
SAP_ADT_CLIENT = "100"
SAP_ADT_USER = "YOUR_USER"
SAP_ADT_PASSWORD = "YOUR_PASSWORD"
SAP_ADT_LANGUAGE = "EN"
SAP_REJECT_UNAUTHORIZED = "true"
```

### SAP ABAP Trial / BTP ABAP Environment avec Service Key OAuth

Dans SAP BTP Cockpit, ouvre ton instance ABAP Environment, puis cree ou ouvre une Service Key. Recupere ces champs:

- `url`
- `uaa.url`
- `uaa.clientid`
- `uaa.clientsecret`

Puis configure Codex comme ceci:

```toml
[mcp_servers.abap_adt]
command = "node"
args = ["/home/khalid/projets-vscode/SAP_ECC_SD_Cockpit/tools/mcp-adt-server/server.js"]

[mcp_servers.abap_adt.env]
SAP_ADT_URL = "https://your-abap-instance.abap.region.hana.ondemand.com"
SAP_ADT_AUTH = "oauth"
SAP_ADT_OAUTH_URL = "https://your-xsuaa.authentication.region.hana.ondemand.com"
SAP_ADT_CLIENT_ID = "YOUR_SERVICE_KEY_CLIENT_ID"
SAP_ADT_CLIENT_SECRET = "YOUR_SERVICE_KEY_CLIENT_SECRET"
SAP_ADT_LANGUAGE = "EN"
SAP_REJECT_UNAUTHORIZED = "true"
```

Si ton systeme utilise un certificat local/self-signed, mets temporairement:

```toml
SAP_REJECT_UNAUTHORIZED = "false"
```

## Test manuel

Depuis ce dossier:

```bash
SAP_ADT_URL="https://your-sap-host:44300" \
SAP_ADT_AUTH="basic" \
SAP_ADT_CLIENT="100" \
SAP_ADT_USER="YOUR_USER" \
SAP_ADT_PASSWORD="YOUR_PASSWORD" \
npm run check
```

Pour ABAP Trial:

```bash
SAP_ADT_URL="https://your-abap-instance.abap.region.hana.ondemand.com" \
SAP_ADT_AUTH="oauth" \
SAP_ADT_OAUTH_URL="https://your-xsuaa.authentication.region.hana.ondemand.com" \
SAP_ADT_CLIENT_ID="YOUR_SERVICE_KEY_CLIENT_ID" \
SAP_ADT_CLIENT_SECRET="YOUR_SERVICE_KEY_CLIENT_SECRET" \
npm run check
```

Si la connexion fonctionne, le serveur repond:

```text
Connected to ADT. HTTP 200. Content-Type: ...
```

## Outils MCP exposes

- `adt_ping`: verifie la connexion ADT.
- `adt_discovery`: lit `/sap/bc/adt/discovery`.
- `adt_get`: appelle un chemin ADT brut.
- `adt_search_objects`: recherche rapide d'objets ABAP.
- `adt_read_class_source`: lit le source actif d'une classe globale.
- `adt_read_program_source`: lit le source actif d'un programme.

## Notes

Ce serveur ne se connecte pas a l'application Eclipse elle-meme. Il se connecte au backend ABAP via ADT HTTP, exactement comme Eclipse ADT le fait cote serveur.

Ne commit pas tes mots de passe. Mets-les dans `config.toml`, dans un gestionnaire de secrets, ou exporte-les en variables d'environnement locales.
