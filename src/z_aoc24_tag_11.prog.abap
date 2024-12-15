*&---------------------------------------------------------------------*
*& Report Z_AOC24_TAG_11
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_aoc24_tag_11.

TYPES: BEGIN OF ty_result,
         stone  TYPE string,
         result TYPE int8,
       END OF ty_result.

DATA: lv_filename TYPE string,
      lt_data     TYPE TABLE OF string,
      lv_data     TYPE string.

DATA: lt_stones     TYPE TABLE OF string,
      lt_stones_new TYPE TABLE OF string,
      lt_stones_1   TYPE TABLE OF string,
      lt_stones_2   TYPE TABLE OF string,
      lt_stones_3   TYPE TABLE OF string,
      lv_stone      TYPE string,
      lv_stone_1      TYPE string,
      lv_stone_2      TYPE string,
      lv_stone_3      TYPE string,
      lv_stone_temp TYPE string,
      lv_zahl       TYPE int8,
      lv_length     TYPE i,
      lv_result     TYPE int8,
      lv_result_1   TYPE int8,
      lv_result_2   TYPE int8,
      ls_result     TYPE ty_result,
      lt_result_2   TYPE TABLE OF ty_result,
      lt_result_3   TYPE TABLE OF ty_result.

lv_filename = 'I:\Advent_of_Code\Tag_11.txt'.

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

SPLIT lv_data AT ' ' INTO TABLE lt_stones.

DO 25 TIMES.

  LOOP AT lt_stones INTO lv_stone.

    SHIFT lv_stone RIGHT DELETING TRAILING space.
    SHIFT lv_stone LEFT DELETING LEADING space.

    IF lv_stone = '0' OR lv_stone IS INITIAL..
      lv_stone = '1'.
      APPEND lv_stone TO lt_stones_new.

    ELSEIF strlen( lv_stone ) MOD 2 = 0.
      lv_length = strlen( lv_stone ) / 2.

      lv_stone_temp = lv_stone(lv_length).
      SHIFT lv_stone_temp LEFT DELETING LEADING '0'.
      APPEND lv_stone_temp TO lt_stones_new.

      lv_stone_temp = lv_stone+lv_length(lv_length).
      SHIFT lv_stone_temp LEFT DELETING LEADING '0'.
      APPEND lv_stone_temp TO lt_stones_new.

    ELSE.
      lv_zahl = lv_stone.
      lv_zahl = lv_zahl * 2024.
      lv_stone = lv_zahl.
      APPEND lv_stone TO lt_stones_new.
    ENDIF.

  ENDLOOP.

  lt_stones = lt_stones_new.
  CLEAR lt_stones_new.

ENDDO.

WRITE: / lines( lt_stones ).

*****************************************************************************
* Part 2
*****************************************************************************

READ TABLE lt_data INTO lv_data INDEX 1.

SPLIT lv_data AT ' ' INTO TABLE lt_stones.

LOOP AT lt_stones INTO lv_stone.

  APPEND lv_stone TO lt_stones_1.

  DO 25 TIMES.

    LOOP AT lt_stones_1 INTO lv_stone_1.

      SHIFT lv_stone_1 RIGHT DELETING TRAILING space.
      SHIFT lv_stone_1 LEFT DELETING LEADING space.

      IF lv_stone_1 = '0' OR lv_stone_1 IS INITIAL..
        lv_stone_1 = '1'.
        APPEND lv_stone_1 TO lt_stones_new.

      ELSEIF strlen( lv_stone_1 ) MOD 2 = 0.
        lv_length = strlen( lv_stone_1 ) / 2.

        lv_stone_temp = lv_stone_1(lv_length).
        SHIFT lv_stone_temp LEFT DELETING LEADING '0'.
        APPEND lv_stone_temp TO lt_stones_new.

        lv_stone_temp = lv_stone_1+lv_length(lv_length).
        SHIFT lv_stone_temp LEFT DELETING LEADING '0'.
        APPEND lv_stone_temp TO lt_stones_new.

      ELSE.
        lv_zahl = lv_stone_1.
        lv_zahl = lv_zahl * 2024.
        lv_stone_1 = lv_zahl.
        APPEND lv_stone_1 TO lt_stones_new.
      ENDIF.

    ENDLOOP.

    lt_stones_1 = lt_stones_new.
    CLEAR lt_stones_new.

  ENDDO.

  CLEAR lv_result_1.

  LOOP AT lt_stones_1 INTO lv_stone_1.

    READ TABLE lt_result_2 INTO ls_result WITH KEY stone = lv_stone_1.

    IF sy-subrc <> 0.

      APPEND lv_stone_1 TO lt_stones_2.

      DO 25 TIMES.

        LOOP AT lt_stones_2 INTO lv_stone_2.

          SHIFT lv_stone_2 RIGHT DELETING TRAILING space.
          SHIFT lv_stone_2 LEFT DELETING LEADING space.

          IF lv_stone_2 = '0' OR lv_stone_2 IS INITIAL..
            lv_stone_2 = '1'.
            APPEND lv_stone_2 TO lt_stones_new.

          ELSEIF strlen( lv_stone_2 ) MOD 2 = 0.
            lv_length = strlen( lv_stone_2 ) / 2.

            lv_stone_temp = lv_stone_2(lv_length).
            SHIFT lv_stone_temp LEFT DELETING LEADING '0'.
            APPEND lv_stone_temp TO lt_stones_new.

            lv_stone_temp = lv_stone_2+lv_length(lv_length).
            SHIFT lv_stone_temp LEFT DELETING LEADING '0'.
            APPEND lv_stone_temp TO lt_stones_new.

          ELSE.
            lv_zahl = lv_stone_2.
            lv_zahl = lv_zahl * 2024.
            lv_stone_2 = lv_zahl.
            APPEND lv_stone_2 TO lt_stones_new.
          ENDIF.

        ENDLOOP.

        lt_stones_2 = lt_stones_new.
        CLEAR lt_stones_new.

      ENDDO.

      CLEAR lv_result_2.

      LOOP AT lt_stones_2 INTO lv_stone_2.

        READ TABLE lt_result_3 INTO ls_result WITH KEY stone = lv_stone_2.

        IF sy-subrc <> 0.

          APPEND lv_stone_2 TO lt_stones_3.

          DO 25 TIMES.

            LOOP AT lt_stones_3 INTO lv_stone_3.

              SHIFT lv_stone_3 RIGHT DELETING TRAILING space.
              SHIFT lv_stone_3 LEFT DELETING LEADING space.

              IF lv_stone_3 = '0' OR lv_stone_3 IS INITIAL..
                lv_stone_3 = '1'.
                APPEND lv_stone_3 TO lt_stones_new.

              ELSEIF strlen( lv_stone_3 ) MOD 2 = 0.
                lv_length = strlen( lv_stone_3 ) / 2.

                lv_stone_temp = lv_stone_3(lv_length).
                SHIFT lv_stone_temp LEFT DELETING LEADING '0'.
                APPEND lv_stone_temp TO lt_stones_new.

                lv_stone_temp = lv_stone_3+lv_length(lv_length).
                SHIFT lv_stone_temp LEFT DELETING LEADING '0'.
                APPEND lv_stone_temp TO lt_stones_new.

              ELSE.
                lv_zahl = lv_stone_3.
                lv_zahl = lv_zahl * 2024.
                lv_stone_3 = lv_zahl.
                APPEND lv_stone_3 TO lt_stones_new.
              ENDIF.

            ENDLOOP.

            lt_stones_3 = lt_stones_new.
            CLEAR lt_stones_new.

          ENDDO.

          ls_result-stone = lv_stone_2.
          ls_result-result = lines( lt_stones_3 ).
          APPEND ls_result TO lt_result_3.

          CLEAR lt_stones_3.

        ENDIF.

        lv_result_2 = lv_result_2 + ls_result-result.

      ENDLOOP.

      ls_result-stone = lv_stone_1.
      ls_result-result = lv_result_2.
      APPEND ls_result TO lt_result_2.

      CLEAR lt_stones_2.

    ENDIF.

    lv_result_1 = lv_result_1 + ls_result-result.

  ENDLOOP.

  lv_result = lv_result + lv_result_1.

  CLEAR lt_stones_1.

ENDLOOP.

WRITE: / lv_result.
