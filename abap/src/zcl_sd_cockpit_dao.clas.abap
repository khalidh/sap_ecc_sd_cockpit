CLASS zcl_sd_cockpit_dao DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS check_authority
      IMPORTING is_sel TYPE zcl_sd_cockpit_types=>ty_s_sel
      RAISING   zcx_sd_cockpit.

    METHODS get_orders
      IMPORTING is_sel TYPE zcl_sd_cockpit_types=>ty_s_sel
      RETURNING VALUE(rt_orders) TYPE zcl_sd_cockpit_types=>ty_t_order
      RAISING   zcx_sd_cockpit.

    METHODS get_items
      IMPORTING iv_vbeln TYPE vbak-vbeln
      RETURNING VALUE(rt_items) TYPE zcl_sd_cockpit_types=>ty_t_item.

    METHODS get_schedules
      IMPORTING iv_vbeln TYPE vbap-vbeln
                iv_posnr TYPE vbap-posnr
      RETURNING VALUE(rt_schedules) TYPE zcl_sd_cockpit_types=>ty_t_schedule.

    METHODS get_docflow
      IMPORTING iv_vbeln TYPE vbak-vbeln
      RETURNING VALUE(rt_docflow) TYPE zcl_sd_cockpit_types=>ty_t_docflow.

    METHODS get_deliveries
      IMPORTING iv_vbeln TYPE vbak-vbeln
      RETURNING VALUE(rt_deliveries) TYPE zcl_sd_cockpit_types=>ty_t_delivery.

    METHODS get_invoices
      IMPORTING iv_vbeln TYPE vbak-vbeln
      RETURNING VALUE(rt_invoices) TYPE zcl_sd_cockpit_types=>ty_t_invoice.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_s_flow_min,
        vbelv   TYPE vbfa-vbelv,
        vbeln   TYPE vbfa-vbeln,
        vbtyp_n TYPE vbfa-vbtyp_n,
      END OF ty_s_flow_min,
      ty_t_flow_min TYPE STANDARD TABLE OF ty_s_flow_min WITH DEFAULT KEY.
ENDCLASS.

CLASS zcl_sd_cockpit_dao IMPLEMENTATION.
  METHOD check_authority.
    DATA ls_vkorg LIKE LINE OF is_sel-vkorg.
    DATA lv_vkorg TYPE vbak-vkorg.

    READ TABLE is_sel-vkorg INTO ls_vkorg INDEX 1.
    IF sy-subrc = 0 AND ls_vkorg-sign = 'I' AND ls_vkorg-option = 'EQ'.
      lv_vkorg = ls_vkorg-low.
    ENDIF.

    AUTHORITY-CHECK OBJECT 'V_VBAK_VKO'
      ID 'VKORG' FIELD lv_vkorg
      ID 'VTWEG' DUMMY
      ID 'SPART' DUMMY
      ID 'ACTVT' FIELD '03'.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_sd_cockpit
        EXPORTING iv_text = 'Autorisation insuffisante pour afficher les commandes SD'.
    ENDIF.
  ENDMETHOD.

  METHOD get_orders.
    DATA lt_flow TYPE ty_t_flow_min.
    DATA ls_flow TYPE ty_s_flow_min.
    DATA ls_order TYPE zcl_sd_cockpit_types=>ty_s_order.
    DATA lt_filtered TYPE zcl_sd_cockpit_types=>ty_t_order.

    check_authority( is_sel ).

    SELECT a~vbeln a~audat a~kunnr k~name1
           a~vkorg a~vtweg a~spart a~auart a~netwr a~waerk
           COUNT( p~posnr ) AS item_count
      INTO CORRESPONDING FIELDS OF TABLE rt_orders
      FROM vbak AS a
      INNER JOIN vbap AS p ON p~vbeln = a~vbeln
      LEFT OUTER JOIN kna1 AS k ON k~kunnr = a~kunnr
      WHERE a~vkorg IN is_sel-vkorg
        AND a~vtweg IN is_sel-vtweg
        AND a~spart IN is_sel-spart
        AND a~kunnr IN is_sel-kunnr
        AND a~vbeln IN is_sel-vbeln
        AND a~audat IN is_sel-audat
      GROUP BY a~vbeln a~audat a~kunnr k~name1
               a~vkorg a~vtweg a~spart a~auart a~netwr a~waerk.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    SELECT vbelv vbeln vbtyp_n
      INTO TABLE lt_flow
      FROM vbfa
      FOR ALL ENTRIES IN rt_orders
      WHERE vbelv = rt_orders-vbeln
        AND ( vbtyp_n = 'J' OR vbtyp_n = 'M' ).

    SORT lt_flow BY vbelv vbtyp_n vbeln.

    LOOP AT rt_orders INTO ls_order.
      ls_order-lfstk = zcl_sd_cockpit_types=>gc_stat_open.
      ls_order-fkstk = zcl_sd_cockpit_types=>gc_stat_open.

      READ TABLE lt_flow INTO ls_flow
        WITH KEY vbelv = ls_order-vbeln vbtyp_n = 'J' BINARY SEARCH.
      IF sy-subrc = 0.
        ls_order-delivery_vbeln = ls_flow-vbeln.
        ls_order-lfstk = zcl_sd_cockpit_types=>gc_stat_done.
      ENDIF.

      READ TABLE lt_flow INTO ls_flow
        WITH KEY vbelv = ls_order-vbeln vbtyp_n = 'M' BINARY SEARCH.
      IF sy-subrc = 0.
        ls_order-invoice_vbeln = ls_flow-vbeln.
        ls_order-fkstk = zcl_sd_cockpit_types=>gc_stat_done.
      ENDIF.

      IF is_sel-lfstk IS NOT INITIAL AND ls_order-lfstk NOT IN is_sel-lfstk.
        CONTINUE.
      ENDIF.

      IF is_sel-fkstk IS NOT INITIAL AND ls_order-fkstk NOT IN is_sel-fkstk.
        CONTINUE.
      ENDIF.

      APPEND ls_order TO lt_filtered.
    ENDLOOP.

    rt_orders = lt_filtered.
  ENDMETHOD.

  METHOD get_items.
    SELECT p~vbeln p~posnr p~matnr t~maktx p~arktx
           p~kwmeng p~vrkme p~netwr p~waerk p~werks b~bstkd
      INTO CORRESPONDING FIELDS OF TABLE rt_items
      FROM vbap AS p
      LEFT OUTER JOIN makt AS t
        ON t~matnr = p~matnr AND t~spras = sy-langu
      LEFT OUTER JOIN vbkd AS b
        ON b~vbeln = p~vbeln AND b~posnr = p~posnr
      WHERE p~vbeln = iv_vbeln.
  ENDMETHOD.

  METHOD get_schedules.
    SELECT e~vbeln e~posnr e~etenr e~edatu e~wmeng e~bmeng p~vrkme
      INTO CORRESPONDING FIELDS OF TABLE rt_schedules
      FROM vbep AS e
      INNER JOIN vbap AS p
        ON p~vbeln = e~vbeln AND p~posnr = e~posnr
      WHERE e~vbeln = iv_vbeln
        AND e~posnr = iv_posnr.
  ENDMETHOD.

  METHOD get_docflow.
    SELECT vbelv posnv vbeln posnn vbtyp_n rfmng meins
      INTO CORRESPONDING FIELDS OF TABLE rt_docflow
      FROM vbfa
      WHERE vbelv = iv_vbeln
      ORDER BY vbelv posnv vbeln posnn.
  ENDMETHOD.

  METHOD get_deliveries.
    SELECT h~vbeln i~posnr h~lfdat h~wadat_ist h~kunnr
           i~matnr i~lfimg i~vrkme i~vgbel i~vgpos
      INTO CORRESPONDING FIELDS OF TABLE rt_deliveries
      FROM likp AS h
      INNER JOIN lips AS i ON i~vbeln = h~vbeln
      WHERE i~vgbel = iv_vbeln
      ORDER BY h~vbeln i~posnr.
  ENDMETHOD.

  METHOD get_invoices.
    SELECT h~vbeln i~posnr h~fkdat h~kunag
           i~netwr h~waerk i~matnr i~fkimg i~vrkme i~aubel i~aupos
      INTO CORRESPONDING FIELDS OF TABLE rt_invoices
      FROM vbrk AS h
      INNER JOIN vbrp AS i ON i~vbeln = h~vbeln
      WHERE i~aubel = iv_vbeln
      ORDER BY h~vbeln i~posnr.
  ENDMETHOD.
ENDCLASS.
