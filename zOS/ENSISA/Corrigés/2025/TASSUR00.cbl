      ****************************************************************
      * PROGRAMME DE TEST DB2 = SIMPLE SELECT DANS UNE TABLE DB2
      ****************************************************************
      * PROGRAM:  TASSUR00
      *
      * AUTHOR :  Stephane PAUCOT
      *
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TASSUR00.
       ENVIRONMENT DIVISION.
      * INPUT-OUTPUT SECTION.
      * íOPTIONNELù
      *
      * FILE-CONTROL.
      * íOPTIONNELù
      *
      *****************************************************************
       DATA DIVISION.
      *
      * FILE SECTION.
      * íOPTIONNELù
      *
      *****************************************************************
       WORKING-STORAGE SECTION.
      *****************************************************************
      *
       01  INDICE-TABLEAU PIC S9(3) COMP-3.
      *
      * VARIABLES DB2 SYSTEM
           EXEC SQL
              INCLUDE SQLCA
           END-EXEC.
      *
      * HOST VARIABLES PERMETTANT D'INTERFACER LE PROGRAMME
      *       AVEC LA TABLE
       01  HOST-VARIABLES.
           10  H-ID_ASSUR          PIC S9(9) COMP.
           10  H-ID_PERS           PIC S9(9) COMP.
           10  H-LIBELLE           PIC X(32).

       01  STATUT-TRAITEMENT    PIC X(02).
           88  ANOMALIE VALUE 'KO'.
           88  PAS-ANOMALIE VALUE 'OK'.
      *
      *    POUR DISPLAY SQLCODE
       01  W-SQLCODE PIC S999.
       01  SQLCODE-POUR-DISPLAY PIC ----.

      * VARIABLES DB2 D'ACCES A LA TABLE DB2 ASSURANCES
           EXEC SQL
              DECLARE C01 CURSOR FOR
              SELECT
               ID_ASSUR,
               ID_PERS,
               LIBELLE
              FROM ASSURANCES
              WHERE ID_PERS = :H-ID_PERS
              FOR FETCH ONLY
           END-EXEC.
       LINKAGE SECTION.
           COPY YESASSUR.
      *
      *****************************************************************
       PROCEDURE DIVISION USING ENTREE SORTIE.
      *****************************************************************
      *     DISPLAY 'on est rentre'
           PERFORM DEBUT
           PERFORM TRAITEMENT
           PERFORM FIN
           GOBACK
           .
      *
      * PARAGRAPHE DE DEBUT DE PROGRAMME
       DEBUT.
      *
           SET PAS-ANOMALIE TO TRUE
           SET LISTE-EN-COURS TO TRUE
      *
           MOVE 0 TO INDICE-TABLEAU
                     NB-POSTE-LISTE
      *
           .
      *
       TRAITEMENT.
           PERFORM L01-PREMIERE-LECTURE
           .
      *
      * PARAGRAPHE DE FIN DE PROGRAMME
       FIN.
           PERFORM L01-FIN-LECTURE
           MOVE STATUT-TRAITEMENT TO CODE-RETOUR
           .
      *
       L01-PREMIERE-LECTURE.
      *
      *    DISPLAY 'ENTREE DANS LECTURE LISTE'
           MOVE CLE-ACCESS-LECTURE-LIS TO H-ID_PERS
           DISPLAY 'Cl‚ ds TASSUR :' CLE-ACCESS-LECTURE-LIS
      *
           EXEC SQL
              OPEN C01
           END-EXEC
           IF  SQLCODE = ZERO
               PERFORM L01-LECTURE-SUIVANTE UNTIL ANOMALIE
                                        OR FIN-LISTE-ATTEINTE
                                        OR  NB-POSTE-LISTE >= 5
           ELSE
              PERFORM FORMATAGE-ERREUR-DB2
              PERFORM TRT-ANOMALIE
           END-IF
           .
       L01-LECTURE-SUIVANTE.
      *    DISPLAY 'LECTURE SUIVANTE'
           EXEC SQL
              FETCH C01
               INTO
                      :H-ID_ASSUR,
                      :H-ID_PERS,
                      :H-LIBELLE
           END-EXEC
           EVALUATE SQLCODE
           WHEN ZERO
              SET LISTE-EN-COURS TO TRUE
              DISPLAY 'WHEN ZERO:' H-ID_ASSUR
              PERFORM  RESTITUTION-LECTURE-LISTE
           WHEN +100
              SET FIN-LISTE-ATTEINTE TO TRUE
              DISPLAY 'WHEN +100:'
           WHEN OTHER
              PERFORM FORMATAGE-ERREUR-DB2
              PERFORM TRT-ANOMALIE
           END-EVALUATE
           .
       L01-FIN-LECTURE.
           EXEC SQL
              CLOSE C01
           END-EXEC
           IF  SQLCODE NOT = ZERO
               PERFORM FORMATAGE-ERREUR-DB2
               PERFORM TRT-ANOMALIE
           END-IF
           .
       FORMATAGE-ERREUR-DB2.
           MOVE SQLCODE TO W-SQLCODE
           MOVE W-SQLCODE TO SQLCODE-POUR-DISPLAY
           STRING 'ERREUR DB2 SQLCODE=' SQLCODE-POUR-DISPLAY ' '
                  SQLERRM DELIMITED BY SIZE INTO LIBELLE-ANOMALIE
           DISPLAY SQLCODE-POUR-DISPLAY
              ' ' SQLERRM ' '
           DISPLAY SQLERRD(2)
           .
       TRT-ANOMALIE.
      *     DISPLAY 'ANOMALIE DETECTEE'
      *
           SET ANOMALIE TO TRUE
           .
       RESTITUTION-LECTURE-LISTE.
      *
      *    INCREMENTATION DE L'OCCURS DE TABLEAU POUR STOCKER
      *    SUR LE BON POSTE
           ADD 1 TO INDICE-TABLEAU
      *
           MOVE H-ID_PERS        TO T-ID_PERS(INDICE-TABLEAU)
           MOVE H-ID_ASSUR       TO T-ID_ASSUR(INDICE-TABLEAU)
           MOVE H-LIBELLE        TO T-LIBELLE(INDICE-TABLEAU)

           MOVE INDICE-TABLEAU   TO NB-POSTE-LISTE
           .
