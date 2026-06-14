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

Les statuts livraison/facturation sont derives de `VBFA`:

- `A`: aucun document suivant trouve.
- `C`: document suivant trouve (`J` livraison, `M` facture).

Pour un statut SD complet, ajouter une jointure optionnelle sur `VBUK` avec `LFSTK` et `FKSTK` si le systeme cible autorise cette table dans le perimetre.

## Sources

Importer/creer les objets ADT avec les contenus suivants:

- `abap/src/zcl_sd_cockpit_types.clas.abap`
- `abap/src/zcx_sd_cockpit.clas.abap`
- `abap/src/zcl_sd_cockpit_dao.clas.abap`
- `abap/src/zcl_sd_cockpit_alv.clas.abap`
- `abap/src/zcl_sd_cockpit_app.clas.abap`
- `abap/src/zsd_cockpit_ecc.prog.abap`
- `abap/src/zsd_cockpit_ecc_mvp.prog.abap`

Ordre conseille:

1. `ZCL_SD_COCKPIT_TYPES`
2. `ZCX_SD_COCKPIT`
3. `ZCL_SD_COCKPIT_DAO`
4. `ZCL_SD_COCKPIT_ALV`
5. `ZCL_SD_COCKPIT_APP`
6. `ZSD_COCKPIT_ECC_MVP`
7. `ZSD_COCKPIT_ECC`

## Installation dans Eclipse ADT

1. Ouvrir le projet ABAP ECC dans Eclipse ADT.
2. Creer ou reutiliser le package `ZSAP_ECC_SD_COCKPIT`.
3. Creer les classes globales avec les noms exacts ci-dessus.
4. Coller chaque source `.clas.abap` dans la classe correspondante.
5. Creer les programmes executables `ZSD_COCKPIT_ECC_MVP` et `ZSD_COCKPIT_ECC`.
6. Activer d'abord les classes, puis les programmes.
7. Lancer `ZSD_COCKPIT_ECC_MVP` pour valider rapidement les donnees et ALV.
8. Creer le statut GUI `ZSD_COCKPIT` pour la version navigable.

## Statut GUI pour la version navigable

La version `ZSD_COCKPIT_ECC` appelle:

```abap
SET PF-STATUS 'ZSD_COCKPIT'.
```

Creer ce statut dans SE80 ou SE41 pour le programme `ZSD_COCKPIT_ECC`.

Ajouter au minimum ces boutons applicatifs:

- Texte: `Flux document`, function code: `ZFLOW`
- Texte: `Livraisons`, function code: `ZDELV`
- Texte: `Factures`, function code: `ZBILL`

Conserver les fonctions standards ALV utiles: retour, quitter, annuler, tri, filtre, export, variante.

Sans ce statut GUI, utiliser le programme MVP ou retirer temporairement `i_callback_pf_status_set` dans `ZCL_SD_COCKPIT_ALV`.

## Creation transaction SE93

1. Aller dans `SE93`.
2. Creer `ZSD_COCKPIT`.
3. Type: transaction de programme avec ecran de selection.
4. Programme: `ZSD_COCKPIT_ECC`.
5. Cocher `SAP GUI for HTML` si le systeme propose la classification GUI support.
6. Sauvegarder dans le package `ZSAP_ECC_SD_COCKPIT`.

Transaction MVP optionnelle:

- Transaction: `ZSD_COCKPIT_MVP`
- Programme: `ZSD_COCKPIT_ECC_MVP`

## Execution SAP GUI

1. Lancer `/nZSD_COCKPIT`.
2. Renseigner `VKORG`, `VTWEG`, `SPART`, `KUNNR`, `VBELN`, `AUDAT`.
3. Statuts:
   - `A`: aucun document suivant derive.
   - `C`: document suivant trouve.
4. Executer.
5. Double-cliquer une commande pour afficher les postes `VBAP`.
6. Double-cliquer un poste pour afficher les echeances `VBEP`.
7. Utiliser les boutons `Flux document`, `Livraisons`, `Factures`.

## Execution WebGUI

URL generale:

```text
https://<host>:<port>/sap/bc/gui/sap/its/webgui
```

Puis lancer la transaction:

```text
/nZSD_COCKPIT
```

URL directe typique:

```text
https://<host>:<port>/sap/bc/gui/sap/its/webgui?~transaction=ZSD_COCKPIT
```

Pre-requis:

- Service SICF `/sap/bc/gui/sap/its/webgui` actif.
- Parametrage ITS/WebGUI operationnel.
- Autorisations utilisateur SD et transaction.

## Version MVP

`ZSD_COCKPIT_ECC_MVP` est volontairement simple:

- Selection principale.
- Jointure `VBAK`/`VBAP`/`KNA1`.
- Synthese ALV.
- Aucun statut GUI custom.
- Pas de navigation.

Elle sert a verifier rapidement la compilation, les autorisations de lecture et la compatibilite ALV.

## Version amelioree

`ZSD_COCKPIT_ECC` ajoute:

- Architecture OO.
- Controle d'autorisation `V_VBAK_VKO` en affichage.
- Derivation livraison/facture via `VBFA`.
- Navigation ALV:
  - Double-clic commande -> postes.
  - Double-clic poste -> echeances.
  - Boutons -> flux, livraisons, factures.

## Limites connues WebGUI

- `REUSE_ALV_GRID_DISPLAY` est generalement plus tolerant que `CL_GUI_ALV_GRID` custom, mais certaines fonctions frontend peuvent varier selon le patch SAP GUI for HTML.
- Les boutons custom dependent du statut GUI `ZSD_COCKPIT`.
- Les popups, menus contextuels et exports locaux peuvent etre limites selon la configuration ITS.
- `CL_GUI_ALV_GRID` dans un custom container peut fonctionner en WebGUI, mais demande un dynpro 0100 et plus de tests de rendu.
- Les statuts derives via `VBFA` ne remplacent pas completement `VBUK-LFSTK` et `VBUK-FKSTK`.

## Adaptations futures Fiori/SAP BTP

Chemin de migration possible:

- Exposer la logique DAO via un module fonction RFC ou une classe API stable.
- Remplacer le programme ALV par un service OData Gateway SEGW en ECC.
- Sur S/4HANA, migrer vers CDS/RAP avec vues de consommation SD.
- Sur SAP BTP, rebatir l'UI en SAPUI5 freestyle ou Fiori Elements.
- Garder les structures de sortie proches de `TY_S_ORDER`, `TY_S_ITEM`, `TY_S_SCHEDULE` pour limiter l'impact UI.

## Notes de qualite

- Pas de `SELECT *`.
- Pas de CDS obligatoire.
- Pas de RAP, CAP, Fiori Elements ou BTP.
- Open SQL classique.
- `FOR ALL ENTRIES` utilise seulement apres controle implicite de resultat non vide.
- Les jointures principales sont indexables si `VBAK-VBELN`, `VBAP-VBELN`, `VBFA-VBELV`, `LIPS-VGBEL`, `VBRP-AUBEL` sont correctement indexes dans le systeme.
