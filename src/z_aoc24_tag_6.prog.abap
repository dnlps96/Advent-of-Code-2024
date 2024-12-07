*&---------------------------------------------------------------------*
*& Report Z_AOC24_TAG_6
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_aoc24_tag_6.

DATA: lv_filename TYPE string,
      lt_data     TYPE TABLE OF string,
      lv_data     TYPE string.

DATA: lv_length         TYPE i,
      lv_counter        TYPE i,
      lv_zeichen        TYPE c LENGTH 1,
      lt_zeile          LIKE TABLE OF lv_zeichen,
      lt_zeile_tab      LIKE TABLE OF lt_zeile,
      lv_x              TYPE i,
      lv_y              TYPE i,
      lv_direction      TYPE c LENGTH 1,
      lt_zeile_tab_merk LIKE TABLE OF lt_zeile,
      lv_x_merk         TYPE i,
      lv_y_merk         TYPE i,
      lv_direction_merk TYPE c LENGTH 1,
      lv_x_test         TYPE i,
      lv_y_test         TYPE i,
      lt_hit_direction  LIKE TABLE OF lv_direction.

FIELD-SYMBOLS: <fs_zeile>   LIKE lt_zeile,
               <fs_zeichen> LIKE lv_zeichen.

lv_filename = 'I:\Advent_of_Code\Tag_6.txt'.

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
    lv_counter = lv_counter + 1.

    IF lv_zeichen = '>' OR lv_zeichen = '<' OR lv_zeichen = 'v' OR lv_zeichen = '^'.
      lv_x = lv_counter.
      lv_y = lines( lt_zeile_tab ) + 1.
      lv_direction = lv_zeichen.
      lv_zeichen = 'X'.
    ENDIF.

    APPEND lv_zeichen TO lt_zeile.

  ENDDO.

  APPEND lt_zeile TO lt_zeile_tab. " Tabelle zusammenbauen, in der alle Zeichen einzeln sind

ENDLOOP.

* Ausgangszustand für Teil 2 merken
lv_x_merk = lv_x.
lv_y_merk = lv_y.
lv_direction_merk = lv_direction.
lt_zeile_tab_merk = lt_zeile_tab.

lv_counter = 1. " für die Startposition

DO.

  IF lv_direction = '>'.
    lv_x = lv_x + 1.
  ELSEIF lv_direction = '<'.
    lv_x = lv_x - 1.
  ELSEIF lv_direction = 'v'.
    lv_y = lv_y + 1.
  ELSEIF lv_direction = '^'.
    lv_y = lv_y - 1.
  ENDIF.

  READ TABLE lt_zeile_tab INDEX lv_y ASSIGNING <fs_zeile>.
  IF sy-subrc <> 0.
    EXIT.
  ENDIF.
  READ TABLE <fs_zeile> INDEX lv_x ASSIGNING <fs_zeichen>.
  IF sy-subrc <> 0.
    EXIT.
  ENDIF.

  IF <fs_zeichen> = '.'.
    <fs_zeichen> = 'X'.
    lv_counter = lv_counter + 1.
  ENDIF.

  IF <fs_zeichen> = '#'.
    IF lv_direction = '>'.
      lv_x = lv_x - 1.
      lv_direction = 'v'.
    ELSEIF lv_direction = '<'.
      lv_x = lv_x + 1.
      lv_direction = '^'.
    ELSEIF lv_direction = 'v'.
      lv_y = lv_y - 1.
      lv_direction = '<'.
    ELSEIF lv_direction = '^'.
      lv_y = lv_y + 1.
      lv_direction = '>'.
    ENDIF.
  ENDIF.

ENDDO.

WRITE: / lv_counter.

*****************************************************************************
* Part 2
*****************************************************************************

CLEAR lv_counter.

DO lines( lt_zeile_tab_merk ) TIMES.
  lv_y_test = sy-index.
  DO lines( <fs_zeile> ) TIMES.
    lv_x_test = sy-index.

* Ausgangszustand benutzen
    lv_x = lv_x_merk.
    lv_y = lv_y_merk.
    lv_direction = lv_direction_merk.
    lt_zeile_tab = lt_zeile_tab_merk.

    CLEAR lt_hit_direction.

    READ TABLE lt_zeile_tab INDEX lv_y_test ASSIGNING <fs_zeile>.
    READ TABLE <fs_zeile> INDEX lv_x_test ASSIGNING <fs_zeichen>.
    IF <fs_zeichen> = '.'.
      <fs_zeichen> = 'O'. "zusätzliches Objekt
    ELSE.
      CONTINUE.
    ENDIF.

* Test durchführen
    DO.

      IF sy-index = 1000000. "nicht die beste Lösung, einen Endlosloop zu erkennen, wird aber funktionieren
        lv_counter = lv_counter + 1.
        EXIT.
      ENDIF.

      IF lv_direction = '>'.
        lv_x = lv_x + 1.
      ELSEIF lv_direction = '<'.
        lv_x = lv_x - 1.
      ELSEIF lv_direction = 'v'.
        lv_y = lv_y + 1.
      ELSEIF lv_direction = '^'.
        lv_y = lv_y - 1.
      ENDIF.

      READ TABLE lt_zeile_tab INDEX lv_y ASSIGNING <fs_zeile>.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
      READ TABLE <fs_zeile> INDEX lv_x ASSIGNING <fs_zeichen>.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.

      IF <fs_zeichen> = 'O'.
        READ TABLE lt_hit_direction WITH KEY lv_direction TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          lv_counter = lv_counter + 1.
          EXIT.
        ELSE.
          APPEND lv_direction TO lt_hit_direction.
        ENDIF.
      ENDIF.

      IF <fs_zeichen> = '#' OR <fs_zeichen> = 'O'.
        IF lv_direction = '>'.
          lv_x = lv_x - 1.
          lv_direction = 'v'.
        ELSEIF lv_direction = '<'.
          lv_x = lv_x + 1.
          lv_direction = '^'.
        ELSEIF lv_direction = 'v'.
          lv_y = lv_y - 1.
          lv_direction = '<'.
        ELSEIF lv_direction = '^'.
          lv_y = lv_y + 1.
          lv_direction = '>'.
        ENDIF.
      ENDIF.

    ENDDO.
  ENDDO.
ENDDO.

WRITE: / lv_counter.
