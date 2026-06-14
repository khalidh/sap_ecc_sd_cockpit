TYPE-POOLS slis.

CLASS zcl_sd_cockpit_alv DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS display_orders
      IMPORTING it_orders TYPE zcl_sd_cockpit_types=>ty_t_order
      RAISING   zcx_sd_cockpit.

    CLASS-METHODS display_items
      IMPORTING it_items TYPE zcl_sd_cockpit_types=>ty_t_item
      RAISING   zcx_sd_cockpit.

    CLASS-METHODS display_schedules
      IMPORTING it_schedules TYPE zcl_sd_cockpit_types=>ty_t_schedule
      RAISING   zcx_sd_cockpit.

    CLASS-METHODS display_docflow
      IMPORTING it_docflow TYPE zcl_sd_cockpit_types=>ty_t_docflow
      RAISING   zcx_sd_cockpit.

    CLASS-METHODS display_deliveries
      IMPORTING it_deliveries TYPE zcl_sd_cockpit_types=>ty_t_delivery
      RAISING   zcx_sd_cockpit.

    CLASS-METHODS display_invoices
      IMPORTING it_invoices TYPE zcl_sd_cockpit_types=>ty_t_invoice
      RAISING   zcx_sd_cockpit.

  PRIVATE SECTION.
    CLASS-METHODS add_field
      CHANGING  ct_fcat TYPE slis_t_fieldcat_alv
      IMPORTING iv_field TYPE slis_fieldname
                iv_text  TYPE scrtext_l
                iv_key   TYPE c OPTIONAL.

    CLASS-METHODS display
      IMPORTING it_data TYPE ANY TABLE
                it_fcat TYPE slis_t_fieldcat_alv
                iv_title TYPE lvc_title
      RAISING   zcx_sd_cockpit.
ENDCLASS.

CLASS zcl_sd_cockpit_alv IMPLEMENTATION.
  METHOD add_field.
    DATA ls_fcat TYPE slis_fieldcat_alv.
    CLEAR ls_fcat.
    ls_fcat-fieldname = iv_field.
    ls_fcat-seltext_l = iv_text.
    ls_fcat-seltext_m = iv_text.
    ls_fcat-seltext_s = iv_text.
    ls_fcat-key = iv_key.
    APPEND ls_fcat TO ct_fcat.
  ENDMETHOD.

  METHOD display.
    DATA ls_layout TYPE slis_layout_alv.
    ls_layout-zebra = 'X'.
    ls_layout-colwidth_optimize = 'X'.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program       = sy-repid
        i_callback_pf_status_set = 'SET_PF_STATUS'
        i_callback_user_command  = 'USER_COMMAND'
        i_grid_title             = iv_title
        is_layout                = ls_layout
        it_fieldcat              = it_fcat
        i_save                   = 'A'
      TABLES
        t_outtab                 = it_data
      EXCEPTIONS
        program_error            = 1
        OTHERS                   = 2.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_sd_cockpit
        EXPORTING iv_text = 'Erreur pendant l affichage ALV'.
    ENDIF.
  ENDMETHOD.

  METHOD display_orders.
    DATA lt_fcat TYPE slis_t_fieldcat_alv.
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'VBELN' iv_text = 'Commande' iv_key = 'X' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'AUDAT' iv_text = 'Date commande' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'KUNNR' iv_text = 'Client' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'NAME1' iv_text = 'Nom client' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'VKORG' iv_text = 'Org. comm.' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'VTWEG' iv_text = 'Canal' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'SPART' iv_text = 'Secteur' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'AUART' iv_text = 'Type' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'NETWR' iv_text = 'Montant net' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'WAERK' iv_text = 'Devise' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'LFSTK' iv_text = 'Statut liv.' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'FKSTK' iv_text = 'Statut fact.' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'ITEM_COUNT' iv_text = 'Nb postes' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'DELIVERY_VBELN' iv_text = 'Livraison' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'INVOICE_VBELN' iv_text = 'Facture' ).
    display( it_data = it_orders it_fcat = lt_fcat iv_title = 'Cockpit SD - Commandes' ).
  ENDMETHOD.

  METHOD display_items.
    DATA lt_fcat TYPE slis_t_fieldcat_alv.
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'VBELN' iv_text = 'Commande' iv_key = 'X' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'POSNR' iv_text = 'Poste' iv_key = 'X' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'MATNR' iv_text = 'Article' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'MAKTX' iv_text = 'Description' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'KWMENG' iv_text = 'Quantite' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'VRKME' iv_text = 'UQ' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'NETWR' iv_text = 'Montant net' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'WAERK' iv_text = 'Devise' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'WERKS' iv_text = 'Division' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'BSTKD' iv_text = 'Ref. client' ).
    display( it_data = it_items it_fcat = lt_fcat iv_title = 'Cockpit SD - Postes commande' ).
  ENDMETHOD.

  METHOD display_schedules.
    DATA lt_fcat TYPE slis_t_fieldcat_alv.
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'VBELN' iv_text = 'Commande' iv_key = 'X' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'POSNR' iv_text = 'Poste' iv_key = 'X' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'ETENR' iv_text = 'Echeance' iv_key = 'X' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'EDATU' iv_text = 'Date ech.' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'WMENG' iv_text = 'Qte demandee' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'BMENG' iv_text = 'Qte confirmee' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'VRKME' iv_text = 'UQ' ).
    display( it_data = it_schedules it_fcat = lt_fcat iv_title = 'Cockpit SD - Echeances' ).
  ENDMETHOD.

  METHOD display_docflow.
    DATA lt_fcat TYPE slis_t_fieldcat_alv.
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'VBELV' iv_text = 'Doc. precedent' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'POSNV' iv_text = 'Poste prec.' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'VBELN' iv_text = 'Doc. suivant' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'POSNN' iv_text = 'Poste suiv.' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'VBTYP_N' iv_text = 'Categorie' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'RFMNG' iv_text = 'Quantite' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'MEINS' iv_text = 'UQ' ).
    display( it_data = it_docflow it_fcat = lt_fcat iv_title = 'Cockpit SD - Flux document' ).
  ENDMETHOD.

  METHOD display_deliveries.
    DATA lt_fcat TYPE slis_t_fieldcat_alv.
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'VBELN' iv_text = 'Livraison' iv_key = 'X' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'POSNR' iv_text = 'Poste' iv_key = 'X' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'LFDAT' iv_text = 'Date liv.' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'WADAT_IST' iv_text = 'Sortie march.' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'KUNNR' iv_text = 'Client' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'MATNR' iv_text = 'Article' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'LFIMG' iv_text = 'Qte livree' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'VRKME' iv_text = 'UQ' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'VGBEL' iv_text = 'Commande' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'VGPOS' iv_text = 'Poste cmd' ).
    display( it_data = it_deliveries it_fcat = lt_fcat iv_title = 'Cockpit SD - Livraisons' ).
  ENDMETHOD.

  METHOD display_invoices.
    DATA lt_fcat TYPE slis_t_fieldcat_alv.
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'VBELN' iv_text = 'Facture' iv_key = 'X' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'POSNR' iv_text = 'Poste' iv_key = 'X' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'FKDAT' iv_text = 'Date facture' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'KUNAG' iv_text = 'Donneur ordre' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'NETWR' iv_text = 'Montant net' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'WAERK' iv_text = 'Devise' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'MATNR' iv_text = 'Article' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'FKIMG' iv_text = 'Qte facturee' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'VRKME' iv_text = 'UQ' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'AUBEL' iv_text = 'Commande' ).
    add_field( CHANGING ct_fcat = lt_fcat EXPORTING iv_field = 'AUPOS' iv_text = 'Poste cmd' ).
    display( it_data = it_invoices it_fcat = lt_fcat iv_title = 'Cockpit SD - Factures' ).
  ENDMETHOD.
ENDCLASS.
