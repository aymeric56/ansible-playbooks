      *
       01  ENTREE PIC X(500).
       01  FILLER REDEFINES ENTREE.
           05  PARTIE-FIXE-ALLER.
               10  TYPE-ACCESS PIC X(01).
                   88  ACCESS-SELECT VALUE 'S'.
                   88  ACCESS-LIST   VALUE 'L'.
                   88  ACCESS-INSERT VALUE 'I'.
           05  PARTIE-VARIABLE-ALLER PIC X(499).
           05  ENTREE-FONCTION-LECTURE-SIMPLE REDEFINES
                PARTIE-VARIABLE-ALLER.
               10  CLE-ACCESS-LECTURE-SIM PIC 9(10).
           05 ENTREE-FONCTION-LECTURE-LISTE REDEFINES
              PARTIE-VARIABLE-ALLER.
              10  CLE-ACCESS-LECTURE-LIS PIC 9(10).
              10  CODE-FONCTION PIC X(05).
                  88  PREMIERE-LECTURE VALUE 'PLECT'.
                  88  LECTURE-SUIVANTE VALUE 'LSUIV'.
                  88  FIN-LECTURE      VALUE 'FLECT'.
           05  ENTREE-FONCTION-INSERT REDEFINES
                PARTIE-VARIABLE-ALLER.
               10  I-NOM               PIC X(64).
               10  I-PRENOM            PIC X(32).
               10  I-DATE-NAISS        PIC X(10).
               10  I-ADRESSE           PIC X(64).
               10  I-COD-POS-NAISS     PIC X(05).
      *
       01  SORTIE PIC X(1100).
       01  FILLER REDEFINES SORTIE.
           05  PARTIE-FIXE-RETOUR.
               10  CODE-RETOUR     PIC X(2).
                   88  RETOUR-OK   VALUE 'OK'.
                   88  RETOUR-KO   VALUE 'KO'.
               10  LIBELLE-ANOMALIE PIC X(98).
           05  PARTIE-VARIABLE-RETOUR    PIC X(1000).
           05  DONNEES-LECTURE-SIMPLE REDEFINES PARTIE-VARIABLE-RETOUR.
               10  S-NOM         PIC X(64).
               10  S-PRENOM      PIC X(32).
               10  S-DATE-NAISS  PIC X(10).
               10  S-ADRESSE     PIC X(64).
               10  S-COD-POS-NAISS     PIC X(05).
           05  DONNEES-LECTURE-LISTE REDEFINES PARTIE-VARIABLE-RETOUR.
               10  STATUT-SUITE    PIC X(10).
               88  FIN-LISTE-ATTEINTE  VALUE 'FIN LISTE '.
               88  LISTE-EN-COURS      VALUE 'LISTE ENCO'.
               10  NB-POSTE-LISTE  PIC 9(1).
               10  TABLEAU-DONNEES OCCURS 5.
                   15  T-CLE-ID-PERS       PIC 9(10).
                   15  T-NOM               PIC X(64).
                   15  T-PRENOM            PIC X(32).
                   15  T-DATE_NAISS        PIC X(10).
                   15  T-ADRESSE           PIC X(64).
                   15  T-COD-POS-NAISS     PIC X(05).
