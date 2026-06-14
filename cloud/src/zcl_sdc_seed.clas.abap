CLASS zcl_sdc_seed DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_sdc_seed IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DELETE FROM zsdc_vbfa.
    DELETE FROM zsdc_vbap.
    DELETE FROM zsdc_vbak.
    DELETE FROM zsdc_kna1.

    INSERT zsdc_kna1 FROM TABLE @VALUE #(
      ( kunnr = '0001000001' name1 = 'ACME France' land1 = 'FR' )
      ( kunnr = '0001000002' name1 = 'Contoso Retail' land1 = 'DE' )
      ( kunnr = '0001000003' name1 = 'Northwind Bikes' land1 = 'US' ) ).

    INSERT zsdc_vbak FROM TABLE @VALUE #(
      ( vbeln = '0000005001' audat = '20260601' kunnr = '0001000001' vkorg = '1000' vtweg = '10' spart = '00' auart = 'OR' netwr = '1250.00' waerk = 'EUR' lfstk = 'C' fkstk = 'C' )
      ( vbeln = '0000005002' audat = '20260605' kunnr = '0001000002' vkorg = '1000' vtweg = '20' spart = '00' auart = 'OR' netwr = '820.00'  waerk = 'EUR' lfstk = 'C' fkstk = 'A' )
      ( vbeln = '0000005003' audat = '20260610' kunnr = '0001000003' vkorg = '2000' vtweg = '10' spart = '01' auart = 'OR' netwr = '340.00'  waerk = 'USD' lfstk = 'A' fkstk = 'A' ) ).

    INSERT zsdc_vbap FROM TABLE @VALUE #(
      ( vbeln = '0000005001' posnr = '000010' matnr = 'MAT-BIKE-001' arktx = 'Road bike frame' kwmeng = '2.000' vrkme = 'EA' netwr = '900.00' waerk = 'EUR' )
      ( vbeln = '0000005001' posnr = '000020' matnr = 'MAT-HELM-010' arktx = 'Helmet premium'  kwmeng = '5.000' vrkme = 'EA' netwr = '350.00' waerk = 'EUR' )
      ( vbeln = '0000005002' posnr = '000010' matnr = 'MAT-WHL-020'  arktx = 'Wheel set'       kwmeng = '4.000' vrkme = 'EA' netwr = '820.00' waerk = 'EUR' )
      ( vbeln = '0000005003' posnr = '000010' matnr = 'MAT-BAG-030'  arktx = 'Bike bag'        kwmeng = '2.000' vrkme = 'EA' netwr = '340.00' waerk = 'USD' ) ).

    INSERT zsdc_vbfa FROM TABLE @VALUE #(
      ( vbelv = '0000005001' posnv = '000010' vbeln = '0080007001' posnn = '000010' vbtyp_n = 'J' rfmng = '2.000' meins = 'EA' )
      ( vbelv = '0000005001' posnv = '000020' vbeln = '0080007001' posnn = '000020' vbtyp_n = 'J' rfmng = '5.000' meins = 'EA' )
      ( vbelv = '0000005001' posnv = '000010' vbeln = '0090009001' posnn = '000010' vbtyp_n = 'M' rfmng = '2.000' meins = 'EA' )
      ( vbelv = '0000005002' posnv = '000010' vbeln = '0080007002' posnn = '000010' vbtyp_n = 'J' rfmng = '4.000' meins = 'EA' ) ).

    out->write( 'ECC-like SD demo data loaded.' ).
    out->write( 'Run ZCL_SDC_CONSOLE to display the cockpit.' ).
  ENDMETHOD.
ENDCLASS.
