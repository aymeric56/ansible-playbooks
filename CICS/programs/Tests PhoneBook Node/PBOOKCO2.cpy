

      ******************************************************************
      *    OUTPUT Container 2
      ******************************************************************

      * DATA AREA FOR TRANSACTION OUTPUT
       05  messageOutput2.
           10  responseMessage          PIC X(40).
           10  command                  PIC X(8).
           10  numberOfContacts         PIC S9(3).
           10  contacts-50           OCCURS 50 TIMES
                                     INDEXED BY OUT-REC-IDX.
               15  lastName             PIC X(10).
               15  firstName            PIC X(10).
               15  telExtension         PIC X(10).
               15  zipCode              PIC X(7).
