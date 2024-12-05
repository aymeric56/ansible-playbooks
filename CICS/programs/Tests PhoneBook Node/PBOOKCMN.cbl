       CBL CICS('COBOL3') APOST
      *****************************************************************
      *                                                               *
      *  MODULE NAME = PBOOKCMN                                       *
      *                                                               *
      *  DESCRIPTIVE NAME = CICS TS  (Samples) Example Application -  *
      *                     Phone Book Program                        *
      *                                                               *
      *                                                               *
      *  STATUS = 1.0.0                                               *
      *                                                               *
      *  TRANSACTION NAME = n/a                                       *
      *                                                               *
      *  FUNCTION =                                                   *
      *  This module is the controller for the PhoneBook application, *
      *  all requests pass through this module                        *
      *                                                               *
      *-------------------------------------------------------------  *
      *                                                               *
      *  ENTRY POINT = PBOOKCMN                                       *
      *                                                               *
      *-------------------------------------------------------------  *
      *                                                               *
      *  CHANGE ACTIVITY :                                            *
      *                                                               *
      *  2023/02/20 Creation (Aymeric Affouard)                       *
      *                                                               *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PBOOKCMN.
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

      * Program Names to LINK to
       01 WS-PROGRAM-NAMES.
           03  FILLER                      PIC X(8)  VALUE 'HHHHHHHH'.
           03  WS-DATASTORE-PROG           PIC X(8).
           03  WS-DISPATCH-PROG            PIC X(8).
           03  WS-STOCKMANAGER-PROG        PIC X(8).

      * Data structures to hold the input and output data
      * Due to copy books containing 'SYNC' members must be held
      * individually with an 01 level structure to ensure they are
      * aligned on a double word boundry
       01 CONTAINER-PBOOK-INPUT.
           COPY PBOOKCIN.
       01 CONTAINER-PBOOK-OUTPUT1.
           COPY PBOOKCO1.
       01 CONTAINER-PBOOK-OUTPUT2.
           COPY PBOOKCO2.

      *----------------------------------------------------------------*

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

      *----------------------------------------------------------------*
      * Common code                                                    *
      *----------------------------------------------------------------*

      *---------------------------------------------------------------*
      * Get the input data from the supplied container                *
      *---------------------------------------------------------------*

           EXEC CICS GET CONTAINER('PBOOK-INPUT')
      *              CHANNEL('PBOOK-CHANNEL')
                    INTO(messageInput)
                    RESP(WS-RESP)
           END-EXEC

           IF WS-RESP NOT EQUAL DFHRESP(NORMAL)

      *        Set up the Error message for the response
               MOVE 'App Internal Error: Get Container'
                   TO responseMessage OF messageOutput1
      *        Put the response in a container on the channel
               EXEC CICS PUT CONTAINER('PBOOK-OUTPUT1')
                        FROM(messageOutput1)
               END-EXEC
      *        Return to the web service layer to send the response
               EXEC CICS RETURN END-EXEC
           END-IF

      *---------------------------------------------------------------*
      * On regarde quelle action est demand©e                         *
      *---------------------------------------------------------------*
           MOVE FUNCTION UPPER-CASE(command OF messageInput)
                 TO command OF messageInput

           EVALUATE command OF messageInput
               WHEN 'DISPLAY'
               WHEN 'UPDATE'
               WHEN 'DELETE'
               WHEN 'CREATE'
               WHEN 'SHOW-50'
                   PERFORM PHONEBOOK-SUBPROG
               WHEN OTHER
      *        Request is not recognised or supported
                   PERFORM REQUEST-NOT-RECOGNISED
           END-EVALUATE

      * Return to caller
           EXEC CICS RETURN END-EXEC.

       PHONEBOOK-SUBPROG.
      *     MOVE command OF messageInput TO command OF messageOutput1
      *     MOVE 'on passe dans Display'
      *          TO responseMessage OF messageOutput1
      *     EXEC CICS PUT CONTAINER('PBOOK-OUTPUT1')
      *              FROM(messageOutput1)
      *     END-EXEC
           EXEC CICS LINK   PROGRAM('PBOOKDB2')
                            CHANNEL('JSONCHANNEL')
           END-EXEC
           EXIT.

       REQUEST-NOT-RECOGNISED.
      * Start to work
           MOVE command of messageInput TO command of messageOutput1
           MOVE 'action non reconnue'
                TO responseMessage OF messageOutput1
      * Put the response in a container on the channel
           EXEC CICS PUT CONTAINER('PBOOK-OUTPUT1')
                    FROM(messageOutput1)
           END-EXEC
      * Exit to send the response
           EXIT.
