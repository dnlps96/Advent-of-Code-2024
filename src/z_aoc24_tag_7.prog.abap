*&---------------------------------------------------------------------*
*& Report Z_AOC24_TAG_7
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_aoc24_tag_7.

DATA: lv_filename TYPE string,
      lt_data     TYPE TABLE OF string,
      lv_data     TYPE string.

DATA: lv_result_string TYPE string,
      lv_rest          TYPE string,
      lv_result        TYPE p LENGTH 16,
      lv_result_all    TYPE p LENGTH 16,
      lt_zahlen        TYPE TABLE OF string,
      lt_results       LIKE TABLE OF lv_result.

lv_filename = 'I:\Advent_of_Code\Tag_7.txt'.

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

  clear lt_results.

  SPLIT lv_data AT ': ' INTO lv_result_string lv_rest.
  lv_result = lv_result_string.

  SPLIT lv_rest AT ' ' INTO TABLE lt_zahlen.

  PERFORM calaculate_1 CHANGING lt_zahlen lt_results.

  READ TABLE lt_results WITH KEY table_line = lv_result TRANSPORTING NO FIELDS.

  IF sy-subrc = 0.
    lv_result_all = lv_result_all + lv_result.
  ENDIF.

ENDLOOP.

WRITE: / lv_result_all.

*****************************************************************************
* Part 2
*****************************************************************************

clear lv_result_all.

LOOP AT lt_data INTO lv_data.

  clear lt_results.

  SPLIT lv_data AT ': ' INTO lv_result_string lv_rest.
  lv_result = lv_result_string.

  SPLIT lv_rest AT ' ' INTO TABLE lt_zahlen.

  PERFORM calaculate_2 CHANGING lt_zahlen lt_results.

  READ TABLE lt_results WITH KEY table_line = lv_result TRANSPORTING NO FIELDS.

  IF sy-subrc = 0.
    lv_result_all = lv_result_all + lv_result.
  ENDIF.

ENDLOOP.

WRITE: / lv_result_all.

*****************************************************************************
* Form Part 1
*****************************************************************************
FORM calaculate_1 CHANGING lt_zahlen LIKE lt_zahlen
                         lt_results LIKE lt_results.

  DATA: lv_zahl_string TYPE string,
        lv_zahl        TYPE p LENGTH 16,
        lv_result_work TYPE p LENGTH 16,
        lt_results_new LIKE TABLE OF lv_result_work.

  FIELD-SYMBOLS <fs_result_work> LIKE lv_result_work.

  IF lt_zahlen IS NOT INITIAL.

    READ TABLE lt_zahlen INDEX 1 INTO lv_zahl_string.
    lv_zahl = lv_zahl_string.

    IF lt_results IS INITIAL.
      APPEND lv_zahl TO lt_results.
    ELSE.

      LOOP AT lt_results ASSIGNING <fs_result_work>.

        lv_result_work = <fs_result_work> * lv_zahl.
        APPEND lv_result_work TO lt_results_new.

        <fs_result_work> = <fs_result_work> + lv_zahl.

      ENDLOOP.

      APPEND LINES OF lt_results_new TO lt_results.

    ENDIF.

    DELETE lt_zahlen INDEX 1.

    PERFORM calaculate_1 CHANGING lt_zahlen lt_results.

  ENDIF.

ENDFORM.
*****************************************************************************
* Form Part 2
*****************************************************************************
FORM calaculate_2 CHANGING lt_zahlen LIKE lt_zahlen
                         lt_results LIKE lt_results.

  DATA: lv_zahl_string TYPE string,
        lv_zahl        TYPE p LENGTH 16,
        lv_result_work TYPE p LENGTH 16,
        lt_results_new LIKE TABLE OF lv_result_work.

  FIELD-SYMBOLS <fs_result_work> LIKE lv_result_work.

  IF lt_zahlen IS NOT INITIAL.

    READ TABLE lt_zahlen INDEX 1 INTO lv_zahl_string.
    lv_zahl = lv_zahl_string.

    IF lt_results IS INITIAL.
      APPEND lv_zahl TO lt_results.
    ELSE.

      LOOP AT lt_results ASSIGNING <fs_result_work>.

        APPEND |{ <fs_result_work> }{ lv_zahl }| TO lt_results_new.

        lv_result_work = <fs_result_work> * lv_zahl.
        APPEND lv_result_work TO lt_results_new.

        <fs_result_work> = <fs_result_work> + lv_zahl.

      ENDLOOP.

      APPEND LINES OF lt_results_new TO lt_results.

    ENDIF.

    DELETE lt_zahlen INDEX 1.

    PERFORM calaculate_2 CHANGING lt_zahlen lt_results.

  ENDIF.

ENDFORM.
