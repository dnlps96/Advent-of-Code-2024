*&---------------------------------------------------------------------*
*& Report Z_AOC24_TAG_13
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_aoc24_tag_13.

DATA: lv_filename TYPE string,
      lt_data     TYPE TABLE OF string,
      lv_data     TYPE string.

DATA: lv_button_a_x TYPE int8,
      lv_button_a_y TYPE int8,
      lv_button_b_x TYPE int8,
      lv_button_b_y TYPE int8,
      lv_prize_x    TYPE int8,
      lv_prize_y    TYPE int8,
      lv_sum_x      TYPE int8,
      lv_sum_y      TYPE int8,
      lv_anzahl_a   TYPE int8,
      lv_anzahl_b   TYPE int8,
      lt_regex      TYPE match_result_tab,
      ls_regex      TYPE match_result,
      lv_costs      TYPE int8,
      lv_costs_all  TYPE int8,
      lv_do         TYPE int8.

lv_filename = 'I:\Advent_of_Code\Tag_13.txt'.

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

  IF lv_data CS 'Button A'.

    CLEAR lt_regex.
    FIND ALL OCCURRENCES OF PCRE '[0-9]+' IN lv_data RESULTS lt_regex.
    READ TABLE lt_regex INDEX 1 INTO ls_regex.
    lv_button_a_x = lv_data+ls_regex-offset(ls_regex-length).
    READ TABLE lt_regex INDEX 2 INTO ls_regex.
    lv_button_a_y = lv_data+ls_regex-offset(ls_regex-length).

  ELSEIF lv_data CS 'Button B'.

    CLEAR lt_regex.
    FIND ALL OCCURRENCES OF PCRE '[0-9]+' IN lv_data RESULTS lt_regex.
    READ TABLE lt_regex INDEX 1 INTO ls_regex.
    lv_button_b_x = lv_data+ls_regex-offset(ls_regex-length).
    READ TABLE lt_regex INDEX 2 INTO ls_regex.
    lv_button_b_y = lv_data+ls_regex-offset(ls_regex-length).

  ELSEIF lv_data CS 'Prize'.

    CLEAR lt_regex.
    FIND ALL OCCURRENCES OF PCRE '[0-9]+' IN lv_data RESULTS lt_regex.
    READ TABLE lt_regex INDEX 1 INTO ls_regex.
    lv_prize_x = lv_data+ls_regex-offset(ls_regex-length).
    READ TABLE lt_regex INDEX 2 INTO ls_regex.
    lv_prize_y = lv_data+ls_regex-offset(ls_regex-length).

    DO 100 TIMES.

      lv_anzahl_a = sy-index.
      lv_sum_x = lv_anzahl_a * lv_button_a_x.

      IF 0 = ( lv_prize_x - lv_sum_x ) MOD lv_button_b_x.
        lv_anzahl_b = ( lv_prize_x - lv_sum_x ) / lv_button_b_x.
        IF lv_anzahl_b <= 100 AND lv_anzahl_a * lv_button_a_y + lv_anzahl_b * lv_button_b_y = lv_prize_y.
          IF 3 * lv_anzahl_a + lv_anzahl_b < lv_costs OR lv_costs IS INITIAL.
            lv_costs = 3 * lv_anzahl_a + lv_anzahl_b.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDDO.

    lv_costs_all = lv_costs_all + lv_costs.

  ELSE. "Leere Zeile

    CLEAR: lv_button_a_x,
           lv_button_a_y,
           lv_button_b_x,
           lv_button_b_y,
           lv_prize_x,
           lv_prize_y,
           lv_costs.

  ENDIF.

ENDLOOP.

WRITE: / lv_costs_all.

*****************************************************************************
* Part 2
*****************************************************************************

CLEAR lv_costs_all.

LOOP AT lt_data INTO lv_data.

  IF lv_data CS 'Button A'.

    CLEAR lt_regex.
    FIND ALL OCCURRENCES OF PCRE '[0-9]+' IN lv_data RESULTS lt_regex.
    READ TABLE lt_regex INDEX 1 INTO ls_regex.
    lv_button_a_x = lv_data+ls_regex-offset(ls_regex-length).
    READ TABLE lt_regex INDEX 2 INTO ls_regex.
    lv_button_a_y = lv_data+ls_regex-offset(ls_regex-length).

  ELSEIF lv_data CS 'Button B'.

    CLEAR lt_regex.
    FIND ALL OCCURRENCES OF PCRE '[0-9]+' IN lv_data RESULTS lt_regex.
    READ TABLE lt_regex INDEX 1 INTO ls_regex.
    lv_button_b_x = lv_data+ls_regex-offset(ls_regex-length).
    READ TABLE lt_regex INDEX 2 INTO ls_regex.
    lv_button_b_y = lv_data+ls_regex-offset(ls_regex-length).

  ELSEIF lv_data CS 'Prize'.

    CLEAR lt_regex.
    FIND ALL OCCURRENCES OF PCRE '[0-9]+' IN lv_data RESULTS lt_regex.
    READ TABLE lt_regex INDEX 1 INTO ls_regex.
    lv_prize_x = 10000000000000 + lv_data+ls_regex-offset(ls_regex-length).
    READ TABLE lt_regex INDEX 2 INTO ls_regex.
    lv_prize_y = 10000000000000 + lv_data+ls_regex-offset(ls_regex-length).

    lv_do = lv_prize_x / lv_button_a_x.

    DO.

      lv_anzahl_a = lv_anzahl_a + 1.
      lv_sum_x = lv_anzahl_a * lv_button_a_x.

      IF lv_anzahl_a > lv_do.
        EXIT.
      ENDIF.

      IF 0 = ( lv_prize_x - lv_sum_x ) MOD lv_button_b_x.
        lv_anzahl_b = ( lv_prize_x - lv_sum_x ) / lv_button_b_x.
        IF lv_anzahl_a * lv_button_a_y + lv_anzahl_b * lv_button_b_y = lv_prize_y.
          IF 3 * lv_anzahl_a + lv_anzahl_b < lv_costs OR lv_costs IS INITIAL.
            lv_costs = 3 * lv_anzahl_a + lv_anzahl_b.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDDO.

    lv_costs_all = lv_costs_all + lv_costs.

  ELSE. "Leere Zeile

    CLEAR: lv_button_a_x,
           lv_button_a_y,
           lv_button_b_x,
           lv_button_b_y,
           lv_prize_x,
           lv_prize_y,
           lv_costs,
           lv_anzahl_a,
           lv_anzahl_b.

  ENDIF.

ENDLOOP.

WRITE: / lv_costs_all.
