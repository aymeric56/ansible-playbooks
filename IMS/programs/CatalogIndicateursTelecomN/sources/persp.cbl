       IDENTIFICATION DIVISION.
       PROGRAM-ID. PERSP.

      ******************************************************************

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

      * MESSAGE PROCESSING
       77 VALID-INPUT               PIC 9         VALUE 0.
       77 TERM-IO                   PIC 9         VALUE 0.
       77 TERM-LOOP                 PIC 9         VALUE 0.
       77 DISP-SQLCODE              PIC +ZZZZZZZZ9.

      ******************************************************************
      *Host variables
      ******************************************************************
       01 W-HOSTVAR-IMSVIP.
          05 W-PERSP-ID             PIC S9(10) COMP.
          05 W-PERSP-NAME           PIC X(150).
          05 W-PERSP-DES            PIC X(150).

           EXEC SQL INCLUDE SQLCA END-EXEC.

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

      *    POUR DISPLAY SQLCODE
       01  W-SQLCODE PIC S999.
       01  SQLCODE-POUR-DISPLAY PIC ----.

       LINKAGE SECTION.

       COPY PERSPCPY.

      *----------------------------------------------------------------*
      * PROCEDURE DIVISION FOR PERSPECTIVE CRUD OPERATIONS
      *----------------------------------------------------------------*
       PROCEDURE DIVISION USING ENTREE-SP SORTIE-SP.

       BEGIN.

               INITIALIZE SORTIE-SP
               MOVE SPACES TO SORTIE-SP

               DISPLAY "Dans PERSP !"

               EVALUATE INSP-COMMAND
                       WHEN 'PADD    '
                            PERFORM ADD-PERSPECTIVE
                       WHEN 'PDISPLAY'
                            PERFORM DISPLAY-PERSPECTIVE
                       WHEN 'PUPDATE '
                            PERFORM UPDATE-PERSPECTIVE
                       WHEN 'PDELETE '
                            PERFORM DELETE-PERSPECTIVE
                       WHEN OTHER
                            DISPLAY 'INVALID COMMAND RECEIVED:'
                                      INSP-COMMAND
               END-EVALUATE

           GOBACK
           .

      *----------------------------------------------------------------*
      * ADD-PERSPECTIVE PROCEDURE
      *----------------------------------------------------------------*
       ADD-PERSPECTIVE.

           DISPLAY "INSP-PERSP-NAME : " INSP-PERSP-NAME
           DISPLAY "INSP-PERSP-DES : " INSP-PERSP-DES

           MOVE INSP-PERSP-NAME TO W-PERSP-NAME
           MOVE INSP-PERSP-DES TO W-PERSP-DES

           EXEC SQL INSERT INTO PERSPECTIVE (
                      nom_perspective,
                      desc_perspective
                          )
                VALUES (
                      :W-PERSP-NAME,
                      :W-PERSP-DES
                      )
           END-EXEC

           DISPLAY "SQL code : " SQLCODE

           EVALUATE SQLCODE
           WHEN 0
                MOVE 'ADDED' TO OUTSP-MESSAGE
                MOVE INSP-RECORD-PERSP TO OUTSP-RECORD-PERSP
           WHEN +100
                MOVE 'ADD FAILED' TO OUTSP-MESSAGE
                PERFORM DISPLAY-SQL-CODE
           WHEN OTHER
                MOVE 'ADD FAILED' TO OUTSP-MESSAGE
                DISPLAY 'ERROR: BAD SQLCODE: ' SQLCODE
                PERFORM DISPLAY-SQL-CODE
           END-EVALUATE
           .

      *----------------------------------------------------------------*
      * DISPLAY-PERSPECTIVE PROCEDURE
      *----------------------------------------------------------------*
       DISPLAY-PERSPECTIVE.
           DISPLAY 'Je passe dans DISPLAY-PERSPECTIVE   '
           MOVE INSP-PERSP-ID TO W-PERSP-ID
           EXEC SQL SELECT id_perspective,
                           nom_perspective,
                           desc_perspective
                INTO :W-PERSP-ID,
                     :W-PERSP-NAME,
                     :W-PERSP-DES
                FROM PERSPECTIVE
                WHERE id_perspective = :W-PERSP-ID
           END-EXEC

           EVALUATE SQLCODE
           WHEN 0
                MOVE 'DISPLAYED' TO OUTSP-MESSAGE
                MOVE W-PERSP-ID TO OUTSP-PERSP-ID
                MOVE W-PERSP-NAME TO OUTSP-PERSP-NAME
                MOVE W-PERSP-DES TO OUTSP-PERSP-DES
           WHEN +100
                MOVE 'DISPLAY FAILED' TO OUTSP-MESSAGE
           WHEN OTHER
                MOVE 'DISPLAY FAILED' TO OUTSP-MESSAGE
                Perform DISPLAY-SQL-CODE
           END-EVALUATE


           .

      *----------------------------------------------------------------*
      * UPDATE-PERSPECTIVE PROCEDURE
      *----------------------------------------------------------------*
       UPDATE-PERSPECTIVE.
           MOVE INSP-PERSP-ID   TO W-PERSP-ID
           MOVE INSP-PERSP-NAME TO W-PERSP-NAME
           MOVE INSP-PERSP-DES  TO W-PERSP-DES

           EXEC SQL UPDATE PERSPECTIVE
                SET nom_perspective = :W-PERSP-NAME,
                    desc_perspective = :W-PERSP-DES
                WHERE id_perspective = :W-PERSP-ID
           END-EXEC

           EVALUATE SQLCODE
           WHEN 0
                MOVE 'UPDATED' TO OUTSP-MESSAGE
                MOVE INSP-RECORD-PERSP TO OUTSP-RECORD-PERSP
           WHEN +100
                MOVE 'UPDATE FAILED' TO OUTSP-MESSAGE
           WHEN OTHER
                MOVE 'UPDATE FAILED' TO OUTSP-MESSAGE
                DISPLAY 'ERROR: BAD SQLCODE: ' SQLCODE
           END-EVALUATE

           .

      *----------------------------------------------------------------*
      * DELETE-PERSPECTIVE PROCEDURE
      *----------------------------------------------------------------*
       DELETE-PERSPECTIVE.
           MOVE INSP-PERSP-ID TO W-PERSP-ID

           EXEC SQL DELETE FROM PERSPECTIVE
                WHERE id_perspective = :W-PERSP-ID
           END-EXEC

           EVALUATE SQLCODE
           WHEN 0
                MOVE 'DELETED' TO OUTSP-MESSAGE
           WHEN +100
                MOVE 'DELETE FAILED' TO OUTSP-MESSAGE
           WHEN OTHER
                MOVE 'DELETE FAILED' TO OUTSP-MESSAGE
                DISPLAY 'ERROR: BAD SQLCODE: ' SQLCODE
           END-EVALUATE

           .

      * Permet de récupérer plus d'informations sur l'erreur SQL
       DISPLAY-SQL-CODE.
           MOVE SQLCODE TO DISP-SQLCODE
           DISPLAY 'SQLCODE  : ' DISP-SQLCODE
           DISPLAY 'SQLSTATE : ' SQLSTATE
           DISPLAY 'SQLERRML : ' SQLERRML
           DISPLAY 'SQLERRMC : ' SQLERRMC
           .

       END PROGRAM PERSP.