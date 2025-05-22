       IDENTIFICATION DIVISION.
       PROGRAM-ID. CATALOG.

      ******************************************************************

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      * MESSAGE PROCESSING
       77 VALID-INPUT               PIC 9         VALUE 0.
       77 TERM-IO                   PIC 9         VALUE 0.
       77 TERM-LOOP                 PIC 9         VALUE 0.

      * LIST Sous Programmes
       77 C-PERSP                   PIC X(8) VALUE 'PERSP'.
       77 C-LEVIER                  PIC X(8) VALUE 'LEVIER'.
       77 C-OBJECTIF                PIC X(8) VALUE 'OBJECTIF'.
       77 C-INDICAT                 PIC X(8) VALUE 'INDICAT'.

      ******************************************************************
      *DATABASE CALL CODES
      ******************************************************************

       77 GU                        PIC  X(04)    VALUE "GU  ".
       77 GHU                       PIC  X(04)    VALUE "GHU ".
       77 GN                        PIC  X(04)    VALUE "GN  ".
       77 GHN                       PIC  X(04)    VALUE "GHN ".
       77 ISRT                      PIC  X(04)    VALUE "ISRT".
       77 DLET                      PIC  X(04)    VALUE "DLET".
       77 REPL                      PIC  X(04)    VALUE "REPL".
       77 NEXT-CALL                 PIC  X(04)    VALUE "    ".

      ******************************************************************
      *INPUT/OUTPUT MESSAGE AREA
      ******************************************************************

       COPY CATACPY2.

      ******************************************************************
      *INPUT/OUTPUT MESSAGE with sub programs
      ******************************************************************

       COPY PERSPCPY.

      *     EXEC SQL INCLUDE SQLCA END-EXEC.

      ******************************************************************
      *Host variables
      ******************************************************************
       01 W-HOSTVAR-IMSVIP.
          05 W-PERSP-ID             PIC S9(10) COMP.
          05 W-PERSP-NAME           PIC X(150).
          05 W-PERSP-DES            PIC X(150).

      * Pointer to API-INFO structure
       01 WS-API-INFO        USAGE POINTER VALUE NULL.

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

       LINKAGE SECTION.

       01 IOPCBA POINTER.
       01 ALTPCBA POINTER.

      ******************************************************************
      *I/O PCB
      ******************************************************************

       01 LTERMPCB.
          05 LOGTTERM               PIC  X(08).
          05 FILLER                 PIC  X(02).
          05 TPSTAT                 PIC  X(02).
             88 TPSTAT-OK                         VALUE SPACE.
             88 TPSTAT-NOMORE                     VALUE 'QC'.
             88 TPSTAT-EXIST                      VALUE 'CF'.
          05 IODATE                 PIC  X(04).
          05 IOTIME                 PIC  X(04).
          05 FILLER                 PIC  X(02).
          05 SEQNUM                 PIC  X(02).
          05 MOD                    PIC  X(08).

      ******************************************************************
      *ALTPCB
      ******************************************************************

       01 ALTPCB.
          05 LOGTTERM1              PIC  X(08).
          05 FILLER1                PIC  X(02).
          05 TPSTAT1                PIC  X(02).
          05 IODATE1                PIC  X(04).
          05 IOTIME1                PIC  X(04).
          05 FILLER1                PIC  X(02).
          05 SEQNUM1                PIC  X(02).
          05 MOD1                   PIC  X(08).




      *----------------------------------------------------------------*
      * PROCEDURE DIVISION FOR PERSPECTIVE CRUD OPERATIONS
      *----------------------------------------------------------------*
       PROCEDURE DIVISION.
           ENTRY "DLITCBL"
           USING IOPCBA
                 ALTPCBA
           .

       BEGIN.
           SET ADDRESS OF LTERMPCB TO ADDRESS OF IOPCBA
           MOVE 0 TO TERM-IO

           PERFORM WITH TEST BEFORE UNTIL TERM-IO = 1
               INITIALIZE INPUT-MSG-UNITAIRE
               INITIALIZE OUTPUT-MSG-UNITAIRE
               MOVE SPACES TO INPUT-MSG-UNITAIRE
               MOVE SPACES TO OUTPUT-MSG-UNITAIRE

               DISPLAY "Dans CATLOG 2 avant l'IOPCB !"

               CALL 'CBLTDLI' USING GU
                                    LTERMPCB
                                    INPUT-MSG-UNITAIRE

               DISPLAY 'In Command : ' IN-COMMAND
               DISPLAY 'Input Message : ' IN-PERSP-ID
                                                     of IN-RECORD-PERSP

               EVALUATE TRUE
               WHEN TPSTAT-OK
               WHEN TPSTAT-EXIST
      *              PERFORM VALIDATE-INPUT
                    IF VALID-INPUT = 0
                       EVALUATE IN-COMMAND(1:1)
                       WHEN 'P'
                            PERFORM SUB-PERSPECTIVE
                       WHEN 'O'
                            PERFORM DISPLAY-PERSPECTIVE
                       WHEN 'L'
                            PERFORM UPDATE-PERSPECTIVE
                       WHEN 'I'
                            PERFORM DELETE-PERSPECTIVE
                       WHEN OTHER
                            DISPLAY 'INVALID COMMAND RECEIVED:'
                                            IN-COMMAND
                       END-EVALUATE
                    ELSE
                        DISPLAY 'INVALID INPUT. SKIPPING OPERATION.'
                    END-IF
               WHEN TPSTAT-NOMORE
                    MOVE 1 TO TERM-IO
               WHEN OTHER
                    DISPLAY 'ERROR: ' TPSTAT
               END-EVALUATE

           END-PERFORM
           STOP RUN
           .

      *----------------------------------------------------------------*
      * ADD-PERSPECTIVE PROCEDURE
      *----------------------------------------------------------------*
       SUB-PERSPECTIVE.
           DISPLAY "Dans Sub Perspective"
           MOVE IN-COMMAND      to INSP-COMMAND
           MOVE IN-RECORD-PERSP to INSP-RECORD-PERSP

           CALL C-PERSP USING ENTREE-SP SORTIE-SP
           END-CALL

           MOVE OUTSP-MESSAGE to OUT-MESSAGE
           MOVE OUTSP-RECORD-PERSP to OUT-RECORD-PERSP
      *      MOVE "ADDED" to OUT-MESSAGE

           PERFORM INSERT-IO
           .

      *----------------------------------------------------------------*
      * DISPLAY-PERSPECTIVE PROCEDURE
      *----------------------------------------------------------------*
       DISPLAY-PERSPECTIVE.
           DISPLAY 'Je passe dans DISPLAY-PERSPECTIVE   '
           MOVE IN-PERSP-ID of IN-RECORD-PERSP TO W-PERSP-ID


           PERFORM INSERT-IO
           .

      *----------------------------------------------------------------*
      * UPDATE-PERSPECTIVE PROCEDURE
      *----------------------------------------------------------------*
       UPDATE-PERSPECTIVE.
           MOVE IN-PERSP-ID of IN-RECORD-PERSP TO W-PERSP-ID
           MOVE IN-PERSP-NAME of IN-RECORD-PERSP TO W-PERSP-NAME
           MOVE IN-PERSP-DES of IN-RECORD-PERSP TO W-PERSP-DES


      *     EXEC SQL
      *         SELECT MAX(id_perspective)
      *         INTO :W-PERSP-ID
      *         FROM PERSPECTIVE
      *     END-EXEC

           PERFORM INSERT-IO
           .

      *----------------------------------------------------------------*
      * DELETE-PERSPECTIVE PROCEDURE
      *----------------------------------------------------------------*
       DELETE-PERSPECTIVE.
           MOVE IN-PERSP-ID of IN-RECORD-PERSP TO W-PERSP-ID

           PERFORM INSERT-IO
           .


      * PROCEDURE INSERT-IO : INSERT FOR IOPCB REQUEST HANDLER

       INSERT-IO.
           COMPUTE OUT-LL of OUTPUT-MSG-UNITAIRE
                               = LENGTH OF OUTPUT-MSG-UNITAIRE
           MOVE 0 TO OUT-ZZ of OUTPUT-MSG-UNITAIRE
           CALL 'CBLTDLI' USING ISRT
                                LTERMPCB
                                OUTPUT-MSG-UNITAIRE

           IF TPSTAT NOT = SPACES
              DISPLAY 'INSERT TO IOPCB FAILED WITH STATUS CODE: '
                      TPSTAT
           END-IF
           .

       INSERT-IO-50.
           COMPUTE OUT-50-LL = LENGTH OF CAT-OUTPUT-MSG
           MOVE 0 TO OUT-50-ZZ
           CALL 'CBLTDLI' USING ISRT
                                LTERMPCB
                                CAT-OUTPUT-MSG

           IF TPSTAT NOT = SPACES
              DISPLAY 'INSERT TO IOPCB FAILED WITH STATUS CODE: '
                      TPSTAT
           END-IF
           .

       END PROGRAM CATALOG.