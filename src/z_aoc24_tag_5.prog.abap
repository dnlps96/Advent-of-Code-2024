*&---------------------------------------------------------------------*
*& Report Z_AOC24_TAG_5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_aoc24_tag_5.

TYPES: BEGIN OF ty_rules,
         before TYPE i,
         after  TYPE i,
       END OF ty_rules.

DATA: lv_filename TYPE string,
      lt_data     TYPE TABLE OF string,
      lv_data     TYPE string.

DATA: lv_data_1           TYPE string,
      lv_data_2           TYPE string,
      ls_rules            TYPE ty_rules,
      lt_rules            TYPE TABLE OF ty_rules,
      lv_page_string_1    TYPE string,
      lv_page_string_2    TYPE string,
      lv_page             TYPE i,
      lv_page_ordered     TYPE i,
      lv_page_after       TYPE i,
      lt_pages            LIKE TABLE OF lv_page_string_1,
      lt_pages_ordered    LIKE TABLE OF lv_page,
      lt_orders           LIKE TABLE OF lt_pages,
      lt_incorrect_orders LIKE TABLE OF lt_pages,
      lv_result           TYPE i,
      lv_error            TYPE c LENGTH 1,
      lv_mitte            TYPE i,
      lv_index            TYPE i,
      lv_eingefuegt       TYPE c LENGTH 1.

lv_filename = 'I:\Advent_of_Code\Tag_5.txt'.

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

* Vorbereitung
LOOP AT lt_data INTO lv_data.

  IF lv_data CS '|'.

    SPLIT lv_data AT '|' INTO lv_data_1 lv_data_2.

    ls_rules-before = lv_data_1.
    ls_rules-after = lv_data_2.
    APPEND ls_rules TO lt_rules.

  ELSEIF lv_data IS NOT INITIAL.

    SPLIT lv_data AT ',' INTO TABLE lt_pages.

    APPEND lt_pages TO lt_orders.

  ENDIF.

ENDLOOP.

* Check
LOOP AT lt_orders INTO lt_pages.

  CLEAR lv_error.

  LOOP AT lt_pages INTO lv_page_string_1.

    lv_page = lv_page_string_1.

    LOOP AT lt_pages INTO lv_page_string_2 FROM sy-tabix + 1.

      lv_page_after = lv_page_string_2.

      READ TABLE lt_rules WITH KEY before = lv_page_after after = lv_page TRANSPORTING NO FIELDS.

      IF sy-subrc = 0.
        lv_error = 'X'.
      ENDIF.

    ENDLOOP.
  ENDLOOP.

  IF lv_error <> 'X'.

    lv_mitte = ( lines( lt_pages ) + 1 ) / 2.

    CLEAR lv_page_string_1.
    READ TABLE lt_pages INDEX lv_mitte INTO lv_page_string_1.
    lv_page = lv_page_string_1.
    lv_result = lv_result + lv_page.
  ELSE.
    APPEND lt_pages TO lt_incorrect_orders.
  ENDIF.

ENDLOOP.

WRITE: / lv_result.

*****************************************************************************
* Part 2
*****************************************************************************

CLEAR lv_result.

LOOP AT lt_incorrect_orders INTO lt_pages.

  CLEAR lt_pages_ordered.

  LOOP AT lt_pages INTO lv_page_string_1.

    lv_page = lv_page_string_1.

    IF sy-tabix = 1. "ersten Wert einfach einfügen
      APPEND lv_page TO lt_pages_ordered.
    ELSE. "ab dem zweiten Wert muss die korrekte Position gesucht werden

      CLEAR lv_eingefuegt.

      LOOP AT lt_pages_ordered INTO lv_page_ordered.

        lv_index = sy-tabix.

        READ TABLE lt_rules WITH KEY before = lv_page after = lv_page_ordered TRANSPORTING NO FIELDS.

        IF sy-subrc = 0.
          INSERT lv_page INTO lt_pages_ordered INDEX lv_index.
          lv_eingefuegt = 'X'.
          EXIT.
        ENDIF.

      ENDLOOP.

      IF lv_eingefuegt <> 'X'. "neue Zahl wurde noch nicht eingefügt
        APPEND lv_page TO lt_pages_ordered.
      ENDIF.

    ENDIF.
  ENDLOOP.

  lv_mitte = ( lines( lt_pages_ordered ) + 1 ) / 2.

  CLEAR lv_page.
  READ TABLE lt_pages_ordered INDEX lv_mitte INTO lv_page.
  lv_result = lv_result + lv_page.

ENDLOOP.

WRITE: / lv_result.
