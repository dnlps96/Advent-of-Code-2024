*&---------------------------------------------------------------------*
*& Report Z_AOC24_TAG_11
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_aoc24_tag_11.

DATA: lv_filename TYPE string,
      lt_data     TYPE TABLE OF string,
      lv_data     TYPE string.

DATA: lt_stones     TYPE TABLE OF string,
      lt_stones_new TYPE TABLE OF string,
      lt_stones_1   TYPE TABLE OF string,
      lt_stones_2   TYPE TABLE OF string,
      lt_stones_3   TYPE TABLE OF string,
      lv_stone      TYPE string,
      lv_stone_temp TYPE string,
      lv_zahl       TYPE int8,
      lv_length     TYPE i,
      lv_result     TYPE int8.

*lv_filename = 'I:\Advent_of_Code\Tag_11.txt'.
*
*CALL METHOD cl_gui_frontend_services=>gui_upload
*  EXPORTING
*    filename = lv_filename
*    codepage = '1100'
*  CHANGING
*    data_tab = lt_data
*  EXCEPTIONS
*    OTHERS   = 1.
*
*IF sy-subrc <> 0.
*  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*           WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*ENDIF.

*for Part 2, it is necessary that the report is executed in the background

lv_data = |475449 2599064 213 0 2 65 5755 51149|. "place the input here

*****************************************************************************
* Part 1
*****************************************************************************

*READ TABLE lt_data INTO lv_data INDEX 1.

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

*READ TABLE lt_data INTO lv_data INDEX 1.

SPLIT lv_data AT ' ' INTO TABLE lt_stones.

LOOP AT lt_stones INTO lv_stone.

  APPEND lv_stone TO lt_stones_1.

  DO 25 TIMES.

    LOOP AT lt_stones_1 INTO lv_stone.

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

    lt_stones_1 = lt_stones_new.
    CLEAR lt_stones_new.

  ENDDO.

  LOOP AT lt_stones_1 INTO lv_stone.

    APPEND lv_stone TO lt_stones_2.

    DO 25 TIMES.

      LOOP AT lt_stones_2 INTO lv_stone.

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

      lt_stones_2 = lt_stones_new.
      CLEAR lt_stones_new.

    ENDDO.

    LOOP AT lt_stones_2 INTO lv_stone.

      APPEND lv_stone TO lt_stones_3.

      DO 25 TIMES.

        LOOP AT lt_stones_3 INTO lv_stone.

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

        lt_stones_3 = lt_stones_new.
        CLEAR lt_stones_new.

      ENDDO.

      lv_result = lv_result + lines( lt_stones_3 ).
      CLEAR lt_stones_3.

    ENDLOOP.

    CLEAR lt_stones_2.

  ENDLOOP.

  CLEAR lt_stones_1.

ENDLOOP.

WRITE: / lv_result.
