*&---------------------------------------------------------------------*
*& Report Z_AOC24_TAG_4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_aoc24_tag_4.

DATA: lv_filename TYPE string,
      lt_data     TYPE TABLE OF string,
      lv_data     TYPE string.

DATA: lt_regex       TYPE match_result_tab,
      lv_result      TYPE i,
      lv_length      TYPE i,
      lv_counter     TYPE i,
      lv_zeichen     TYPE c LENGTH 1,
      lt_zeile       LIKE TABLE OF lv_zeichen,
      lt_zeile_tab   LIKE TABLE OF lt_zeile,
      lv_such_string TYPE string,
      lv_x           TYPE i,
      lv_y           TYPE i,
      lv_x_start     TYPE i,
      lv_y_start     TYPE i.

DATA: lt_zeile_temp   LIKE TABLE OF lv_zeichen,
      lv_links_oben   TYPE c LENGTH 1,
      lv_links_unten  TYPE c LENGTH 1,
      lv_rechts_oben  TYPE c LENGTH 1,
      lv_rechts_unten TYPE c LENGTH 1.

lv_filename = 'I:\Advent_of_Code\Tag_4.txt'.

CALL METHOD cl_gui_frontend_services=>gui_upload
  EXPORTING
    filename                = lv_filename
    codepage                = '1100'
  CHANGING
    data_tab                = lt_data
  EXCEPTIONS
    OTHERS                  = 1.

IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
           WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.

*****************************************************************************
* Part 1
*****************************************************************************

* Horizontal

LOOP AT lt_data INTO lv_data.

  FIND ALL OCCURRENCES OF PCRE 'XMAS' IN lv_data RESULTS lt_regex.
  lv_result = lv_result + lines( lt_regex ).

  FIND ALL OCCURRENCES OF PCRE 'SAMX' IN lv_data RESULTS lt_regex.
  lv_result = lv_result + lines( lt_regex ).

ENDLOOP.

* Vertikal

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

CLEAR lv_counter.

DO.

  CLEAR lv_such_string.
  lv_counter = lv_counter + 1.

  LOOP AT lt_zeile_tab INTO lt_zeile.

    CLEAR lv_zeichen.
    READ TABLE lt_zeile INDEX lv_counter INTO lv_zeichen.
    lv_such_string = |{ lv_such_string }{ lv_zeichen }|.

  ENDLOOP.

  FIND ALL OCCURRENCES OF PCRE 'XMAS' IN lv_such_string RESULTS lt_regex.
  lv_result = lv_result + lines( lt_regex ).

  FIND ALL OCCURRENCES OF PCRE 'SAMX' IN lv_such_string RESULTS lt_regex.
  lv_result = lv_result + lines( lt_regex ).

  IF lv_such_string IS INITIAL.
    EXIT.
  ENDIF.

ENDDO.

* Diagonal /

lv_x_start = 1.
lv_y_start = 1.

lv_length = lines( lt_zeile_tab ) + lines( lt_zeile ) - 1.

DO lv_length TIMES.

  lv_x = lv_x_start.
  lv_y = lv_y_start.
  CLEAR lv_such_string.

  DO.

    CLEAR: lt_zeile, lv_zeichen.

    READ TABLE lt_zeile_tab INDEX lv_x INTO lt_zeile.
    READ TABLE lt_zeile INDEX lv_y INTO lv_zeichen.
    lv_such_string = |{ lv_such_string }{ lv_zeichen }|.

    lv_x = lv_x + 1.
    lv_y = lv_y - 1.

    IF lv_y = 0.
      EXIT.
    ENDIF.

  ENDDO.

  FIND ALL OCCURRENCES OF PCRE 'XMAS' IN lv_such_string RESULTS lt_regex.
  lv_result = lv_result + lines( lt_regex ).

  FIND ALL OCCURRENCES OF PCRE 'SAMX' IN lv_such_string RESULTS lt_regex.
  lv_result = lv_result + lines( lt_regex ).

  lv_y_start = lv_y_start + 1.

ENDDO.

* Diagonal \

lv_x_start = lines( lt_zeile_tab ).
lv_y_start = 1.

DO lv_length TIMES.

  lv_x = lv_x_start.
  lv_y = lv_y_start.
  CLEAR lv_such_string.

  DO.

    CLEAR: lt_zeile, lv_zeichen.

    READ TABLE lt_zeile_tab INDEX lv_x INTO lt_zeile.
    READ TABLE lt_zeile INDEX lv_y INTO lv_zeichen.
    lv_such_string = |{ lv_such_string }{ lv_zeichen }|.

    lv_x = lv_x - 1.
    lv_y = lv_y - 1.

    IF lv_y = 0.
      EXIT.
    ENDIF.

  ENDDO.

  FIND ALL OCCURRENCES OF PCRE 'XMAS' IN lv_such_string RESULTS lt_regex.
  lv_result = lv_result + lines( lt_regex ).

  FIND ALL OCCURRENCES OF PCRE 'SAMX' IN lv_such_string RESULTS lt_regex.
  lv_result = lv_result + lines( lt_regex ).

  lv_y_start = lv_y_start + 1.

ENDDO.

WRITE: / lv_result.

*****************************************************************************
* Part 2
*****************************************************************************

CLEAR lv_result.

LOOP AT lt_zeile_tab INTO lt_zeile.

  lv_x = sy-tabix.

  LOOP AT lt_zeile INTO lv_zeichen.

    lv_y = sy-tabix.

    IF lv_zeichen = 'A'. " jedes X-MAS muss ein A in der Mitte haben, nur bei A muss geprüft werden, ob es passen könnte

      CLEAR: lv_links_oben, lv_links_unten, lv_rechts_oben, lv_rechts_unten.

      CLEAR lt_zeile_temp.
      READ TABLE lt_zeile_tab INDEX lv_x - 1 INTO lt_zeile_temp.
      READ TABLE lt_zeile_temp INDEX lv_y - 1 INTO lv_links_oben.
      CLEAR lt_zeile_temp.
      READ TABLE lt_zeile_tab INDEX lv_x - 1 INTO lt_zeile_temp.
      READ TABLE lt_zeile_temp INDEX lv_y + 1 INTO lv_links_unten.
      CLEAR lt_zeile_temp.
      READ TABLE lt_zeile_tab INDEX lv_x + 1 INTO lt_zeile_temp.
      READ TABLE lt_zeile_temp INDEX lv_y - 1 INTO lv_rechts_oben.
      CLEAR lt_zeile_temp.
      READ TABLE lt_zeile_tab INDEX lv_x + 1 INTO lt_zeile_temp.
      READ TABLE lt_zeile_temp INDEX lv_y + 1 INTO lv_rechts_unten.

      IF ( lv_links_oben = 'M' AND lv_rechts_unten = 'S' AND lv_rechts_oben = 'M' AND lv_links_unten = 'S' )
      OR ( lv_links_oben = 'M' AND lv_rechts_unten = 'S' AND lv_rechts_oben = 'S' AND lv_links_unten = 'M' )
      OR ( lv_links_oben = 'S' AND lv_rechts_unten = 'M' AND lv_rechts_oben = 'M' AND lv_links_unten = 'S' )
      OR ( lv_links_oben = 'S' AND lv_rechts_unten = 'M' AND lv_rechts_oben = 'S' AND lv_links_unten = 'M' ).

        lv_result = lv_result + 1.

      ENDIF.
    ENDIF.
  ENDLOOP.
ENDLOOP.

WRITE: / lv_result.
