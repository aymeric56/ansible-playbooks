      ******************************************************************
      *INPUT/OUTPUT MESSAGE AREA FOR NEW TABLES
      ******************************************************************

      ******************************************************************
      * DATA AREA FOR TRANSACTION INPUT
      ******************************************************************
       01 ENTREE-SO.
          05 INSO-COMMAND             PIC X(8).
          05 INSO-RECORD              PIC X(1110).
      * PERSPECTIVE
          05 INSO-RECORD-OBJ REDEFINES INSO-RECORD.
               07 INSO-OBJ-ID         PIC 9(10).
               07 INSO-OBJ-NAME       PIC X(150).
               07 INSO-OBJ-DES        PIC X(150).
               07 INSO-PERSP-ID       PIC 9(10).
               07 FILLER              PIC X(800).

      ******************************************************************
      * DATA AREA FOR TRANSACTION OUTPUT
      ******************************************************************
       01 SORTIE-SO.
          05 OUTSO-MESSAGE            PIC X(40).
          05 OUTSO-RECORD             PIC X(1110).
      * PERSPECTIVE
          05 OUTSO-RECORD-OBJ REDEFINES OUTSO-RECORD.
               07 OUTSO-OBJ-ID        PIC 9(10).
               07 OUTSO-OBJ-NAME      PIC X(150).
               07 OUTSO-OBJ-DES       PIC X(150).
               07 OUTSO-PERSP-ID      PIC 9(10).
               07 FILLER              PIC X(800).