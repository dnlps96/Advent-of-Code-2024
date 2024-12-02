*&---------------------------------------------------------------------*
*& Report Z_AOC24_TAG_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_aoc24_tag_2.

DATA: lv_filename TYPE string,
      lt_data     TYPE TABLE OF string,
      lv_data     TYPE string.

DATA: lv_zahl_string TYPE string,
      lv_rest        TYPE string,
      lv_zahl        TYPE i,
      lv_zahl_merk   TYPE i,
      lv_flg_up      TYPE c LENGTH 1,
      lv_flg_down    TYPE c LENGTH 1,
      lv_count_save  TYPE i,
      lv_flg_unsafe  TYPE c LENGTH 1,
      lv_diff        TYPE i.

DATA: lt_record      TYPE TABLE OF string,
      lt_record_work TYPE TABLE OF string,
      lv_record      TYPE string,
      lv_anzahl      TYPE i.

lv_filename = 'I:\Advent_of_Code\Tag_2.txt'.

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

  lv_rest = lv_data.
  CLEAR: lv_zahl_merk, lv_flg_up, lv_flg_down, lv_flg_unsafe.

  WHILE lv_rest IS NOT INITIAL.

    SPLIT lv_rest AT ' ' INTO lv_zahl_string lv_rest.
    lv_zahl = lv_zahl_string.

    IF sy-index = 2. "erst ab dem zweiten Durchlauf sind beide Zahlen zum Vergleich gefüllt

      IF lv_zahl > lv_zahl_merk.
        lv_flg_up = 'X'.
        lv_diff = lv_zahl - lv_zahl_merk.
      ELSEIF lv_zahl < lv_zahl_merk.
        lv_flg_down = 'X'.
        lv_diff = lv_zahl_merk - lv_zahl.
      ELSE.
        lv_flg_unsafe = 'X'.
        EXIT. "gleiche Zahlen nacheinander sind nicht erlaubt
      ENDIF.

      IF lv_diff > 3.
        lv_flg_unsafe = 'X'.
        EXIT.
      ENDIF.

    ELSEIF sy-index > 2. "erst im dritten muss geprüft werden, ob die Veränderung in die gleiche Richtung ist, wie beim zweiten Durchlauf

      IF lv_flg_down = 'X'.
        lv_diff = lv_zahl_merk - lv_zahl.
      ENDIF.
      IF lv_flg_up = 'X'.
        lv_diff = lv_zahl - lv_zahl_merk.
      ENDIF.

      IF lv_diff > 3 OR lv_diff <= 0. "kleiner Null bedeutet es hat sich die Richtung verändert
        lv_flg_unsafe = 'X'.
        EXIT.
      ENDIF.

    ENDIF.

    lv_zahl_merk = lv_zahl.

  ENDWHILE.

  IF lv_flg_unsafe <> 'X'.
    lv_count_save = lv_count_save + 1.
  ENDIF.

ENDLOOP.

WRITE: / lv_count_save.

*****************************************************************************
* Part 2
*****************************************************************************

CLEAR: lv_count_save.

LOOP AT lt_data INTO lv_data.

  clear lv_flg_unsafe.

  SPLIT lv_data AT ' ' INTO TABLE lt_record.

  lv_anzahl = lines( lt_record ).

  DO lv_anzahl + 1 TIMES.

    lt_record_work = lt_record.
    DELETE lt_record_work INDEX sy-index. "es wird immer ein Wert gelöscht, beim letzten Durchlauf wird mit der vollständigen Tabelle gearbeitet

    CLEAR: lv_zahl_merk, lv_flg_up, lv_flg_down, lv_flg_unsafe.

    LOOP AT lt_record_work INTO lv_record.

      lv_zahl = lv_record.

      IF sy-tabix = 2. "erst ab dem zweiten Durchlauf sind beide Zahlen zum Vergleich gefüllt

        IF lv_zahl > lv_zahl_merk.
          lv_flg_up = 'X'.
          lv_diff = lv_zahl - lv_zahl_merk.
        ELSEIF lv_zahl < lv_zahl_merk.
          lv_flg_down = 'X'.
          lv_diff = lv_zahl_merk - lv_zahl.
        ELSE.
          lv_flg_unsafe = 'X'.
          EXIT. "gleiche Zahlen nacheinander sind nicht erlaubt
        ENDIF.

        IF lv_diff > 3.
          lv_flg_unsafe = 'X'.
          EXIT.
        ENDIF.

      ELSEIF sy-tabix > 2. "erst im dritten muss geprüft werden, ob die Veränderung in die gleiche Richtung ist, wie beim zweiten Durchlauf

        IF lv_flg_down = 'X'.
          lv_diff = lv_zahl_merk - lv_zahl.
        ENDIF.
        IF lv_flg_up = 'X'.
          lv_diff = lv_zahl - lv_zahl_merk.
        ENDIF.

        IF lv_diff > 3 OR lv_diff <= 0. "kleiner Null bedeutet es hat sich die Richtung verändert
          lv_flg_unsafe = 'X'.
          EXIT.
        ENDIF.

      ENDIF.

      lv_zahl_merk = lv_zahl.

    ENDLOOP.

    IF lv_flg_unsafe <> 'X'.
      lv_count_save = lv_count_save + 1.
      EXIT.
    ENDIF.

  ENDDO.

ENDLOOP.

WRITE: / lv_count_save.
