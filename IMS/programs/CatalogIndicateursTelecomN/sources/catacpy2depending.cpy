      ******************************************************************
      *INPUT/OUTPUT MESSAGE AREA FOR NEW TABLES
      ******************************************************************

      ******************************************************************
      * DATA AREA FOR TRANSACTION INPUT
      ******************************************************************


      ******************************************************************
      * DATA AREA FOR TRANSACTION OUTPUT - MULTIPLE RECORDS (50 MAX)
      ******************************************************************
       01 OUTPUT-MSG-50.
          05 OUT-LL-50                PIC S9(4) COMP-5.
          05 OUT-ZZ-50                PIC S9(4) COMP-5.
          05 OUT-MESSAGE-50           PIC X(40).
          05 OUT-NUM-RECORDS          PIC S9(3).
          05 OUT-RECORDS-50           PIC X(32000).

      * PERSPECTIVE
          05 OUT-RECORD-PERSP-OUT-50 REDEFINES OUT-RECORDS-50.
             07 OUT-RECORD-PERSP-50    OCCURS 0 TO 50 TIMES 
                                      DEPENDING ON OUT-NUM-RECORDS.
                   09 OUT-PERSP-ID-REC        PIC 9(10).
                   09 OUT-PERSP-NAME-REC      PIC X(150).
                   09 OUT-PERSP-DES-REC       PIC X(150).
             07 FILLER                 PIC X(16500).

      * OBJECTIF
          05 OUT-RECORD-OBJ-OUT-50 REDEFINES OUT-RECORDS-50.
             07 OUT-RECORD-OBJ-50    OCCURS 0 TO 50 TIMES 
                                      DEPENDING ON OUT-NUM-RECORDS.
                09 OUT-OBJ-ID-REC          PIC 9(10).
                09 OUT-OBJ-NAME-REC        PIC X(150).
                09 OUT-PERSP-ID-REC        PIC 9(10).
             07 FILLER                     PIC X(23500).

      * LEVIER
          05 OUT-RECORD-LEV-OUT-50 REDEFINES OUT-RECORDS-50.
            07 OUT-RECORD-LEV-50    OCCURS 0 TO 50 TIMES 
                                      DEPENDING ON OUT-NUM-RECORDS.
                09 OUT-LEV-ID-REC          PIC 9(10).
                09 OUT-LEV-NAME-REC        PIC X(150).
                09 OUT-OBJ-ID-REC          PIC 9(10).
            07 FILLER                         PIC X(23500).

      * INDICATEUR
          05 OUT-RECORD-IND-OUT-50 REDEFINES OUT-RECORDS-50.
            07 OUT-RECORD-IND-50    OCCURS 0 TO 50 TIMES 
                                      DEPENDING ON OUT-NUM-RECORDS.
                09 OUT-LEV-ID-REC          PIC 9(10).
                09 OUT-IND-EXEMPLE-REC     PIC X(150).
                09 OUT-IND-ID-REC          PIC 9(10).
                09 OUT-IND-DEFINITION-REC  PIC X(150).
                09 OUT-IND-NATURE-REC      PIC X(20).
                09 OUT-IND-MESURABLE-REC   PIC 9(2).
                09 OUT-IND-SCOPE-REC       PIC X(20).
                09 OUT-IND-TYPE-REC        PIC X(20).
                09 OUT-IND-SOURCE-REC      PIC X(255).
            07 FILLER                     PIC X(150).