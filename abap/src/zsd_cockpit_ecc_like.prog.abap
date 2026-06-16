REPORT zsd_cockpit_ecc_like.

TYPE-POOLS slis.

TABLES: zsdc_vbak.

TYPES:
  BEGIN OF ty_s_order,
    vbeln          TYPE zsdc_vbak-vbeln,
    audat          TYPE zsdc_vbak-audat,
    kunnr          TYPE zsdc_vbak-kunnr,
    name1          TYPE zsdc_kna1-name1,
    vkorg          TYPE zsdc_vbak-vkorg,
    vtweg          TYPE zsdc_vbak-vtweg,
    spart          TYPE zsdc_vbak-spart,
    auart          TYPE zsdc_vbak-auart,
    netwr          TYPE zsdc_vbak-netwr,
    waerk          TYPE zsdc_vbak-waerk,
    lfstk          TYPE zsdc_vbak-lfstk,
    fkstk          TYPE zsdc_vbak-fkstk,
    item_count     TYPE i,
    delivery_vbeln TYPE zsdc_vbfa-vbeln,
    invoice_vbeln  TYPE zsdc_vbfa-vbeln,
  END OF ty_s_order,
  ty_t_order TYPE STANDARD TABLE OF ty_s_order,

  BEGIN OF ty_s_item,
    vbeln  TYPE zsdc_vbap-vbeln,
    posnr  TYPE zsdc_vbap-posnr,
    matnr  TYPE zsdc_vbap-matnr,
    arktx  TYPE zsdc_vbap-arktx,
    kwmeng TYPE zsdc_vbap-kwmeng,
    vrkme  TYPE zsdc_vbap-vrkme,
    netwr  TYPE zsdc_vbap-netwr,
    waerk  TYPE zsdc_vbap-waerk,
  END OF ty_s_item,
  ty_t_item TYPE STANDARD TABLE OF ty_s_item,

  BEGIN OF ty_s_flow,
    vbelv   TYPE zsdc_vbfa-vbelv,
    posnv   TYPE zsdc_vbfa-posnv,
    vbeln   TYPE zsdc_vbfa-vbeln,
    posnn   TYPE zsdc_vbfa-posnn,
    vbtyp_n TYPE zsdc_vbfa-vbtyp_n,
    rfmng   TYPE zsdc_vbfa-rfmng,
    meins   TYPE zsdc_vbfa-meins,
  END OF ty_s_flow,
  ty_t_flow TYPE STANDARD TABLE OF ty_s_flow.

DATA gt_orders TYPE ty_t_order.
DATA gv_title TYPE c LENGTH 40.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE gv_title.
SELECT-OPTIONS:
  s_vkorg FOR zsdc_vbak-vkorg,
  s_vtweg FOR zsdc_vbak-vtweg,
  s_spart FOR zsdc_vbak-spart,
  s_kunnr FOR zsdc_vbak-kunnr,
  s_vbeln FOR zsdc_vbak-vbeln,
  s_audat FOR zsdc_vbak-audat,
  s_lfstk FOR zsdc_vbak-lfstk,
  s_fkstk FOR zsdc_vbak-fkstk.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  gv_title = 'Selection commandes SD'.

START-OF-SELECTION.
  PERFORM select_orders.
  PERFORM display_orders.

FORM select_orders.
  SELECT h~vbeln h~audat h~kunnr k~name1
         h~vkorg h~vtweg h~spart h~auart h~netwr h~waerk
         h~lfstk h~fkstk COUNT( i~posnr ) AS item_count
    INTO CORRESPONDING FIELDS OF TABLE gt_orders
    FROM zsdc_vbak AS h
    INNER JOIN zsdc_vbap AS i ON i~vbeln = h~vbeln
    LEFT OUTER JOIN zsdc_kna1 AS k ON k~kunnr = h~kunnr
    WHERE h~vkorg IN s_vkorg
      AND h~vtweg IN s_vtweg
      AND h~spart IN s_spart
      AND h~kunnr IN s_kunnr
      AND h~vbeln IN s_vbeln
      AND h~audat IN s_audat
      AND h~lfstk IN s_lfstk
      AND h~fkstk IN s_fkstk
    GROUP BY h~vbeln h~audat h~kunnr k~name1
             h~vkorg h~vtweg h~spart h~auart h~netwr h~waerk
             h~lfstk h~fkstk.

  PERFORM enrich_follow_on_docs.
ENDFORM.

FORM enrich_follow_on_docs.
  DATA ls_order TYPE ty_s_order.
  DATA ls_flow TYPE ty_s_flow.
  DATA lt_flow TYPE ty_t_flow.

  IF gt_orders IS INITIAL.
    RETURN.
  ENDIF.

  SELECT vbelv posnv vbeln posnn vbtyp_n rfmng meins
    INTO CORRESPONDING FIELDS OF TABLE lt_flow
    FROM zsdc_vbfa
    FOR ALL ENTRIES IN gt_orders
    WHERE vbelv = gt_orders-vbeln
      AND ( vbtyp_n = 'J' OR vbtyp_n = 'M' ).

  LOOP AT gt_orders INTO ls_order.
    READ TABLE lt_flow INTO ls_flow
      WITH KEY vbelv = ls_order-vbeln vbtyp_n = 'J'.
    IF sy-subrc = 0.
      ls_order-delivery_vbeln = ls_flow-vbeln.
    ENDIF.

    READ TABLE lt_flow INTO ls_flow
      WITH KEY vbelv = ls_order-vbeln vbtyp_n = 'M'.
    IF sy-subrc = 0.
      ls_order-invoice_vbeln = ls_flow-vbeln.
    ENDIF.

    MODIFY gt_orders FROM ls_order.
  ENDLOOP.
ENDFORM.

FORM add_field USING iv_field TYPE slis_fieldname
                     iv_text  TYPE scrtext_l
                     iv_key   TYPE c
               CHANGING ct_fcat TYPE slis_t_fieldcat_alv.
  DATA ls_fcat TYPE slis_fieldcat_alv.
  CLEAR ls_fcat.
  ls_fcat-fieldname = iv_field.
  ls_fcat-seltext_l = iv_text.
  ls_fcat-seltext_m = iv_text.
  ls_fcat-seltext_s = iv_text.
  ls_fcat-key = iv_key.
  APPEND ls_fcat TO ct_fcat.
ENDFORM.

FORM display_table USING it_data TYPE ANY TABLE
                         iv_title TYPE lvc_title
                         it_fcat TYPE slis_t_fieldcat_alv.
  DATA ls_layout TYPE slis_layout_alv.
  ls_layout-zebra = 'X'.
  ls_layout-colwidth_optimize = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_callback_user_command = 'USER_COMMAND'
      i_grid_title            = iv_title
      is_layout               = ls_layout
      it_fieldcat             = it_fcat
      i_save                  = 'A'
    TABLES
      t_outtab                = it_data.
ENDFORM.

FORM display_orders.
  DATA lt_fcat TYPE slis_t_fieldcat_alv.
  PERFORM add_field USING 'VBELN' 'Commande' 'X' CHANGING lt_fcat.
  PERFORM add_field USING 'AUDAT' 'Date commande' '' CHANGING lt_fcat.
  PERFORM add_field USING 'KUNNR' 'Client' '' CHANGING lt_fcat.
  PERFORM add_field USING 'NAME1' 'Nom client' '' CHANGING lt_fcat.
  PERFORM add_field USING 'VKORG' 'Org. comm.' '' CHANGING lt_fcat.
  PERFORM add_field USING 'VTWEG' 'Canal' '' CHANGING lt_fcat.
  PERFORM add_field USING 'SPART' 'Secteur' '' CHANGING lt_fcat.
  PERFORM add_field USING 'AUART' 'Type' '' CHANGING lt_fcat.
  PERFORM add_field USING 'NETWR' 'Montant net' '' CHANGING lt_fcat.
  PERFORM add_field USING 'WAERK' 'Devise' '' CHANGING lt_fcat.
  PERFORM add_field USING 'LFSTK' 'Statut liv.' '' CHANGING lt_fcat.
  PERFORM add_field USING 'FKSTK' 'Statut fact.' '' CHANGING lt_fcat.
  PERFORM add_field USING 'ITEM_COUNT' 'Nb postes' '' CHANGING lt_fcat.
  PERFORM add_field USING 'DELIVERY_VBELN' 'Livraison' '' CHANGING lt_fcat.
  PERFORM add_field USING 'INVOICE_VBELN' 'Facture' '' CHANGING lt_fcat.
  PERFORM display_table USING gt_orders 'Cockpit SD ECC-like - Commandes' lt_fcat.
ENDFORM.

FORM display_items USING iv_vbeln TYPE zsdc_vbak-vbeln.
  DATA lt_items TYPE ty_t_item.
  DATA lt_fcat TYPE slis_t_fieldcat_alv.

  SELECT vbeln posnr matnr arktx kwmeng vrkme netwr waerk
    INTO CORRESPONDING FIELDS OF TABLE lt_items
    FROM zsdc_vbap
    WHERE vbeln = iv_vbeln
    ORDER BY posnr.

  PERFORM add_field USING 'VBELN' 'Commande' 'X' CHANGING lt_fcat.
  PERFORM add_field USING 'POSNR' 'Poste' 'X' CHANGING lt_fcat.
  PERFORM add_field USING 'MATNR' 'Article' '' CHANGING lt_fcat.
  PERFORM add_field USING 'ARKTX' 'Description' '' CHANGING lt_fcat.
  PERFORM add_field USING 'KWMENG' 'Quantite' '' CHANGING lt_fcat.
  PERFORM add_field USING 'VRKME' 'UQ' '' CHANGING lt_fcat.
  PERFORM add_field USING 'NETWR' 'Montant net' '' CHANGING lt_fcat.
  PERFORM add_field USING 'WAERK' 'Devise' '' CHANGING lt_fcat.
  PERFORM display_table USING lt_items 'Cockpit SD ECC-like - Postes' lt_fcat.
ENDFORM.

FORM display_docflow USING iv_vbeln TYPE zsdc_vbak-vbeln.
  DATA lt_flow TYPE ty_t_flow.
  DATA lt_fcat TYPE slis_t_fieldcat_alv.

  SELECT vbelv posnv vbeln posnn vbtyp_n rfmng meins
    INTO CORRESPONDING FIELDS OF TABLE lt_flow
    FROM zsdc_vbfa
    WHERE vbelv = iv_vbeln
    ORDER BY posnv vbeln posnn.

  PERFORM add_field USING 'VBELV' 'Doc. precedent' 'X' CHANGING lt_fcat.
  PERFORM add_field USING 'POSNV' 'Poste prec.' 'X' CHANGING lt_fcat.
  PERFORM add_field USING 'VBELN' 'Doc. suivant' '' CHANGING lt_fcat.
  PERFORM add_field USING 'POSNN' 'Poste suiv.' '' CHANGING lt_fcat.
  PERFORM add_field USING 'VBTYP_N' 'Categorie' '' CHANGING lt_fcat.
  PERFORM add_field USING 'RFMNG' 'Quantite' '' CHANGING lt_fcat.
  PERFORM add_field USING 'MEINS' 'UQ' '' CHANGING lt_fcat.
  PERFORM display_table USING lt_flow 'Cockpit SD ECC-like - Flux document' lt_fcat.
ENDFORM.

FORM user_command USING r_ucomm LIKE sy-ucomm
                        rs_selfield TYPE slis_selfield.
  DATA ls_order TYPE ty_s_order.

  CASE r_ucomm.
    WHEN '&IC1'.
      IF rs_selfield-fieldname = 'VBELN' OR rs_selfield-fieldname IS INITIAL.
        READ TABLE gt_orders INTO ls_order INDEX rs_selfield-tabindex.
        IF sy-subrc = 0.
          PERFORM display_items USING ls_order-vbeln.
        ENDIF.
      ELSEIF rs_selfield-fieldname = 'DELIVERY_VBELN'
          OR rs_selfield-fieldname = 'INVOICE_VBELN'.
        READ TABLE gt_orders INTO ls_order INDEX rs_selfield-tabindex.
        IF sy-subrc = 0.
          PERFORM display_docflow USING ls_order-vbeln.
        ENDIF.
      ENDIF.
  ENDCASE.
ENDFORM.
