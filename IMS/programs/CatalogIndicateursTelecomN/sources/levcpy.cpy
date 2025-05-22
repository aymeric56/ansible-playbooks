      ******************************************************************
      *INPUT/OUTPUT MESSAGE AREA FOR NEW TABLES
      ******************************************************************

      ******************************************************************
      * DATA AREA FOR TRANSACTION INPUT
      ******************************************************************
       01 ENTREE-SL.
          05 INSL-COMMAND             PIC X(8).
          05 INSL-RECORD              PIC X(1110).
      * PERSPECTIVE
          05 INSL-RECORD-LEV REDEFINES INSL-RECORD.
               07 INSL-LEV-ID         PIC 9(10).
               07 INSL-LEV-NAME       PIC X(150).
               07 INSL-OBJ-ID         PIC 9(10).
               07 FILLER              PIC X(800).

      ******************************************************************
      * DATA AREA FOR TRANSACTION OUTPUT
      ******************************************************************
       01 SORTIE-SL.
          05 OUTSL-MESSAGE            PIC X(40).
          05 OUTSL-RECORD             PIC X(1110).
      * PERSPECTIVE
          05 OUTSL-RECORD-LEV REDEFINES OUTSL-RECORD.
               07 OUTSL-LEV-ID        PIC 9(10).
               07 OUTSL-LEV-NAME      PIC X(150).
               07 OUTSL-OBJ-ID        PIC 9(10).
               07 FILLER              PIC X(800).

      ******************************************************************
      * DATA AREA FOR TRANSACTION OUTPUT - SORTIE-SL-50
      ******************************************************************
       01 SORTIE-SL-50.
          05 OUTSL-MESSAGE-50         PIC X(40).
          05 OUTSL-NUM-RECORDS-50     PIC S9(3).
          05 OUTSL-RECORD-50-L.
                07 OUTSL-RECORD-50             OCCURS 50 TIMES
                                           INDEXED BY OUTSL-IDX.
      * LEVIER STRUCTURE
                    09 OUTSL-LEV-ID-REC      PIC 9(10).
                    09 OUTSL-LEV-NAME-REC    PIC X(150).
                    09 OUTSL-OBJ-ID-REC      PIC 9(10).