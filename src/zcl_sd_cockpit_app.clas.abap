TYPE-POOLS slis.

CLASS zcl_sd_cockpit_app DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor.
    METHODS run
      IMPORTING is_sel TYPE zcl_sd_cockpit_types=>ty_s_sel.
    METHODS handle_user_command
      IMPORTING iv_ucomm     TYPE sy-ucomm
      CHANGING  cs_selfield  TYPE slis_selfield.

  PRIVATE SECTION.
    CONSTANTS:
      mc_view_orders    TYPE c LENGTH 1 VALUE 'O',
      mc_view_items     TYPE c LENGTH 1 VALUE 'I',
      mc_view_schedules TYPE c LENGTH 1 VALUE 'S',
      mc_view_flow      TYPE c LENGTH 1 VALUE 'F',
      mc_view_deliv     TYPE c LENGTH 1 VALUE 'D',
      mc_view_bill      TYPE c LENGTH 1 VALUE 'B'.

    DATA mo_dao TYPE REF TO zcl_sd_cockpit_dao.
    DATA mv_view TYPE c LENGTH 1.
    DATA mv_current_vbeln TYPE vbak-vbeln.
    DATA mv_current_posnr TYPE vbap-posnr.
    DATA mt_orders TYPE zcl_sd_cockpit_types=>ty_t_order.
    DATA mt_items TYPE zcl_sd_cockpit_types=>ty_t_item.
    DATA mt_schedules TYPE zcl_sd_cockpit_types=>ty_t_schedule.
    DATA mt_flow TYPE zcl_sd_cockpit_types=>ty_t_docflow.
    DATA mt_deliveries TYPE zcl_sd_cockpit_types=>ty_t_delivery.
    DATA mt_invoices TYPE zcl_sd_cockpit_types=>ty_t_invoice.

    METHODS select_order_from_row
      IMPORTING iv_index TYPE sy-tabix
      RETURNING VALUE(rv_vbeln) TYPE vbak-vbeln.

    METHODS show_items
      IMPORTING iv_vbeln TYPE vbak-vbeln
      RAISING   zcx_sd_cockpit.
    METHODS show_schedules
      IMPORTING iv_vbeln TYPE vbap-vbeln
                iv_posnr TYPE vbap-posnr
      RAISING   zcx_sd_cockpit.
    METHODS show_docflow
      IMPORTING iv_vbeln TYPE vbak-vbeln
      RAISING   zcx_sd_cockpit.
    METHODS show_deliveries
      IMPORTING iv_vbeln TYPE vbak-vbeln
      RAISING   zcx_sd_cockpit.
    METHODS show_invoices
      IMPORTING iv_vbeln TYPE vbak-vbeln
      RAISING   zcx_sd_cockpit.
ENDCLASS.

CLASS zcl_sd_cockpit_app IMPLEMENTATION.
  METHOD constructor.
    CREATE OBJECT mo_dao.
  ENDMETHOD.

  METHOD run.
    DATA lx_cockpit TYPE REF TO zcx_sd_cockpit.

    TRY.
        mt_orders = mo_dao->get_orders( is_sel = is_sel ).
        mv_view = mc_view_orders.
        zcl_sd_cockpit_alv=>display_orders( it_orders = mt_orders ).
      CATCH zcx_sd_cockpit INTO lx_cockpit.
        MESSAGE lx_cockpit->get_text( ) TYPE 'E'.
    ENDTRY.
  ENDMETHOD.

  METHOD handle_user_command.
    DATA ls_item TYPE zcl_sd_cockpit_types=>ty_s_item.
    DATA lv_vbeln TYPE vbak-vbeln.
    DATA lx_cockpit TYPE REF TO zcx_sd_cockpit.

    TRY.
        CASE iv_ucomm.
          WHEN '&IC1'.
            IF mv_view = mc_view_orders.
              lv_vbeln = select_order_from_row( cs_selfield-tabindex ).
              IF lv_vbeln IS NOT INITIAL.
                show_items( lv_vbeln ).
              ENDIF.
            ELSEIF mv_view = mc_view_items.
              READ TABLE mt_items INTO ls_item INDEX cs_selfield-tabindex.
              IF sy-subrc = 0.
                show_schedules( iv_vbeln = ls_item-vbeln iv_posnr = ls_item-posnr ).
              ENDIF.
            ENDIF.

          WHEN 'ZFLOW'.
            lv_vbeln = select_order_from_row( cs_selfield-tabindex ).
            IF lv_vbeln IS INITIAL.
              lv_vbeln = mv_current_vbeln.
            ENDIF.
            show_docflow( lv_vbeln ).

          WHEN 'ZDELV'.
            lv_vbeln = select_order_from_row( cs_selfield-tabindex ).
            IF lv_vbeln IS INITIAL.
              lv_vbeln = mv_current_vbeln.
            ENDIF.
            show_deliveries( lv_vbeln ).

          WHEN 'ZBILL'.
            lv_vbeln = select_order_from_row( cs_selfield-tabindex ).
            IF lv_vbeln IS INITIAL.
              lv_vbeln = mv_current_vbeln.
            ENDIF.
            show_invoices( lv_vbeln ).
        ENDCASE.
      CATCH zcx_sd_cockpit INTO lx_cockpit.
        MESSAGE lx_cockpit->get_text( ) TYPE 'I'.
    ENDTRY.

    cs_selfield-refresh = 'X'.
  ENDMETHOD.

  METHOD select_order_from_row.
    DATA ls_order TYPE zcl_sd_cockpit_types=>ty_s_order.
    IF mv_view = mc_view_orders AND iv_index > 0.
      READ TABLE mt_orders INTO ls_order INDEX iv_index.
      IF sy-subrc = 0.
        rv_vbeln = ls_order-vbeln.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD show_items.
    IF iv_vbeln IS INITIAL.
      MESSAGE 'Selectionnez une commande' TYPE 'I'.
      RETURN.
    ENDIF.
    mv_current_vbeln = iv_vbeln.
    CLEAR mv_current_posnr.
    mt_items = mo_dao->get_items( iv_vbeln = iv_vbeln ).
    mv_view = mc_view_items.
    zcl_sd_cockpit_alv=>display_items( it_items = mt_items ).
  ENDMETHOD.

  METHOD show_schedules.
    mv_current_vbeln = iv_vbeln.
    mv_current_posnr = iv_posnr.
    mt_schedules = mo_dao->get_schedules( iv_vbeln = iv_vbeln iv_posnr = iv_posnr ).
    mv_view = mc_view_schedules.
    zcl_sd_cockpit_alv=>display_schedules( it_schedules = mt_schedules ).
  ENDMETHOD.

  METHOD show_docflow.
    IF iv_vbeln IS INITIAL.
      MESSAGE 'Selectionnez une commande' TYPE 'I'.
      RETURN.
    ENDIF.
    mv_current_vbeln = iv_vbeln.
    mt_flow = mo_dao->get_docflow( iv_vbeln = iv_vbeln ).
    mv_view = mc_view_flow.
    zcl_sd_cockpit_alv=>display_docflow( it_docflow = mt_flow ).
  ENDMETHOD.

  METHOD show_deliveries.
    IF iv_vbeln IS INITIAL.
      MESSAGE 'Selectionnez une commande' TYPE 'I'.
      RETURN.
    ENDIF.
    mv_current_vbeln = iv_vbeln.
    mt_deliveries = mo_dao->get_deliveries( iv_vbeln = iv_vbeln ).
    mv_view = mc_view_deliv.
    zcl_sd_cockpit_alv=>display_deliveries( it_deliveries = mt_deliveries ).
  ENDMETHOD.

  METHOD show_invoices.
    IF iv_vbeln IS INITIAL.
      MESSAGE 'Selectionnez une commande' TYPE 'I'.
      RETURN.
    ENDIF.
    mv_current_vbeln = iv_vbeln.
    mt_invoices = mo_dao->get_invoices( iv_vbeln = iv_vbeln ).
    mv_view = mc_view_bill.
    zcl_sd_cockpit_alv=>display_invoices( it_invoices = mt_invoices ).
  ENDMETHOD.
ENDCLASS.
