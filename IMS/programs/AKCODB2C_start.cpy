      ******************************************************************
      *INPUT/OUTPUT MESSAGE AREA
      ******************************************************************

      * DATA AREA FOR TRANSACTION INPUT
       01 CONTACTS-INPUT-MSG.
          02 IN-LL                  PICTURE S9(4) COMP-5.
          02 IN-ZZ                  PICTURE S9(4) COMP-5.
          02 IN-TRANCDE             PICTURE X(10).
          02 IN-COMMAND             PICTURE X(8).
          02 IN-RECORD.
             05 IN-LAST-NAME        PICTURE X(15).
             05 IN-FIRST-NAME       PICTURE X(15).
             05 IN-EXTENSION        PICTURE X(10).
             05 IN-ZIP-CODE         PICTURE X(7).
             05 FILLER              PICTURE X(40).

      * DATA AREA FOR TRANSACTION OUTPUT
       01 CONTACTS-OUTPUT-MSG.
          02 OUT-LL                 PIC S9(4) COMP-5.
          02 OUT-ZZ                 PIC S9(4) COMP-5.
          02 OUT-MESSAGE            PIC X(40).
          02 OUT-COMMAND            PIC X(8).
          02 OUT-RECORD.
             05 OUT-LAST-NAME       PIC X(15).
             05 OUT-FIRST-NAME      PIC X(15).
             05 OUT-EXTENSION       PIC X(10).
             05 OUT-ZIP-CODE        PIC X(7).
             05 FILLER              PICTURE X(40).

      * DATA AREA FOR TRANSACTION OUTPUT
       01 CONTACTS-OUTPUT-MSG-50.
          02 OUT-LL-50              PIC S9(4) COMP-5.
          02 OUT-ZZ-50              PIC S9(4) COMP-5.
          02 OUT-MESSAGE-50         PIC X(40).
          02 OUT-COMMAND-50         PIC X(8).
          02 OUT-NUM-RECORDS        PIC S9(3).
          02 OUT-RECORD-50 OCCURS 0 to 50 TIMES
                DEPENDING ON OUT-NUM-RECORDS 
                INDEXED BY OUT-REC-IDX.
             05 OUT-LAST-NAME-REC   PIC X(15).
             05 OUT-FIRST-NAME-REC  PIC X(15).
             05 OUT-EXTENSION-REC   PIC X(10).
             05 OUT-ZIP-CODE-REC    PIC X(7).
             05 FILLER              PICTURE X(40).
