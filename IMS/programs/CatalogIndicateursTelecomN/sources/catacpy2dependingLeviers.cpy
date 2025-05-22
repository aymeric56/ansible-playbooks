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
          05 OUT-RECORD-LEV-OUT-50.
            07 OUT-RECORD-LEV-50    OCCURS 0 TO 50 TIMES 
                                      DEPENDING ON OUT-NUM-RECORDS.
                09 OUT-LEV-ID-REC          PIC 9(10).
                09 OUT-LEV-NAME-REC        PIC X(150).
                09 OUT-OBJ-ID-REC          PIC 9(10).
