      ******************************************************************
      *INPUT/OUTPUT MESSAGE AREA FOR NEW TABLES
      ******************************************************************

      ******************************************************************
      * DATA AREA FOR TRANSACTION INPUT
      ******************************************************************
       01 ENTREE-SI.
          05 INSI-COMMAND             PIC X(8).
          05 INSI-RECORD              PIC X(1110).
      * INDICATEUR
          05 INSI-RECORD-IND REDEFINES INSI-RECORD.
               07 INSI-LEV-ID           PIC 9(10).
               07 INSI-IND-EXEMPLE      PIC X(150).
               07 INSI-IND-ID           PIC 9(10).
               07 INSI-IND-DEFINITION   PIC X(150).
               07 INSI-IND-NATURE       PIC X(20).
               07 INSI-IND-MESURABLE    PIC 9(2).
               07 INSI-IND-SCOPE        PIC X(20).
               07 INSI-IND-TYPE         PIC X(20).
               07 INSI-IND-SOURCE       PIC X(255).
               07 FILLER                PIC X(473).

      ******************************************************************
      * DATA AREA FOR TRANSACTION OUTPUT
      ******************************************************************
       01 SORTIE-SI.
          05 OUTSI-MESSAGE            PIC X(40).
          05 OUTSI-RECORD             PIC X(1110).
      * INDICATEUR
          05 OUTSI-RECORD-IND REDEFINES OUTSI-RECORD.
               07 OUTSI-LEV-ID          PIC 9(10).
               07 OUTSI-IND-EXEMPLE     PIC X(150).
               07 OUTSI-IND-ID          PIC 9(10).
               07 OUTSI-IND-DEFINITION  PIC X(150).
               07 OUTSI-IND-NATURE      PIC X(20).
               07 OUTSI-IND-MESURABLE   PIC 9(2).
               07 OUTSI-IND-SCOPE       PIC X(20).
               07 OUTSI-IND-TYPE        PIC X(20).
               07 OUTSI-IND-SOURCE      PIC X(255).
               07 FILLER                PIC X(473).

    ******************************************************************
      * DATA AREA FOR TRANSACTION OUTPUT - SORTIE-SI-50
      ******************************************************************
       01 SORTIE-SI-50.
          05 OUTSI-MESSAGE-50         PIC X(40).
          05 OUTSI-NUM-RECORDS-50     PIC S9(3).
          05 OUTSI-RECORD-50-I.
                07 OUTSI-RECORD-50             OCCURS 50 TIMES
                                           INDEXED BY OUTSI-IDX.
      * INDICATEUR STRUCTURE (MULTIPLE)
                    09 OUTSI-LEV-ID-REC          PIC 9(10).
                    09 OUTSI-IND-EXEMPLE-REC     PIC X(150).
                    09 OUTSI-IND-ID-REC          PIC 9(10).
                    09 OUTSI-IND-DEFINITION-REC  PIC X(150).
                    09 OUTSI-IND-NATURE-REC      PIC X(20).
                    09 OUTSI-IND-MESURABLE-REC   PIC 9(2).
                    09 OUTSI-IND-SCOPE-REC       PIC X(20).
                    09 OUTSI-IND-TYPE-REC        PIC X(20).
                    09 OUTSI-IND-SOURCE-REC      PIC X(255).