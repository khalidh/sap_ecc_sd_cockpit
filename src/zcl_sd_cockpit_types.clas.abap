CLASS zcl_sd_cockpit_types DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS:
      gc_stat_open TYPE c VALUE 'A',
      gc_stat_done TYPE c VALUE 'C'.

    TYPES:
      ty_r_vkorg TYPE RANGE OF vbak-vkorg,
      ty_r_vtweg TYPE RANGE OF vbak-vtweg,
      ty_r_spart TYPE RANGE OF vbak-spart,
      ty_r_kunnr TYPE RANGE OF vbak-kunnr,
      ty_r_vbeln TYPE RANGE OF vbak-vbeln,
      ty_r_audat TYPE RANGE OF vbak-audat,
      ty_stat    TYPE c LENGTH 1,
      ty_r_stat  TYPE RANGE OF ty_stat.

    TYPES:
      BEGIN OF ty_s_sel,
        vkorg TYPE ty_r_vkorg,
        vtweg TYPE ty_r_vtweg,
        spart TYPE ty_r_spart,
        kunnr TYPE ty_r_kunnr,
        vbeln TYPE ty_r_vbeln,
        audat TYPE ty_r_audat,
        lfstk TYPE ty_r_stat,
        fkstk TYPE ty_r_stat,
      END OF ty_s_sel.

    TYPES:
      BEGIN OF ty_s_order,
        vbeln           TYPE vbak-vbeln,
        audat           TYPE vbak-audat,
        kunnr           TYPE vbak-kunnr,
        name1           TYPE kna1-name1,
        vkorg           TYPE vbak-vkorg,
        vtweg           TYPE vbak-vtweg,
        spart           TYPE vbak-spart,
        auart           TYPE vbak-auart,
        netwr           TYPE vbak-netwr,
        waerk           TYPE vbak-waerk,
        lfstk           TYPE c LENGTH 1,
        fkstk           TYPE c LENGTH 1,
        item_count      TYPE i,
        delivery_vbeln  TYPE likp-vbeln,
        invoice_vbeln   TYPE vbrk-vbeln,
      END OF ty_s_order,
      ty_t_order TYPE STANDARD TABLE OF ty_s_order WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_item,
        vbeln TYPE vbap-vbeln,
        posnr TYPE vbap-posnr,
        matnr TYPE vbap-matnr,
        maktx TYPE makt-maktx,
        arktx TYPE vbap-arktx,
        kwmeng TYPE vbap-kwmeng,
        vrkme TYPE vbap-vrkme,
        netwr TYPE vbap-netwr,
        waerk TYPE vbap-waerk,
        werks TYPE vbap-werks,
        bstkd TYPE vbkd-bstkd,
      END OF ty_s_item,
      ty_t_item TYPE STANDARD TABLE OF ty_s_item WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_schedule,
        vbeln TYPE vbep-vbeln,
        posnr TYPE vbep-posnr,
        etenr TYPE vbep-etenr,
        edatu TYPE vbep-edatu,
        wmeng TYPE vbep-wmeng,
        bmeng TYPE vbep-bmeng,
        vrkme TYPE vbap-vrkme,
      END OF ty_s_schedule,
      ty_t_schedule TYPE STANDARD TABLE OF ty_s_schedule WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_docflow,
        vbelv   TYPE vbfa-vbelv,
        posnv   TYPE vbfa-posnv,
        vbeln   TYPE vbfa-vbeln,
        posnn   TYPE vbfa-posnn,
        vbtyp_n TYPE vbfa-vbtyp_n,
        rfmng   TYPE vbfa-rfmng,
        meins   TYPE vbfa-meins,
      END OF ty_s_docflow,
      ty_t_docflow TYPE STANDARD TABLE OF ty_s_docflow WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_delivery,
        vbeln     TYPE likp-vbeln,
        posnr     TYPE lips-posnr,
        lfdat     TYPE likp-lfdat,
        wadat_ist TYPE likp-wadat_ist,
        kunnr     TYPE likp-kunnr,
        matnr     TYPE lips-matnr,
        lfimg     TYPE lips-lfimg,
        vrkme     TYPE lips-vrkme,
        vgbel     TYPE lips-vgbel,
        vgpos     TYPE lips-vgpos,
      END OF ty_s_delivery,
      ty_t_delivery TYPE STANDARD TABLE OF ty_s_delivery WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_invoice,
        vbeln TYPE vbrk-vbeln,
        posnr TYPE vbrp-posnr,
        fkdat TYPE vbrk-fkdat,
        kunag TYPE vbrk-kunag,
        netwr TYPE vbrp-netwr,
        waerk TYPE vbrk-waerk,
        matnr TYPE vbrp-matnr,
        fkimg TYPE vbrp-fkimg,
        vrkme TYPE vbrp-vrkme,
        aubel TYPE vbrp-aubel,
        aupos TYPE vbrp-aupos,
      END OF ty_s_invoice,
      ty_t_invoice TYPE STANDARD TABLE OF ty_s_invoice WITH DEFAULT KEY.
ENDCLASS.

CLASS zcl_sd_cockpit_types IMPLEMENTATION.
ENDCLASS.
