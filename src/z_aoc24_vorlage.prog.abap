*&---------------------------------------------------------------------*
*& Report Z_AOC24_VORLAGE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_aoc24_vorlage.

DATA: lv_filename TYPE string,
      lt_data     TYPE TABLE OF string,
      lv_data     TYPE string.

lv_filename = 'I:\Advent_of_Code\Tag_1.txt'.

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

LOOP AT lt_data INTO lv_data.



ENDLOOP.
