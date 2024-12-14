*&---------------------------------------------------------------------*
*& Report Z_AOC24_TAG_14
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_aoc24_tag_14.

DATA: lv_filename TYPE string,
      lt_data     TYPE TABLE OF string,
      lv_data     TYPE string.

DATA: lt_regex      TYPE match_result_tab,
      ls_regex      TYPE match_result,
      lv_position_x TYPE i,
      lv_position_y TYPE i,
      lv_move_x     TYPE i,
      lv_move_y     TYPE i,
      lv_count_1    TYPE i,
      lv_count_2    TYPE i,
      lv_count_3    TYPE i,
      lv_count_4    TYPE i,
      lv_result     TYPE i.

CONSTANTS: c_max_x TYPE i VALUE 101,
           c_max_y TYPE i VALUE 103.

lv_filename = 'I:\Advent_of_Code\Tag_14.txt'.

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

  CLEAR lt_regex.
  FIND ALL OCCURRENCES OF PCRE '-{0,1}[0-9]+' IN lv_data RESULTS lt_regex.
  READ TABLE lt_regex INDEX 1 INTO ls_regex.
  lv_position_x = lv_data+ls_regex-offset(ls_regex-length) + 1.
  READ TABLE lt_regex INDEX 2 INTO ls_regex.
  lv_position_y = lv_data+ls_regex-offset(ls_regex-length) + 1.
  READ TABLE lt_regex INDEX 3 INTO ls_regex.
  lv_move_x = lv_data+ls_regex-offset(ls_regex-length).
  READ TABLE lt_regex INDEX 4 INTO ls_regex.
  lv_move_y = lv_data+ls_regex-offset(ls_regex-length).

  DO 100 TIMES.

    lv_position_x = lv_position_x + lv_move_x.
    IF lv_position_x > c_max_x.
      lv_position_x = lv_position_x - c_max_x.
    ELSEIF lv_position_x < 1.
      lv_position_x = lv_position_x + c_max_x.
    ENDIF.

    lv_position_y = lv_position_y + lv_move_y.
    IF lv_position_y > c_max_y.
      lv_position_y = lv_position_y - c_max_y.
    ELSEIF lv_position_y < 1.
      lv_position_y = lv_position_y + c_max_y.
    ENDIF.

  ENDDO.

  IF lv_position_x < ( c_max_x + 1 ) / 2 AND lv_position_y < ( c_max_y + 1 ) / 2.
    lv_count_1 = lv_count_1 + 1.
  ELSEIF lv_position_x < ( c_max_x + 1 ) / 2 AND lv_position_y > ( c_max_y + 1 ) / 2.
    lv_count_2 = lv_count_2 + 1.
  ELSEIF lv_position_x > ( c_max_x + 1 ) / 2 AND lv_position_y < ( c_max_y + 1 ) / 2.
    lv_count_3 = lv_count_3 + 1.
  ELSEIF lv_position_x > ( c_max_x + 1 ) / 2 AND lv_position_y > ( c_max_y + 1 ) / 2.
    lv_count_4 = lv_count_4 + 1.
  ENDIF.

ENDLOOP.

lv_result = lv_count_1 * lv_count_2 * lv_count_3 * lv_count_4.

WRITE: / lv_result.

*****************************************************************************
* Part 2
*****************************************************************************

LOOP AT lt_data INTO lv_data.



ENDLOOP.
