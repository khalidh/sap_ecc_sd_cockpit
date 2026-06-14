CLASS zcx_sd_cockpit DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  CREATE PUBLIC.

  PUBLIC SECTION.
    DATA mv_text TYPE string READ-ONLY.
    METHODS constructor IMPORTING iv_text TYPE string OPTIONAL.
    METHODS get_text REDEFINITION.
ENDCLASS.

CLASS zcx_sd_cockpit IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    mv_text = iv_text.
  ENDMETHOD.

  METHOD get_text.
    IF mv_text IS INITIAL.
      result = 'Erreur cockpit SD ECC'.
    ELSE.
      result = mv_text.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
