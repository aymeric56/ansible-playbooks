       IDENTIFICATION DIVISION.
       PROGRAM-ID. WHSPEAPI.
      *AUTHOR. ELENA.
      *DATE-WRITTEN.  SEPT 2023.
      **********************************************************
      *                                                        *
      *           SERVICIO API  TEST                           *
      *                                                        *
      *   CODE TRANSACTION  : MAPI                             *
      *                                                        *
      *                                                        *
      *                                                        *
      **********************************************************
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-370 WITH DEBUGGING MODE.
       OBJECT-COMPUTER. IBM-370.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
      *
      * BEGIN WORKING WEB SERVICES
      *
      *----------------------------------------------------------------*
      * Common defintions                                              *
      *----------------------------------------------------------------*

        01 WS-COMMAREA.
           03 WS-PAYS                  PIC X(2).
           03 WS-TRANS                 PIC X(4).
           03 WS-CODOPE                PIC X(2).
           03 WS-CONTRACT              PIC 9(11).
           03 WS-REST                  PIC 9(11).
           03 ErrorCode                PIC X(2).

      * Working variables
       01 WORKING-VARIABLES.
          05 INFORMATION              PIC X(01).
             88 INF-FOUND             VALUE 'Y'.
             88 INF-NOT-FOUND         VALUE 'N'.
          05 CHECK-IND                PIC X(01) value 'N'.
             88 CHECK-OK              VALUE 'Y'.
             88 CHECK-KO              VALUE 'N'.

          05 WS-LENGTH                PIC S9(8) COMP.
          05 CICS-PROGRAM             PIC X(08) VALUE SPACES.
          05 RESP                     PIC S9(8) COMP-5 SYNC.
          05 RESP2                    PIC S9(8) COMP-5 SYNC.

      *----------------------------------------------------------------*
      *                DECLARATION DES HOST-VARIABLES                  *
      *----------------------------------------------------------------*
       01  FILLER                      PIC X(13) VALUE 'WORKING STRGE'.

      *----------------------------------------------------------------*
      *///*    Description des parametres fixes pour EXEC CICS     *///*
      *----------------------------------------------------------------*

      * COPY CCICSRET.

      * COPY DFHAID.

      *--------------------
       LINKAGE SECTION.
      *--------------------
        01 DFHCOMMAREA.
           03 WS-PAYS                  PIC X(2).
           03 WS-TRANS                 PIC X(4).
           03 WS-CODOPE                PIC X(2).
           03 WS-CONTRACT              PIC 9(11).
           03 WS-REST                  PIC 9(11).
           03 ErrorCode                PIC X(2).

      *--------------------
       PROCEDURE DIVISION.
      *--------------------

      *DECLARATIVES.
      *READY-TRACE SECTION.
      *    USE FOR DEBUGGING ON ALL PROCEDURES.
      *    DISPLAY '<WHSPEA0 -V1.1> ' DEBUG-ITEM.
      *END DECLARATIVES.

      *----------------------------------------------------------------*
       Mainline section.
      *---------------------------------------------------------------*
      * initialize working storage variables
      *---------------------------------------------------------------*
           display 'START WHSPEAPI'
      *---------------------------------------------------------------*
      * Check commarea and obtain required details                    *
      *---------------------------------------------------------------*
      * If NO commarea received issue an ABEND
           IF EIBCALEN IS EQUAL TO ZERO
               MOVE 'NOCA' TO WS-TRANS of DFHCOMMAREA 
               EXEC CICS ABEND ABCODE('EXCA') NODUMP END-EXEC
           END-IF

      * Initalize commarea return code to zero
           MOVE '00' TO ErrorCode of DFHCOMMAREA 

      *---------------------------------------------------------------*
      * Start of program                                              *
      *---------------------------------------------------------------*
           display 'WS-PAYS     = '  WS-PAYS OF DFHCOMMAREA
           display 'WS-TRANS    = '  WS-TRANS OF DFHCOMMAREA
           display 'WS-CODOPE   = '  WS-CODOPE OF DFHCOMMAREA

           PerFOrm init-vbles


           DISPLAY 'END WHSPEAPI'
      * Return to caller

           EXEC CICS RETURN END-EXEC.
      *
           GOBACK.
      *---------------------------------------------------------------*
      *=============
       init-vbles.
      *=============
      *    Initialize WS-COMMAREA.

           MOVE   1200            TO WS-CONTRACT  OF DFHCOMMAREA
           MOVE   1400            TO WS-REST  OF DFHCOMMAREA
           MOVE   '30'            TO ErrorCode OF DFHCOMMAREA.
           display 'WS-CONTRACT  = '  WS-CONTRACT OF DFHCOMMAREA
           display 'WS-REST       = '  WS-REST OF DFHCOMMAREA
           DISPLAY 'ERRORCODE  = '  ErrorCode OF DFHCOMMAREA
           .
      *