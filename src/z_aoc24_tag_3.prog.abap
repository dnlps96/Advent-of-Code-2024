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
*   FILETYPE                = 'ASC'
*   HAS_FIELD_SEPARATOR     = SPACE
*   HEADER_LENGTH           = 0
*   READ_BY_LINE            = 'X'
*   DAT_MODE                = SPACE
    codepage                = '1100'   "SAP(ISO)-Codepage 1100 Bezug auf ISO-Codepage 8859-1 (umfasst meiste westeuropäischen Zeichen)
*   IGNORE_CERR             = ABAP_TRUE
*   REPLACEMENT             = '#'
*   VIRUS_SCAN_PROFILE      =
*  IMPORTING
*   FILELENGTH              =
*   HEADER                  =
  CHANGING
    data_tab                = lt_data
  EXCEPTIONS
    file_open_error         = 1
    file_read_error         = 2
    no_batch                = 3
    gui_refuse_filetransfer = 4
    invalid_type            = 5
    no_authority            = 6
    unknown_error           = 7
    bad_data_format         = 8
    header_not_allowed      = 9
    separator_not_allowed   = 10
    header_too_long         = 11
    unknown_dp_error        = 12
    access_denied           = 13
    dp_out_of_memory        = 14
    disk_full               = 15
    dp_timeout              = 16
    not_supported_by_gui    = 17
    error_no_gui            = 18
    OTHERS                  = 19.

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
