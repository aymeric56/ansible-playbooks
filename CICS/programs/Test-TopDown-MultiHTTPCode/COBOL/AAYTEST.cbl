       CBL CICS('COBOL3') APOST
       IDENTIFICATION DIVISION.
       PROGRAM-ID. AAYTEST.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *----------------------------------------------------------------*
      * Common defintions                                              *
      *----------------------------------------------------------------*

      * Working variables
       01 WORKING-VARIABLES.
           03 WS-RESP                  PIC S9(8) COMP.
           03 WS-RETURN-CODE           PIC S9(8) COMP.
           03 DISP-SQLCODE             PIC +ZZZZZZZZ9.
           03 KeyLastname              PIC X(10).
           03 UserID                   PIC X(8).

      * Variables used with Db2 for table contacts
       01  CONTACT-DETAILS.
           03 C-Lastname                   PIC X(10).
           03 C-Firstname                  PIC X(10).
           03 C-Phone                      PIC X(10).
           03 C-zipCode                    PIC X(7).

       01 NUMTOSTRING.
          05 NUMTOSTRINGX           PIC X(2).
          05 NUMTOSTRING9 REDEFINES NUMTOSTRINGX
                                    PIC 9(2).
      * Data structures to hold the input and output data
      * Due to copy books containing 'SYNC' members must be held
      * individually with an 01 level structure to ensure they are
      * aligned on a double word boundry
       COPY API56Q01.
       COPY API56P01.

       01  W-CHANNEL-NAME        PIC X(16) VALUE SPACES. 
       01  W-BAQBASE-CONT-NAME   PIC X(16) VALUE 'BAQBASE'. 
       01  W-RESPONSE-CONT-NAME  PIC X(16) VALUE 'BAQBASE-RESPONSE'.  
       01  WS-API-INFO        USAGE POINTER VALUE NULL.

      * Data Area name to get
       01 WS-DATA-AREA-NAME  PIC X(16).

      * The address of a returned Data Area Element
       01 WS-ELEMENT         USAGE POINTER VALUE NULL.

      * Length of element for BAQGETN call.
       01 WS-ELEMENT-LENGTH  PIC 9(9) COMP-5.

      * Prepare to print messages to the log
       01 WS-FAIL-TYPE       PIC X(18) VALUE SPACES.
       01 WS-CC9             PIC 9(5).
       01 WS-RC9             PIC 9(5).
       01 WS-ST9             PIC 9(5).

      * Display this message to CICS log
       01 WS-DISPLAY-MSG     PIC X(78) VALUE ALL SPACES.

      ******************************************************************
      *    L I N K A G E   S E C T I O N
      ******************************************************************
       LINKAGE SECTION.

      ******************************************************************
      *    P R O C E D U R E S
      ******************************************************************
       PROCEDURE DIVISION.

      *----------------------------------------------------------------*
       MAINLINE SECTION.

      *---------------------------------------------------------------*
      * Get the input data from the supplied container                *
      *---------------------------------------------------------------*
           DISPLAY EIBTRNID ' Je suis au début de AAYTEST'
           INITIALIZE BAQBASE-API00Q01

           EXEC CICS                                                            
              ASSIGN CHANNEL(W-CHANNEL-NAME)                                    
           END-EXEC 
           
           EXEC CICS GET CONTAINER(W-BAQBASE-CONT-NAME)
                    CHANNEL(W-CHANNEL-NAME)
                    INTO(BAQBASE-API00Q01)
                    RESP(WS-RESP)
           END-EXEC
           
           IF WS-RESP NOT EQUAL DFHRESP(NORMAL)
               DISPLAY 'Je suis dans GET Container probleme'
               EXEC CICS RETURN END-EXEC
           END-IF

      *---------------------------------------------------------------*
      * On regarde quelle action est demandee                         *
      *---------------------------------------------------------------*
           INITIALIZE BAQBASE-API00P01
           INITIALIZE API00P01-responseCode200
           INITIALIZE API00P01-responseCode404
           INITIALIZE API00P01-responseCode500
           INITIALIZE WORKING-VARIABLES
           INITIALIZE CONTACT-DETAILS

           DISPLAY "W-Channel : " W-CHANNEL-NAME 
           DISPLAY "codeReponse : " codeReponse "FIN"
           DISPLAY "lastName : " lastName of BAQBASE-API00Q01  

           EVALUATE codeReponse
               WHEN '200'
      *        Call routine to perform
                   PERFORM DISPLAY-CONTACT

               WHEN '404'
      *        Call routine to perform
                   PERFORM UPDATE-CONTACT

               WHEN '500'
      *        Call routine to perform
                   PERFORM DELETE-CONTACT

               WHEN OTHER
      *        Request is not recognised or supported
                   PERFORM REQUEST-NOT-RECOGNISED

           END-EVALUATE

      * Return to caller
           EXEC CICS RETURN END-EXEC.

      *----------------------------------------------------------------*
      * On recherche 1 contact                                         *
      *----------------------------------------------------------------*
       DISPLAY-CONTACT SECTION.
           DISPLAY "Dans Display-Contact pour un 200"

      * Start to work
           MOVE codeReponse TO zipCode2 of responseCode200
           MOVE 1 to zipCode-existence of responseCode200
           MOVE 3 TO zipCode2-length OF responseCode200

      * Put the response in a container on the channel
           MOVE 1 to responseCode200-existence
           MOVE W-RESPONSE-CONT-NAME to responseCode200-cont

           MOVE 1 to  lastName-existence of responseCode200
           MOVE 'OUIOUIOUI' to lastName2 of responseCode200
           MOVE 10   to lastName2-length of responseCode200

           MOVE 0 to firstName-existence of responseCode200
           MOVE 0 to telExtension-existence of responseCode200
           MOVE 0 to Xid-existence of responseCode200

      * Update the BAQBASE container with the results
           EXEC CICS PUT CONTAINER(W-BAQBASE-CONT-NAME)
                         CHANNEL(W-CHANNEL-NAME)
                         FROM(BAQBASE-API00P01)
                         FLENGTH(LENGTH OF BAQBASE-API00P01)
                         RESP(WS-RESP)
                         BIT
           END-EXEC

           EXEC CICS PUT CONTAINER(W-RESPONSE-CONT-NAME)
                         CHANNEL(W-CHANNEL-NAME)
                         FROM(API00P01-responseCode200)
                         FLENGTH(LENGTH OF API00P01-responseCode200)
                         RESP(WS-RESP)
                         BIT
           END-EXEC
           DISPLAY 'Je suis après le container reponse'
           DISPLAY 'WS-RESP' WS-RESP 

           EXIT.

      *----------------------------------------------------------------*
      * On update 1 contact                                            *
      *----------------------------------------------------------------*
       UPDATE-CONTACT SECTION.
           DISPLAY "Dans Update-Contact on simule le 404"

      * Start to work
           MOVE codeReponse TO zipCode of responseCode404
           MOVE 1 to zipCode2-existence of responseCode404
           MOVE 3 TO zipCode-length OF responseCode404

      * Put the response in a container on the channel
           MOVE 1 to responseCode404-existence
           MOVE W-RESPONSE-CONT-NAME to responseCode404-cont
           MOVE 0 to responseCode200-existence
           MOVE 0 to responseCode500-existence

           MOVE 1 to  lastName2-existence of responseCode404
           MOVE 'OUIOUI404' to lastName of responseCode404
           MOVE 10   to lastName-length of responseCode404

           MOVE 0 to firstName2-existence of responseCode404
           MOVE 0 to telExtension2-existence IN responseCode404 
           MOVE 0 to id2-existence IN responseCode404 

      * Update the BAQBASE container with the results
           EXEC CICS PUT CONTAINER(W-BAQBASE-CONT-NAME)
                         CHANNEL(W-CHANNEL-NAME)
                         FROM(BAQBASE-API00P01)
                         FLENGTH(LENGTH OF BAQBASE-API00P01)
                         RESP(WS-RESP)
                         BIT
           END-EXEC
           DISPLAY 'WS-RESP' WS-RESP

           EXEC CICS PUT CONTAINER(W-RESPONSE-CONT-NAME)
                         CHANNEL(W-CHANNEL-NAME)
                         FROM(API00P01-responseCode404)
                         FLENGTH(LENGTH OF API00P01-responseCode404)
                         RESP(WS-RESP)
           END-EXEC
           DISPLAY 'Je suis après le container reponse 404'
           DISPLAY 'WS-RESP' WS-RESP 


           EXIT.

      *----------------------------------------------------------------*
      * On delete 1 contact                                            *
      *----------------------------------------------------------------*
       DELETE-CONTACT SECTION.
           DISPLAY "Dans Delete-Contact"
           EXIT.


      *----------------------------------------------------------------*
      * On signale que la commande in-command est inconnue             *
      *----------------------------------------------------------------*
       REQUEST-NOT-RECOGNISED SECTION.
           DISPLAY "Dans Request Not Recognised"
           DISPLAY "codeReponse : " codeReponse
      * Start to work
           MOVE codeReponse TO zipCode of responseCode404
           MOVE 1 to zipCode2-existence of responseCode404
           MOVE 3 TO zipCode-length OF responseCode404

      * Put the response in a container on the channel
           MOVE 1 to responseCode404-existence
           MOVE W-RESPONSE-CONT-NAME to responseCode404-cont

           MOVE 1 to lastName2-existence of responseCode404
           MOVE 'OUIOUIOUI' to lastName of responseCode404
           MOVE LENGTH OF lastName of responseCode404
                          to lastName-length of responseCode404

      * Update the BAQBASE container with the results
           EXEC CICS PUT CONTAINER(W-BAQBASE-CONT-NAME)
                         CHANNEL(W-CHANNEL-NAME)
                         FROM(BAQBASE-API00P01)
                         FLENGTH(LENGTH OF BAQBASE-API00P01)
                         RESP(WS-RESP)
                         BIT
           END-EXEC

           EXEC CICS PUT CONTAINER(W-RESPONSE-CONT-NAME)
                         CHANNEL(W-CHANNEL-NAME)
                         FROM(API00P01-responseCode200)
                         RESP(WS-RESP)
           END-EXEC
           DISPLAY 'Je suis après le container reponse'
           DISPLAY 'WS-RESP' WS-RESP 
      * Exit to send the response
           EXIT.

