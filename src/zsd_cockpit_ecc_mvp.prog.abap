REPORT zsd_cockpit_ecc_mvp.

TYPE-POOLS slis.

TABLES: vbak.

TYPES:
  BEGIN OF ty_s_out,
    vbeln TYPE vbak-vbeln,
    audat TYPE vbak-audat,
    kunnr TYPE vbak-kunnr,
    name1 TYPE kna1-name1,
    vkorg TYPE vbak-vkorg,
    vtweg TYPE vbak-vtweg,
    spart TYPE vbak-spart,
    auart TYPE vbak-auart,
    netwr TYPE vbak-netwr,
    waerk TYPE vbak-waerk,
    item_count TYPE i,
  END OF ty_s_out.

DATA gt_out TYPE STANDARD TABLE OF ty_s_out.
DATA gt_fcat TYPE slis_t_fieldcat_alv.
DATA gv_title TYPE c LENGTH 40.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE gv_title.
SELECT-OPTIONS:
  s_vkorg FOR vbak-vkorg,
  s_vtweg FOR vbak-vtweg,
  s_spart FOR vbak-spart,
  s_kunnr FOR vbak-kunnr,
  s_vbeln FOR vbak-vbeln,
  s_audat FOR vbak-audat.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  gv_title = 'Selection commandes SD'.

START-OF-SELECTION.
  PERFORM select_data.
  PERFORM build_fieldcat.
  PERFORM display_alv.

FORM select_data.
  SELECT a~vbeln a~audat a~kunnr k~name1
         a~vkorg a~vtweg a~spart a~auart a~netwr a~waerk
         COUNT( p~posnr ) AS item_count
    INTO CORRESPONDING FIELDS OF TABLE gt_out
    FROM vbak AS a
    INNER JOIN vbap AS p ON p~vbeln = a~vbeln
    LEFT OUTER JOIN kna1 AS k ON k~kunnr = a~kunnr
    WHERE a~vkorg IN s_vkorg
      AND a~vtweg IN s_vtweg
      AND a~spart IN s_spart
      AND a~kunnr IN s_kunnr
      AND a~vbeln IN s_vbeln
      AND a~audat IN s_audat
    GROUP BY a~vbeln a~audat a~kunnr k~name1
             a~vkorg a~vtweg a~spart a~auart a~netwr a~waerk.
ENDFORM.

FORM add_field USING iv_field TYPE slis_fieldname
                     iv_text  TYPE scrtext_l.
  DATA ls_fcat TYPE slis_fieldcat_alv.
  CLEAR ls_fcat.
  ls_fcat-fieldname = iv_field.
  ls_fcat-seltext_l = iv_text.
  ls_fcat-seltext_m = iv_text.
  ls_fcat-seltext_s = iv_text.
  APPEND ls_fcat TO gt_fcat.
ENDFORM.

FORM build_fieldcat.
  PERFORM add_field USING 'VBELN' 'Commande'.
  PERFORM add_field USING 'AUDAT' 'Date commande'.
  PERFORM add_field USING 'KUNNR' 'Client'.
  PERFORM add_field USING 'NAME1' 'Nom client'.
  PERFORM add_field USING 'VKORG' 'Org. comm.'.
  PERFORM add_field USING 'VTWEG' 'Canal'.
  PERFORM add_field USING 'SPART' 'Secteur'.
  PERFORM add_field USING 'AUART' 'Type'.
  PERFORM add_field USING 'NETWR' 'Montant net'.
  PERFORM add_field USING 'WAERK' 'Devise'.
  PERFORM add_field USING 'ITEM_COUNT' 'Nb postes'.
ENDFORM.

FORM display_alv.
  DATA ls_layout TYPE slis_layout_alv.
  ls_layout-zebra = 'X'.
  ls_layout-colwidth_optimize = 'X'.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = ls_layout
      it_fieldcat        = gt_fcat
      i_save             = 'A'
    TABLES
      t_outtab           = gt_out.
ENDFORM.
