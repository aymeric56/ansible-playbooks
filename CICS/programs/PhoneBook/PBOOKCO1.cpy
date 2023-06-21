

      ******************************************************************
      *    OUTPUT Container 1
      ******************************************************************

      * DATA AREA FOR TRANSACTION OUTPUT
       05  messageOutput1.
           10  responseMessage    PIC X(40).
           10  command            PIC X(8).
           10  contact.
               15  lastName       PIC X(10).
               15  firstName      PIC X(10).
               15  telExtension   PIC X(10).
               15  zipCode        PIC X(7).

