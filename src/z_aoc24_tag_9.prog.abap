*&---------------------------------------------------------------------*
*& Report Z_AOC24_TAG_9
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_aoc24_tag_9.

TYPES: BEGIN OF ty_disk,
         index    TYPE i,
         id       TYPE i,
         flg_leer TYPE c LENGTH 1,
       END OF ty_disk.

DATA: lv_filename TYPE string,
      lt_data     TYPE TABLE OF string,
      lv_data     TYPE string.

DATA: lt_disk_start TYPE TABLE OF ty_disk,
      ls_disk_start TYPE ty_disk,
      lt_disk_end   TYPE TABLE OF ty_disk,
      ls_disk_end   TYPE ty_disk,
      lv_length     TYPE i,
      lv_zahl       TYPE c LENGTH 1,
      lv_offset     TYPE i,
      lv_flg_block  TYPE c LENGTH 1 VALUE 'X',
      lv_id         TYPE i,
      lv_result     TYPE int8.

FIELD-SYMBOLS: <fs_disk_end> TYPE ty_disk.

lv_filename = 'I:\Advent_of_Code\Tag_9.txt'.

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

READ TABLE lt_data INTO lv_data INDEX 1.

lv_length = strlen( lv_data ).

ls_disk_start-index = '-1'.
lv_id = '-1'.

DO lv_length TIMES.

  lv_offset = sy-index - 1.
  lv_zahl = lv_data+lv_offset(1).

  IF lv_flg_block = 'X'.

    lv_id = lv_id + 1.

    DO lv_zahl TIMES.

      ls_disk_start-index = ls_disk_start-index + 1.
      ls_disk_start-id = lv_id.
      ls_disk_start-flg_leer = ''.
      APPEND ls_disk_start TO lt_disk_start.

    ENDDO.

    lv_flg_block = ''.

  ELSE.

    DO lv_zahl TIMES.

      ls_disk_start-index = ls_disk_start-index + 1.
      ls_disk_start-id = ''.
      ls_disk_start-flg_leer = 'X'.
      APPEND ls_disk_start TO lt_disk_start.

    ENDDO.

    lv_flg_block = 'X'.

  ENDIF.

ENDDO.

lt_disk_end = lt_disk_start.

SORT lt_disk_start BY index DESCENDING.
DELETE lt_disk_start WHERE flg_leer = 'X'.

LOOP AT lt_disk_end ASSIGNING <fs_disk_end> WHERE flg_leer = 'X'.

  LOOP AT lt_disk_start INTO ls_disk_start WHERE flg_leer <> 'X' AND index > <fs_disk_end>-index.
    <fs_disk_end>-id = ls_disk_start-id.
    <fs_disk_end>-flg_leer = ''.
    DELETE lt_disk_start INDEX 1.
    DELETE lt_disk_end INDEX ls_disk_start-index + 1.
    EXIT.
  ENDLOOP.

  IF sy-subrc <> '0'.
    DELETE lt_disk_end INDEX sy-tabix.
  ENDIF.

ENDLOOP.

LOOP AT lt_disk_end INTO ls_disk_end.
  lv_result = lv_result + ls_disk_end-id * ls_disk_end-index.
ENDLOOP.

WRITE: / lv_result.

*****************************************************************************
* Part 2
*****************************************************************************

LOOP AT lt_data INTO lv_data.



ENDLOOP.
