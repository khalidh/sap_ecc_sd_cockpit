REPORT zsd_cockpit_ecc.

TYPE-POOLS slis.

TABLES: vbak.

DATA gv_lfstk TYPE c LENGTH 1.
DATA gv_fkstk TYPE c LENGTH 1.
DATA gv_title TYPE c LENGTH 40.
DATA go_app TYPE REF TO zcl_sd_cockpit_app.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE gv_title.
SELECT-OPTIONS:
  s_vkorg FOR vbak-vkorg,
  s_vtweg FOR vbak-vtweg,
  s_spart FOR vbak-spart,
  s_kunnr FOR vbak-kunnr,
  s_vbeln FOR vbak-vbeln,
  s_audat FOR vbak-audat,
  s_lfstk FOR gv_lfstk,
  s_fkstk FOR gv_fkstk.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  gv_title = 'Selection commandes SD'.

START-OF-SELECTION.
  DATA ls_sel TYPE zcl_sd_cockpit_types=>ty_s_sel.

  ls_sel-vkorg = s_vkorg[].
  ls_sel-vtweg = s_vtweg[].
  ls_sel-spart = s_spart[].
  ls_sel-kunnr = s_kunnr[].
  ls_sel-vbeln = s_vbeln[].
  ls_sel-audat = s_audat[].
  ls_sel-lfstk = s_lfstk[].
  ls_sel-fkstk = s_fkstk[].

  CREATE OBJECT go_app.
  go_app->run( is_sel = ls_sel ).

FORM set_pf_status USING rt_extab TYPE slis_t_extab.
  SET PF-STATUS 'ZSD_COCKPIT' EXCLUDING rt_extab.
ENDFORM.

FORM user_command USING r_ucomm LIKE sy-ucomm
                        rs_selfield TYPE slis_selfield.
  IF go_app IS BOUND.
    go_app->handle_user_command(
      EXPORTING iv_ucomm = r_ucomm
      CHANGING  cs_selfield = rs_selfield ).
  ENDIF.
ENDFORM.
