CLASS zcl_sdc_seed DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_sdc_seed IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA lt_kna1 TYPE STANDARD TABLE OF zsdc_kna1.
    DATA ls_kna1 TYPE zsdc_kna1.
    DATA lt_vbak TYPE STANDARD TABLE OF zsdc_vbak.
    DATA ls_vbak TYPE zsdc_vbak.
    DATA lt_vbap TYPE STANDARD TABLE OF zsdc_vbap.
    DATA ls_vbap TYPE zsdc_vbap.
    DATA lt_vbfa TYPE STANDARD TABLE OF zsdc_vbfa.
    DATA ls_vbfa TYPE zsdc_vbfa.

    DELETE FROM zsdc_vbfa.
    DELETE FROM zsdc_vbap.
    DELETE FROM zsdc_vbak.
    DELETE FROM zsdc_kna1.

    CLEAR ls_kna1.
    ls_kna1-kunnr = '0001000001'.
    ls_kna1-name1 = 'ACME France'.
    ls_kna1-land1 = 'FR'.
    APPEND ls_kna1 TO lt_kna1.

    CLEAR ls_kna1.
    ls_kna1-kunnr = '0001000002'.
    ls_kna1-name1 = 'Contoso Retail'.
    ls_kna1-land1 = 'DE'.
    APPEND ls_kna1 TO lt_kna1.

    CLEAR ls_kna1.
    ls_kna1-kunnr = '0001000003'.
    ls_kna1-name1 = 'Northwind Bikes'.
    ls_kna1-land1 = 'US'.
    APPEND ls_kna1 TO lt_kna1.

    INSERT zsdc_kna1 FROM TABLE @lt_kna1.

    CLEAR ls_vbak.
    ls_vbak-vbeln = '0000005001'.
    ls_vbak-audat = '20260601'.
    ls_vbak-kunnr = '0001000001'.
    ls_vbak-vkorg = '1000'.
    ls_vbak-vtweg = '10'.
    ls_vbak-spart = '00'.
    ls_vbak-auart = 'OR'.
    ls_vbak-netwr = '1250.00'.
    ls_vbak-waerk = 'EUR'.
    ls_vbak-lfstk = 'C'.
    ls_vbak-fkstk = 'C'.
    APPEND ls_vbak TO lt_vbak.

    CLEAR ls_vbak.
    ls_vbak-vbeln = '0000005002'.
    ls_vbak-audat = '20260605'.
    ls_vbak-kunnr = '0001000002'.
    ls_vbak-vkorg = '1000'.
    ls_vbak-vtweg = '20'.
    ls_vbak-spart = '00'.
    ls_vbak-auart = 'OR'.
    ls_vbak-netwr = '820.00'.
    ls_vbak-waerk = 'EUR'.
    ls_vbak-lfstk = 'C'.
    ls_vbak-fkstk = 'A'.
    APPEND ls_vbak TO lt_vbak.

    CLEAR ls_vbak.
    ls_vbak-vbeln = '0000005003'.
    ls_vbak-audat = '20260610'.
    ls_vbak-kunnr = '0001000003'.
    ls_vbak-vkorg = '2000'.
    ls_vbak-vtweg = '10'.
    ls_vbak-spart = '01'.
    ls_vbak-auart = 'OR'.
    ls_vbak-netwr = '340.00'.
    ls_vbak-waerk = 'USD'.
    ls_vbak-lfstk = 'A'.
    ls_vbak-fkstk = 'A'.
    APPEND ls_vbak TO lt_vbak.

    INSERT zsdc_vbak FROM TABLE @lt_vbak.

    CLEAR ls_vbap.
    ls_vbap-vbeln = '0000005001'.
    ls_vbap-posnr = '000010'.
    ls_vbap-matnr = 'MAT-BIKE-001'.
    ls_vbap-arktx = 'Road bike frame'.
    ls_vbap-kwmeng = '2.000'.
    ls_vbap-vrkme = 'EA'.
    ls_vbap-netwr = '900.00'.
    ls_vbap-waerk = 'EUR'.
    APPEND ls_vbap TO lt_vbap.

    CLEAR ls_vbap.
    ls_vbap-vbeln = '0000005001'.
    ls_vbap-posnr = '000020'.
    ls_vbap-matnr = 'MAT-HELM-010'.
    ls_vbap-arktx = 'Helmet premium'.
    ls_vbap-kwmeng = '5.000'.
    ls_vbap-vrkme = 'EA'.
    ls_vbap-netwr = '350.00'.
    ls_vbap-waerk = 'EUR'.
    APPEND ls_vbap TO lt_vbap.

    CLEAR ls_vbap.
    ls_vbap-vbeln = '0000005002'.
    ls_vbap-posnr = '000010'.
    ls_vbap-matnr = 'MAT-WHL-020'.
    ls_vbap-arktx = 'Wheel set'.
    ls_vbap-kwmeng = '4.000'.
    ls_vbap-vrkme = 'EA'.
    ls_vbap-netwr = '820.00'.
    ls_vbap-waerk = 'EUR'.
    APPEND ls_vbap TO lt_vbap.

    CLEAR ls_vbap.
    ls_vbap-vbeln = '0000005003'.
    ls_vbap-posnr = '000010'.
    ls_vbap-matnr = 'MAT-BAG-030'.
    ls_vbap-arktx = 'Bike bag'.
    ls_vbap-kwmeng = '2.000'.
    ls_vbap-vrkme = 'EA'.
    ls_vbap-netwr = '340.00'.
    ls_vbap-waerk = 'USD'.
    APPEND ls_vbap TO lt_vbap.

    INSERT zsdc_vbap FROM TABLE @lt_vbap.

    CLEAR ls_vbfa.
    ls_vbfa-vbelv = '0000005001'.
    ls_vbfa-posnv = '000010'.
    ls_vbfa-vbeln = '0080007001'.
    ls_vbfa-posnn = '000010'.
    ls_vbfa-vbtyp_n = 'J'.
    ls_vbfa-rfmng = '2.000'.
    ls_vbfa-meins = 'EA'.
    APPEND ls_vbfa TO lt_vbfa.

    CLEAR ls_vbfa.
    ls_vbfa-vbelv = '0000005001'.
    ls_vbfa-posnv = '000020'.
    ls_vbfa-vbeln = '0080007001'.
    ls_vbfa-posnn = '000020'.
    ls_vbfa-vbtyp_n = 'J'.
    ls_vbfa-rfmng = '5.000'.
    ls_vbfa-meins = 'EA'.
    APPEND ls_vbfa TO lt_vbfa.

    CLEAR ls_vbfa.
    ls_vbfa-vbelv = '0000005001'.
    ls_vbfa-posnv = '000010'.
    ls_vbfa-vbeln = '0090009001'.
    ls_vbfa-posnn = '000010'.
    ls_vbfa-vbtyp_n = 'M'.
    ls_vbfa-rfmng = '2.000'.
    ls_vbfa-meins = 'EA'.
    APPEND ls_vbfa TO lt_vbfa.

    CLEAR ls_vbfa.
    ls_vbfa-vbelv = '0000005002'.
    ls_vbfa-posnv = '000010'.
    ls_vbfa-vbeln = '0080007002'.
    ls_vbfa-posnn = '000010'.
    ls_vbfa-vbtyp_n = 'J'.
    ls_vbfa-rfmng = '4.000'.
    ls_vbfa-meins = 'EA'.
    APPEND ls_vbfa TO lt_vbfa.

    INSERT zsdc_vbfa FROM TABLE @lt_vbfa.

    out->write( 'ECC-like SD demo data loaded.' ).
    out->write( 'Run ZCL_SDC_CONSOLE to display the cockpit.' ).
  ENDMETHOD.
ENDCLASS.
