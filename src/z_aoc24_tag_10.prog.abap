*&---------------------------------------------------------------------*
*& Report Z_AOC24_TAG_10
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_aoc24_tag_10.

TYPES: BEGIN OF ty_trailheads,
         x TYPE i,
         y TYPE i,
       END OF ty_trailheads.

DATA: lv_filename TYPE string,
      lt_data     TYPE TABLE OF string,
      lv_data     TYPE string.

DATA: lv_length     TYPE i,
      lv_counter    TYPE i,
      lv_zeichen    TYPE c LENGTH 1,
      lv_zahl       TYPE i,
      lt_zeile      LIKE TABLE OF lv_zeichen,
      lt_zeile_tab  LIKE TABLE OF lt_zeile,
      lv_x          TYPE i,
      lv_y          TYPE i,
      lv_result     TYPE i,
      ls_trailhead  TYPE ty_trailheads,
      lt_trailheads TYPE TABLE OF ty_trailheads.

lv_filename = 'I:\Advent_of_Code\Tag_10.txt'.

CALL METHOD cl_gui_frontend_services=>gui_upload
  EXPORTING
    filename = lv_filename
    codepage = '1100'
  CHANGING
    data_tab = lt_data
  EXCEPTIONS
    OTHERS   = 1.

IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
           WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

*****************************************************************************
* Part 1
*****************************************************************************

LOOP AT lt_data INTO lv_data.

  CLEAR: lv_counter, lt_zeile.
  lv_length = strlen( lv_data ).

  DO lv_length TIMES.
    lv_zeichen = lv_data+lv_counter(1).
    APPEND lv_zeichen TO lt_zeile.
    lv_counter = lv_counter + 1.
  ENDDO.

  APPEND lt_zeile TO lt_zeile_tab. " Tabelle zusammenbauen, in der alle Zeichen einzeln sind

ENDLOOP.

LOOP AT lt_zeile_tab INTO lt_zeile.

  lv_y = sy-tabix.

  LOOP AT lt_zeile INTO lv_zeichen.

    lv_x = sy-tabix.

    IF lv_zeichen = 0.

      lv_zahl = lv_zeichen.

      CLEAR lt_trailheads.

      PERFORM check_next_number1
        USING lv_zahl lv_x lv_y.

    ENDIF.
  ENDLOOP.
ENDLOOP.

WRITE: / lv_result.

*****************************************************************************
* Part 2
*****************************************************************************

CLEAR lv_result.

LOOP AT lt_zeile_tab INTO lt_zeile.

  lv_y = sy-tabix.

  LOOP AT lt_zeile INTO lv_zeichen.

    lv_x = sy-tabix.

    IF lv_zeichen = 0.

      lv_zahl = lv_zeichen.

      PERFORM check_next_number2
        USING lv_zahl lv_x lv_y.

    ENDIF.
  ENDLOOP.
ENDLOOP.

WRITE: / lv_result.

*****************************************************************************
* Form Part 1
*****************************************************************************
FORM check_next_number1 USING number TYPE i
                             x TYPE i
                             y TYPE i.

  DATA: lv_zahl_form    TYPE i,
        lv_zeichen_form TYPE c LENGTH 1,
        lt_zeile_form   LIKE TABLE OF lv_zeichen_form,
        lv_new_x        TYPE i,
        lv_new_y        TYPE i.

* Links
  CLEAR: lt_zeile_form, lv_zeichen_form, lv_zahl_form.
  lv_new_x = x - 1.
  lv_new_y = y.
  READ TABLE lt_zeile_tab INDEX lv_new_y INTO lt_zeile_form.
  IF sy-subrc = 0.
    READ TABLE lt_zeile_form INDEX lv_new_x INTO lv_zeichen_form.
    IF sy-subrc = 0.
      lv_zahl_form = lv_zeichen_form.
      IF lv_zahl_form = 9 AND lv_zahl_form = number + 1.

        ls_trailhead-x = lv_new_x.
        ls_trailhead-y = lv_new_y.
        READ TABLE lt_trailheads WITH KEY x = lv_new_x y = lv_new_y TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          APPEND ls_trailhead TO lt_trailheads.
          lv_result = lv_result + 1.
        ENDIF.

      ELSEIF lv_zahl_form = number + 1.

        PERFORM check_next_number1
          USING lv_zahl_form lv_new_x lv_new_y.

      ENDIF.
    ENDIF.
  ENDIF.

* Rechts
  CLEAR: lt_zeile_form, lv_zeichen_form, lv_zahl_form.
  lv_new_x = x + 1.
  lv_new_y = y.
  READ TABLE lt_zeile_tab INDEX lv_new_y INTO lt_zeile_form.
  IF sy-subrc = 0.
    READ TABLE lt_zeile_form INDEX lv_new_x INTO lv_zeichen_form.
    IF sy-subrc = 0.
      lv_zahl_form = lv_zeichen_form.
      IF lv_zahl_form = 9 AND lv_zahl_form = number + 1.

        ls_trailhead-x = lv_new_x.
        ls_trailhead-y = lv_new_y.
        READ TABLE lt_trailheads WITH KEY x = lv_new_x y = lv_new_y TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          APPEND ls_trailhead TO lt_trailheads.
          lv_result = lv_result + 1.
        ENDIF.

      ELSEIF lv_zahl_form = number + 1.

        PERFORM check_next_number1
          USING lv_zahl_form lv_new_x lv_new_y.

      ENDIF.
    ENDIF.
  ENDIF.

* Oben
  CLEAR: lt_zeile_form, lv_zeichen_form, lv_zahl_form.
  lv_new_x = x.
  lv_new_y = y - 1.
  READ TABLE lt_zeile_tab INDEX lv_new_y INTO lt_zeile_form.
  IF sy-subrc = 0.
    READ TABLE lt_zeile_form INDEX lv_new_x INTO lv_zeichen_form.
    IF sy-subrc = 0.
      lv_zahl_form = lv_zeichen_form.
      IF lv_zahl_form = 9 AND lv_zahl_form = number + 1.

        ls_trailhead-x = lv_new_x.
        ls_trailhead-y = lv_new_y.
        READ TABLE lt_trailheads WITH KEY x = lv_new_x y = lv_new_y TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          APPEND ls_trailhead TO lt_trailheads.
          lv_result = lv_result + 1.
        ENDIF.

      ELSEIF lv_zahl_form = number + 1.

        PERFORM check_next_number1
          USING lv_zahl_form lv_new_x lv_new_y.

      ENDIF.
    ENDIF.
  ENDIF.

* Unten
  CLEAR: lt_zeile_form, lv_zeichen_form, lv_zahl_form.
  lv_new_x = x.
  lv_new_y = y + 1.
  READ TABLE lt_zeile_tab INDEX lv_new_y INTO lt_zeile_form.
  IF sy-subrc = 0.
    READ TABLE lt_zeile_form INDEX lv_new_x INTO lv_zeichen_form.
    IF sy-subrc = 0.
      lv_zahl_form = lv_zeichen_form.
      IF lv_zahl_form = 9 AND lv_zahl_form = number + 1.

        ls_trailhead-x = lv_new_x.
        ls_trailhead-y = lv_new_y.
        READ TABLE lt_trailheads WITH KEY x = lv_new_x y = lv_new_y TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0.
          APPEND ls_trailhead TO lt_trailheads.
          lv_result = lv_result + 1.
        ENDIF.

      ELSEIF lv_zahl_form = number + 1.

        PERFORM check_next_number1
          USING lv_zahl_form lv_new_x lv_new_y.

      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*****************************************************************************
* Form Part 2
*****************************************************************************
FORM check_next_number2 USING number TYPE i
                             x TYPE i
                             y TYPE i.

  DATA: lv_zahl_form    TYPE i,
        lv_zeichen_form TYPE c LENGTH 1,
        lt_zeile_form   LIKE TABLE OF lv_zeichen_form,
        lv_new_x        TYPE i,
        lv_new_y        TYPE i.

* Links
  CLEAR: lt_zeile_form, lv_zeichen_form, lv_zahl_form.
  lv_new_x = x - 1.
  lv_new_y = y.
  READ TABLE lt_zeile_tab INDEX lv_new_y INTO lt_zeile_form.
  IF sy-subrc = 0.
    READ TABLE lt_zeile_form INDEX lv_new_x INTO lv_zeichen_form.
    IF sy-subrc = 0.
      lv_zahl_form = lv_zeichen_form.
      IF lv_zahl_form = 9 AND lv_zahl_form = number + 1.

        lv_result = lv_result + 1.

      ELSEIF lv_zahl_form = number + 1.

        PERFORM check_next_number2
          USING lv_zahl_form lv_new_x lv_new_y.

      ENDIF.
    ENDIF.
  ENDIF.

* Rechts
  CLEAR: lt_zeile_form, lv_zeichen_form, lv_zahl_form.
  lv_new_x = x + 1.
  lv_new_y = y.
  READ TABLE lt_zeile_tab INDEX lv_new_y INTO lt_zeile_form.
  IF sy-subrc = 0.
    READ TABLE lt_zeile_form INDEX lv_new_x INTO lv_zeichen_form.
    IF sy-subrc = 0.
      lv_zahl_form = lv_zeichen_form.
      IF lv_zahl_form = 9 AND lv_zahl_form = number + 1.

        lv_result = lv_result + 1.

      ELSEIF lv_zahl_form = number + 1.

        PERFORM check_next_number2
          USING lv_zahl_form lv_new_x lv_new_y.

      ENDIF.
    ENDIF.
  ENDIF.

* Oben
  CLEAR: lt_zeile_form, lv_zeichen_form, lv_zahl_form.
  lv_new_x = x.
  lv_new_y = y - 1.
  READ TABLE lt_zeile_tab INDEX lv_new_y INTO lt_zeile_form.
  IF sy-subrc = 0.
    READ TABLE lt_zeile_form INDEX lv_new_x INTO lv_zeichen_form.
    IF sy-subrc = 0.
      lv_zahl_form = lv_zeichen_form.
      IF lv_zahl_form = 9 AND lv_zahl_form = number + 1.

        lv_result = lv_result + 1.

      ELSEIF lv_zahl_form = number + 1.

        PERFORM check_next_number2
          USING lv_zahl_form lv_new_x lv_new_y.

      ENDIF.
    ENDIF.
  ENDIF.

* Unten
  CLEAR: lt_zeile_form, lv_zeichen_form, lv_zahl_form.
  lv_new_x = x.
  lv_new_y = y + 1.
  READ TABLE lt_zeile_tab INDEX lv_new_y INTO lt_zeile_form.
  IF sy-subrc = 0.
    READ TABLE lt_zeile_form INDEX lv_new_x INTO lv_zeichen_form.
    IF sy-subrc = 0.
      lv_zahl_form = lv_zeichen_form.
      IF lv_zahl_form = 9 AND lv_zahl_form = number + 1.

        lv_result = lv_result + 1.

      ELSEIF lv_zahl_form = number + 1.

        PERFORM check_next_number2
          USING lv_zahl_form lv_new_x lv_new_y.

      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
