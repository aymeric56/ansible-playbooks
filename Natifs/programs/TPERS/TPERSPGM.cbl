      ****************************************************************
      * PROGRAMME DE TEST DB2 = SIMPLE SELECT DANS UNE TABLE DB2
      ****************************************************************
      * PROGRAM:  TPERSPGM
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TPERSPGM.
       ENVIRONMENT DIVISION.
      * INPUT-OUTPUT SECTION.
      * [OPTIONNEL]
      *
      * FILE-CONTROL.
      * [OPTIONNEL]
      *
      *****************************************************************
       DATA DIVISION.
      *
      * FILE SECTION.
      * [OPTIONNEL]
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
           05  H-CLE-ID-PERS    PIC S9(10) COMP.
           05  H-NOM            PIC X(64).
           05  H-PRENOM         PIC X(32).
           05  H-DATE-NAISS     PIC X(10).
           05  H-ADRESSE        PIC X(64).
           05  H-COD-POS-NAISS  PIC X(05).

       01  STATUT-TRAITEMENT    PIC X(02).
           88  ANOMALIE VALUE 'KO'.
           88  PAS-ANOMALIE VALUE 'OK'.
      *
      *    POUR DISPLAY SQLCODE
       01  W-SQLCODE PIC S999.
       01  SQLCODE-POUR-DISPLAY PIC ----.

      * VARIABLES DB2 D'ACCES A LA TABLE DB2 TPERS
           EXEC SQL
              DECLARE TPERS TABLE
              (
               TPERS_ID_PERS       CHAR(10) NOT NULL,
               TPERS_NOM           CHAR (64),
               TPERS_PRENOM        CHAR(32),
               TPERS_DATE_NAISS    DATE,
               TPERS_ADRESSE       CHAR(64),
               TPERS_COD_POS_NAISS CHAR(5)
              )
           END-EXEC.
           EXEC SQL
              DECLARE C01 CURSOR FOR
              SELECT
               ID_PERS,
               NOM,
               PRENOM,
               DATE_NAISS,
               ADRESSE,
               COD_POS_NAISS
              FROM TPERS
              WHERE ID_PERS >= :H-CLE-ID-PERS
              FOR FETCH ONLY
           END-EXEC.
       LINKAGE SECTION.
           COPY YESPERS.
      *
      *****************************************************************
       PROCEDURE DIVISION USING ENTREE SORTIE.
      *****************************************************************
      *     DISPLAY 'on est rentré'
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
      *
           MOVE 0 TO INDICE-TABLEAU
                     NB-POSTE-LISTE
      *
           .
      *
       TRAITEMENT.
           EVALUATE TRUE
           WHEN ACCESS-SELECT
              DISPLAY 'ACCES SELECT SIMPLE'
              PERFORM LECTURE-SIMPLE
           WHEN ACCESS-LIST
              EVALUATE TRUE
                 WHEN PREMIERE-LECTURE
                    PERFORM L01-PREMIERE-LECTURE
                 WHEN LECTURE-SUIVANTE
                    PERFORM L01-LECTURE-SUIVANTE UNTIL ANOMALIE
                                                 OR FIN-LISTE-ATTEINTE
                                                 OR  NB-POSTE-LISTE >= 5
                 WHEN FIN-LECTURE
                    PERFORM L01-FIN-LECTURE
              END-EVALUATE
           WHEN ACCESS-INSERT
              PERFORM INSERT-TPERS
           WHEN OTHER
              PERFORM TRT-ANOMALIE
           END-EVALUATE
           .
      *
      * PARAGRAPHE DE FIN DE PROGRAMME
       FIN.
           MOVE STATUT-TRAITEMENT TO CODE-RETOUR
           .
       LECTURE-SIMPLE.
      *
           MOVE CLE-ACCESS-LECTURE-SIM TO H-CLE-ID-PERS
      *
           PERFORM SELECT-DB2
           IF  SQLCODE = ZERO
      *       DISPLAY 'LECTURE SIMPLE OK'
              PERFORM RESTITUTION-LECTURE-SIMPLE
           ELSE
      *        DISPLAY 'LECTURE SIMPLE KO'
              PERFORM FORMATAGE-ERREUR-DB2
              PERFORM TRT-ANOMALIE
           END-IF
           .
      *
       INSERT-TPERS.
      *    RECHERCHE DE LA DERNIERE CLE PRESENTE EN TABLE
           EXEC SQL
               SELECT MAX(ID_PERS)
               INTO :H-CLE-ID-PERS
               FROM TPERS
           END-EXEC

             DISPLAY ' '     H-CLE-ID-PERS
           IF  SQLCODE = ZERO
      *       DISPLAY 'RECHERCHE DERNIERE CLE OK'
              ADD 1 TO H-CLE-ID-PERS
              PERFORM INSERTION-DB2
           ELSE
      *       DISPLAY 'RECHERCHE DERNIERE CLE KO'
              PERFORM FORMATAGE-ERREUR-DB2
              PERFORM TRT-ANOMALIE
           END-IF

           .
      *
       SELECT-DB2.
           EXEC SQL
               SELECT NOM,
                      PRENOM,
                      DATE_NAISS,
                      ADRESSE,
                      COD_POS_NAISS
               INTO
                      :H-NOM,
                      :H-PRENOM,
                      :H-DATE-NAISS,
                      :H-ADRESSE,
                      :H-COD-POS-NAISS
               FROM TPERS
               WHERE
                 ID_PERS = :H-CLE-ID-PERS
           END-EXEC
           .
       L01-PREMIERE-LECTURE.
      *
      *    DISPLAY 'ENTREE DANS LECTURE LISTE'
           MOVE CLE-ACCESS-LECTURE-LIS TO H-CLE-ID-PERS
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
                      :H-CLE-ID-PERS,
                      :H-NOM,
                      :H-PRENOM,
                      :H-DATE-NAISS,
                      :H-ADRESSE,
                      :H-COD-POS-NAISS
           END-EXEC
           EVALUATE SQLCODE
           WHEN ZERO
              SET LISTE-EN-COURS TO TRUE
              PERFORM  RESTITUTION-LECTURE-LISTE
           WHEN +100
              SET FIN-LISTE-ATTEINTE TO TRUE
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
       INSERTION-DB2.
           MOVE  I-NOM           TO H-NOM
           MOVE  I-PRENOM        TO H-PRENOM
           MOVE  I-DATE-NAISS    TO H-DATE-NAISS
           MOVE  I-ADRESSE       TO H-ADRESSE
           MOVE  I-COD-POS-NAISS TO H-COD-POS-NAISS
           EXEC SQL
	          INSERT INTO TPERS
           	(
                 ID_PERS,
     	       NOM,
    	            PRENOM,
  	            DATE_NAISS,
                 ADRESSE,
                 COD_POS_NAISS

               )
	          VALUES
               (
                 :H-CLE-ID-PERS,
                 :H-NOM,
                 :H-PRENOM,
                 :H-DATE-NAISS,
                 :H-ADRESSE,
                 :H-COD-POS-NAISS
               )
               END-EXEC


               IF  SQLCODE NOT = ZERO
                   DISPLAY 'INSERT ERROR '
                   DISPLAY  'ID:' H-CLE-ID-PERS
                        ' CPOST:' H-COD-POS-NAISS
                   PERFORM FORMATAGE-ERREUR-DB2
                   PERFORM TRT-ANOMALIE
               END-IF

           .
       RESTITUTION-LECTURE-SIMPLE.
           MOVE H-NOM          TO S-NOM
           MOVE H-PRENOM       TO S-PRENOM
           MOVE H-DATE-NAISS   TO S-DATE-NAISS
           MOVE H-ADRESSE      TO S-ADRESSE
           MOVE H-COD-POS-NAISS      TO S-COD-POS-NAISS
      *    DISPLAY 'DONNEES H DE SORTIE : ' HOST-VARIABLES
           .
       RESTITUTION-LECTURE-LISTE.
      *
      *    INCREMENTATION DE L'OCCURS DE TABLEAU POUR STOCKER
      *    SUR LE BON POSTE
           ADD 1 TO INDICE-TABLEAU
      *
           MOVE H-CLE-ID-PERS    TO T-CLE-ID-PERS(INDICE-TABLEAU)
           MOVE H-NOM            TO T-NOM(INDICE-TABLEAU)
           MOVE H-PRENOM         TO T-PRENOM(INDICE-TABLEAU)
           MOVE H-DATE-NAISS     TO T-DATE_NAISS (INDICE-TABLEAU)
           MOVE H-ADRESSE        TO T-ADRESSE(INDICE-TABLEAU)
           MOVE H-COD-POS-NAISS  TO T-COD-POS-NAISS (INDICE-TABLEAU)
      *
           MOVE INDICE-TABLEAU   TO NB-POSTE-LISTE
           .
