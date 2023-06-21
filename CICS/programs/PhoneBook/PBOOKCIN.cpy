

      ******************************************************************
      *    INPUT Container
      ******************************************************************

      * DATA AREA FOR TRANSACTION INPUT
       05  messageInput.
           10  command            PIC X(8).
           10  contact.
               15  lastName       PIC X(10).
               15  firstName      PIC X(10).
               15  telExtension   PIC X(10).
               15  zipCode        PIC X(7).
