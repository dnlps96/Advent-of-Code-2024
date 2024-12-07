*&---------------------------------------------------------------------*
*& Report Z_AOC24_TAG_3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_aoc24_tag_3.

DATA: lv_filename TYPE string,
      lt_data     TYPE TABLE OF string,
      lv_data     TYPE string.

DATA: lt_regex     TYPE match_result_tab,
      ls_regex     TYPE match_result,
      lv_record    TYPE string,
      lt_zahlen    TYPE match_result_tab,
      ls_zahlen    TYPE match_result,
      lv_zahl1     TYPE i,
      lv_zahl2     TYPE i,
      lv_ergebnis  TYPE i,
      lt_regex_all TYPE match_result_tab,
      lv_do        TYPE c LENGTH 1 VALUE 'X'.

lv_filename = 'I:\Advent_of_Code\Tag_3.txt'.

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

LOOP AT lt_data INTO lv_data.

  FIND ALL OCCURRENCES OF PCRE 'mul\([0-9]{1,3},[0-9]{1,3}\)' IN lv_data RESULTS lt_regex.

  LOOP AT lt_regex INTO ls_regex.

    lv_record = lv_data+ls_regex-offset(ls_regex-length).

    FIND ALL OCCURRENCES OF PCRE '[0-9]{1,3}' IN lv_record RESULTS lt_zahlen.

    READ TABLE lt_zahlen INDEX 1 INTO ls_zahlen.
    lv_zahl1 = lv_record+ls_zahlen-offset(ls_zahlen-length).
    READ TABLE lt_zahlen INDEX 2 INTO ls_zahlen.
    lv_zahl2 = lv_record+ls_zahlen-offset(ls_zahlen-length).

    lv_ergebnis = lv_ergebnis + lv_zahl1 * lv_zahl2.

  ENDLOOP.

ENDLOOP.

WRITE: / lv_ergebnis.

*****************************************************************************
* Part 2
*****************************************************************************

CLEAR lv_ergebnis.

LOOP AT lt_data INTO lv_data.

  CLEAR lt_regex_all.

  FIND ALL OCCURRENCES OF PCRE 'mul\([0-9]{1,3},[0-9]{1,3}\)' IN lv_data RESULTS lt_regex.
  APPEND LINES OF lt_regex TO lt_regex_all.
  FIND ALL OCCURRENCES OF PCRE 'do\(\)' IN lv_data RESULTS lt_regex.
  APPEND LINES OF lt_regex TO lt_regex_all.
  FIND ALL OCCURRENCES OF PCRE 'don''t\(\)' IN lv_data RESULTS lt_regex.
  APPEND LINES OF lt_regex TO lt_regex_all.

  SORT lt_regex_all BY offset.

  LOOP AT lt_regex_all INTO ls_regex.

    lv_record = lv_data+ls_regex-offset(ls_regex-length).

    IF lv_record = 'do()'.
      lv_do = 'X'.
    ELSEIF lv_record = 'don''t()'.
      CLEAR lv_do.
    ELSE.

      IF lv_do = 'X'.

        FIND ALL OCCURRENCES OF PCRE '[0-9]{1,3}' IN lv_record RESULTS lt_zahlen.

        READ TABLE lt_zahlen INDEX 1 INTO ls_zahlen.
        lv_zahl1 = lv_record+ls_zahlen-offset(ls_zahlen-length).
        READ TABLE lt_zahlen INDEX 2 INTO ls_zahlen.
        lv_zahl2 = lv_record+ls_zahlen-offset(ls_zahlen-length).

        lv_ergebnis = lv_ergebnis + lv_zahl1 * lv_zahl2.

      ENDIF.
    ENDIF.
  ENDLOOP.
ENDLOOP.

WRITE: / lv_ergebnis.
