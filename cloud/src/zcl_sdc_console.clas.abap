CLASS zcl_sdc_console DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_sdc_console IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(lo_dao) = NEW zcl_sdc_dao( ).
    DATA(lt_orders) = lo_dao->get_orders( ).

    out->write( 'ECC-like SD Cockpit' ).
    out->write( '===================' ).

    LOOP AT lt_orders INTO DATA(ls_order).
      out->write( |Order { ls_order-vbeln } { ls_order-audat DATE = ISO } Customer { ls_order-kunnr } { ls_order-name1 }| ).
      out->write( |  Sales area { ls_order-vkorg }/{ ls_order-vtweg }/{ ls_order-spart } Type { ls_order-auart } Net { ls_order-netwr } { ls_order-waerk }| ).
      out->write( |  Delivery status { ls_order-lfstk } Billing status { ls_order-fkstk } Items { ls_order-item_count } Delivery { ls_order-delivery_vbeln } Invoice { ls_order-invoice_vbeln }| ).

      DATA(lt_items) = lo_dao->get_items( ls_order-vbeln ).
      LOOP AT lt_items INTO DATA(ls_item).
        out->write( |    Item { ls_item-posnr } { ls_item-matnr } { ls_item-arktx } Qty { ls_item-kwmeng } { ls_item-vrkme } Net { ls_item-netwr } { ls_item-waerk }| ).
      ENDLOOP.

      DATA(lt_flow) = lo_dao->get_docflow( ls_order-vbeln ).
      LOOP AT lt_flow INTO DATA(ls_flow).
        out->write( |    Flow { ls_flow-vbelv }/{ ls_flow-posnv } -> { ls_flow-vbeln }/{ ls_flow-posnn } category { ls_flow-vbtyp_n } qty { ls_flow-rfmng } { ls_flow-meins }| ).
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
