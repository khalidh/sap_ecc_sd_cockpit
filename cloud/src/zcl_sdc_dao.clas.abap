CLASS zcl_sdc_dao DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES:
      ty_vbeln TYPE c LENGTH 10,
      ty_posnr TYPE n LENGTH 6,

    TYPES:
      BEGIN OF ty_order,
        vbeln          TYPE ty_vbeln,
        audat          TYPE d,
        kunnr          TYPE c LENGTH 10,
        name1          TYPE c LENGTH 80,
        vkorg          TYPE c LENGTH 4,
        vtweg          TYPE c LENGTH 2,
        spart          TYPE c LENGTH 2,
        auart          TYPE c LENGTH 4,
        netwr          TYPE p LENGTH 8 DECIMALS 2,
        waerk          TYPE c LENGTH 5,
        lfstk          TYPE c LENGTH 1,
        fkstk          TYPE c LENGTH 1,
        item_count     TYPE i,
        delivery_vbeln TYPE ty_vbeln,
        invoice_vbeln  TYPE ty_vbeln,
      END OF ty_order,
      ty_orders TYPE STANDARD TABLE OF ty_order WITH EMPTY KEY,

      BEGIN OF ty_item,
        vbeln  TYPE ty_vbeln,
        posnr  TYPE ty_posnr,
        matnr  TYPE c LENGTH 40,
        arktx  TYPE c LENGTH 40,
        kwmeng TYPE p LENGTH 7 DECIMALS 3,
        vrkme  TYPE c LENGTH 3,
        netwr  TYPE p LENGTH 8 DECIMALS 2,
        waerk  TYPE c LENGTH 5,
      END OF ty_item,
      ty_items TYPE STANDARD TABLE OF ty_item WITH EMPTY KEY,

      BEGIN OF ty_flow,
        vbelv   TYPE ty_vbeln,
        posnv   TYPE ty_posnr,
        vbeln   TYPE ty_vbeln,
        posnn   TYPE ty_posnr,
        vbtyp_n TYPE c LENGTH 1,
        rfmng   TYPE p LENGTH 7 DECIMALS 3,
        meins   TYPE c LENGTH 3,
      END OF ty_flow,
      ty_flows TYPE STANDARD TABLE OF ty_flow WITH EMPTY KEY.

    METHODS get_orders
      RETURNING VALUE(rt_orders) TYPE ty_orders.

    METHODS get_items
      IMPORTING iv_vbeln TYPE ty_vbeln
      RETURNING VALUE(rt_items) TYPE ty_items.

    METHODS get_docflow
      IMPORTING iv_vbeln TYPE ty_vbeln
      RETURNING VALUE(rt_flow) TYPE ty_flows.
ENDCLASS.

CLASS zcl_sdc_dao IMPLEMENTATION.
  METHOD get_orders.
    SELECT FROM zsdc_vbak AS h
      LEFT OUTER JOIN zsdc_kna1 AS c ON c~kunnr = h~kunnr
      FIELDS h~vbeln, h~audat, h~kunnr, c~name1,
             h~vkorg, h~vtweg, h~spart, h~auart,
             h~netwr, h~waerk, h~lfstk, h~fkstk
      ORDER BY h~vbeln
      INTO CORRESPONDING FIELDS OF TABLE @rt_orders.

    LOOP AT rt_orders ASSIGNING FIELD-SYMBOL(<order>).
      SELECT COUNT( * )
        FROM zsdc_vbap
        WHERE vbeln = @<order>-vbeln
        INTO @<order>-item_count.

      SELECT SINGLE vbeln
        FROM zsdc_vbfa
        WHERE vbelv = @<order>-vbeln
          AND vbtyp_n = 'J'
        INTO @<order>-delivery_vbeln.

      SELECT SINGLE vbeln
        FROM zsdc_vbfa
        WHERE vbelv = @<order>-vbeln
          AND vbtyp_n = 'M'
        INTO @<order>-invoice_vbeln.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_items.
    SELECT FROM zsdc_vbap
      FIELDS vbeln, posnr, matnr, arktx, kwmeng, vrkme, netwr, waerk
      WHERE vbeln = @iv_vbeln
      ORDER BY posnr
      INTO CORRESPONDING FIELDS OF TABLE @rt_items.
  ENDMETHOD.

  METHOD get_docflow.
    SELECT FROM zsdc_vbfa
      FIELDS vbelv, posnv, vbeln, posnn, vbtyp_n, rfmng, meins
      WHERE vbelv = @iv_vbeln
      ORDER BY posnv, vbtyp_n, vbeln
      INTO CORRESPONDING FIELDS OF TABLE @rt_flow.
  ENDMETHOD.
ENDCLASS.
