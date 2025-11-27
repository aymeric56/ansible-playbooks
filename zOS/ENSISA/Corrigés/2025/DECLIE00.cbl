      ****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID DECLIE00.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-370.
       OBJECT-COMPUTER. IBM-370.
       SPECIAL-NAMES.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT FSYS020 ASSIGN TO UT-S-SYS020.
       DATA DIVISION.
       FILE SECTION.
       FD  FSYS020
           LABEL RECORD STANDARD
           RECORDING MODE IS F
           BLOCK 0 RECORDS.
       01  ENR-SYS020                             PIC X(210).
       WORKING-STORAGE SECTION.
      ******************************************************************
      * CONSTANTES DU PROGRAMME                                        *
      ******************************************************************

       COPY YESPERS.
       77  C-TPERSPGM                             PIC X(09)
                                                  VALUE 'TPERSPGM'.
       01  I-I                                    PIC 9(01).

       PROCEDURE DIVISION.

           OPEN OUTPUT FSYS020

           SET ACCESS-LIST                        TO TRUE
           SET PREMIERE-LECTURE                   TO TRUE

           PERFORM UNTIL FIN-LISTE-ATTEINTE OR RETOUR-KO

              CALL C-TPERSPGM USING ENTREE SORTIE
              END-CALL

              PERFORM VARYING I-I FROM 1 BY 1 UNTIL I-I > NB-POSTE-LISTE
                 MOVE TABLEAU-DONNEES(I-I) TO ENR-SYS020
                 WRITE ENR-SYS020
              END-PERFORM

              SET LECTURE-SUIVANTE                TO TRUE

           END-PERFORM

           SET  FIN-LECTURE                       TO TRUE
           CALL C-TPERSPGM USING ENTREE SORTIE
           END-CALL

           CLOSE FSYS020

           GOBACK
           .
