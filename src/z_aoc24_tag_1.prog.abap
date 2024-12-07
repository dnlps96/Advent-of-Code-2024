*&---------------------------------------------------------------------*
*& Report Z_AOC24_TAG_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_aoc24_tag_1.

DATA: lv_filename TYPE string,
      lt_data     TYPE TABLE OF string,
      lv_data     TYPE string.

DATA: lt_zahl1        TYPE TABLE OF i,
      lt_zahl2        TYPE TABLE OF i,
      lv_zahl1        TYPE i,
      lv_zahl2        TYPE i,
      lv_data1        TYPE string,
      lv_data2        TYPE string,
      lv_distance     TYPE i,
      lv_distance_all TYPE i,
      lv_similarity   TYPE i.

lv_filename = 'I:\Advent_of_Code\Tag_1.txt'.

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

LOOP AT lt_data INTO lv_data.

  SPLIT lv_data AT '  ' INTO lv_data1 lv_data2.

  APPEND lv_data1 TO lt_zahl1.
  APPEND lv_data2 TO lt_zahl2.

ENDLOOP.

*****************************************************************************
* Part 1
*****************************************************************************

SORT lt_zahl1.
SORT lt_zahl2.

LOOP AT lt_zahl1 INTO lv_zahl1.

  READ TABLE lt_zahl2 INDEX sy-tabix INTO lv_zahl2.

  IF lv_zahl1 > lv_zahl2.
    lv_distance = lv_zahl1 - lv_zahl2.
  ELSE.
    lv_distance = lv_zahl2 - lv_zahl1.
  ENDIF.

  lv_distance_all = lv_distance_all + lv_distance.

ENDLOOP.

WRITE: / lv_distance_all.

*****************************************************************************
* Part 2
*****************************************************************************

LOOP AT lt_zahl1 INTO lv_zahl1.

  LOOP AT lt_zahl2 INTO lv_zahl2 WHERE table_line = lv_zahl1.

    lv_similarity = lv_similarity + lv_zahl2.

  ENDLOOP.

ENDLOOP.

WRITE: / lv_similarity.
