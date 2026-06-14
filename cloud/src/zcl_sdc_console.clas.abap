CLASS zcl_sdc_console DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_sdc_console IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA lt_orders TYPE zcl_sdc_dao=>ty_orders.
    DATA ls_order TYPE zcl_sdc_dao=>ty_order.
    DATA lt_items TYPE zcl_sdc_dao=>ty_items.
    DATA ls_item TYPE zcl_sdc_dao=>ty_item.
    DATA lt_flow TYPE zcl_sdc_dao=>ty_flows.
    DATA ls_flow TYPE zcl_sdc_dao=>ty_flow.

    lt_orders = zcl_sdc_dao=>get_orders( ).

    out->write( 'ECC-like SD Cockpit' ).
    out->write( '===================' ).

    LOOP AT lt_orders INTO ls_order.
      out->write( |Order { ls_order-vbeln } { ls_order-audat DATE = ISO } Customer { ls_order-kunnr } { ls_order-name1 }| ).
      out->write( |  Sales area { ls_order-vkorg }/{ ls_order-vtweg }/{ ls_order-spart } Type { ls_order-auart } Net { ls_order-netwr } { ls_order-waerk }| ).
      out->write( |  Delivery status { ls_order-lfstk } Billing status { ls_order-fkstk } Items { ls_order-item_count } Delivery { ls_order-delivery_vbeln } Invoice { ls_order-invoice_vbeln }| ).

      lt_items = zcl_sdc_dao=>get_items( ls_order-vbeln ).
      LOOP AT lt_items INTO ls_item.
        out->write( |    Item { ls_item-posnr } { ls_item-matnr } { ls_item-arktx } Qty { ls_item-kwmeng } { ls_item-vrkme } Net { ls_item-netwr } { ls_item-waerk }| ).
      ENDLOOP.

      lt_flow = zcl_sdc_dao=>get_docflow( ls_order-vbeln ).
      LOOP AT lt_flow INTO ls_flow.
        out->write( |    Flow { ls_flow-vbelv }/{ ls_flow-posnv } -> { ls_flow-vbeln }/{ ls_flow-posnn } category { ls_flow-vbtyp_n } qty { ls_flow-rfmng } { ls_flow-meins }| ).
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
