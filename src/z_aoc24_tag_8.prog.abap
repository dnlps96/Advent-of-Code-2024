*&---------------------------------------------------------------------*
*& Report Z_AOC24_TAG_8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_aoc24_tag_8.

TYPES: BEGIN OF ty_antennas,
         x       TYPE i,
         y       TYPE i,
         zeichen TYPE c LENGTH 1,
       END OF ty_antennas.

DATA: lv_filename TYPE string,
      lt_data     TYPE TABLE OF string,
      lv_data     TYPE string.

DATA: lv_length       TYPE i,
      lv_counter      TYPE i,
      lv_zeichen      TYPE c LENGTH 1,
      lt_zeile        LIKE TABLE OF lv_zeichen,
      lt_zeile_tab    LIKE TABLE OF lt_zeile,
      lv_x            TYPE i,
      lv_y            TYPE i,
      ls_antennas     TYPE ty_antennas,
      ls_antennas_vgl TYPE ty_antennas,
      lt_antennas     TYPE TABLE OF ty_antennas.

FIELD-SYMBOLS: <fs_zeile>   LIKE lt_zeile,
               <fs_zeichen> LIKE lv_zeichen.

lv_filename = 'I:\Advent_of_Code\Tag_8.txt'.

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

  lv_y = sy-tabix.

  DO lv_length TIMES.
    lv_zeichen = lv_data+lv_counter(1).
    lv_counter = lv_counter + 1.

    lv_x = sy-index.

    APPEND lv_zeichen TO lt_zeile.

    IF lv_zeichen <> '.'.

      ls_antennas-x = lv_x.
      ls_antennas-y = lv_y.
      ls_antennas-zeichen = lv_zeichen.

      APPEND ls_antennas TO lt_antennas.

    ENDIF.

  ENDDO.

  APPEND lt_zeile TO lt_zeile_tab. " Tabelle zusammenbauen, in der alle Zeichen einzeln sind

ENDLOOP.

CLEAR lv_counter.

LOOP AT lt_antennas INTO ls_antennas.

  LOOP AT lt_antennas INTO ls_antennas_vgl WHERE zeichen = ls_antennas-zeichen.

    IF ls_antennas-x <> ls_antennas_vgl-x OR ls_antennas-y <> ls_antennas_vgl-y.

      lv_x = ls_antennas-x + ls_antennas-x - ls_antennas_vgl-x.
      lv_y = ls_antennas-y + ls_antennas-y - ls_antennas_vgl-y.

      READ TABLE lt_zeile_tab INDEX lv_y ASSIGNING <fs_zeile>.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.
      READ TABLE <fs_zeile> INDEX lv_x ASSIGNING <fs_zeichen>.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF <fs_zeichen> <> '#'.
        <fs_zeichen> = '#'.
        lv_counter = lv_counter + 1.
      ENDIF.

    ENDIF.
  ENDLOOP.
ENDLOOP.

WRITE: / lv_counter.

*****************************************************************************
* Part 2
*****************************************************************************

LOOP AT lt_antennas INTO ls_antennas.

  READ TABLE lt_zeile_tab INDEX ls_antennas-y ASSIGNING <fs_zeile>.
  READ TABLE <fs_zeile> INDEX ls_antennas-x ASSIGNING <fs_zeichen>.

  IF <fs_zeichen> <> '#'.
    <fs_zeichen> = '#'.
    lv_counter = lv_counter + 1.
  ENDIF.

  LOOP AT lt_antennas INTO ls_antennas_vgl WHERE zeichen = ls_antennas-zeichen.

    IF ls_antennas-x <> ls_antennas_vgl-x OR ls_antennas-y <> ls_antennas_vgl-y.

      lv_x = ls_antennas-x.
      lv_y = ls_antennas-y.

      DO.

        lv_x = lv_x + ls_antennas-x - ls_antennas_vgl-x.
        lv_y = lv_y + ls_antennas-y - ls_antennas_vgl-y.

        READ TABLE lt_zeile_tab INDEX lv_y ASSIGNING <fs_zeile>.
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.
        READ TABLE <fs_zeile> INDEX lv_x ASSIGNING <fs_zeichen>.
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.

        IF <fs_zeichen> <> '#'.
          <fs_zeichen> = '#'.
          lv_counter = lv_counter + 1.
        ENDIF.

      ENDDO.

    ENDIF.
  ENDLOOP.
ENDLOOP.

WRITE: / lv_counter.
