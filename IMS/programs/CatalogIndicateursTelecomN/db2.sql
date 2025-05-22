select * from TELECOMN.PERSPECTIVE;
select * from TELECOMN.OBJECTIF;
select * from TELECOMN.LEVIER;
select * from TELECOMN.INDICATEUR;


SELECT id_perspective,
       nom_perspective,
       desc_perspective
    FROM TELECOMN.PERSPECTIVE
    WHERE id_perspective = 1;

/* la table PERSPECTIVE a la colonne ID_PERSPECTIVE qui est automatiquement populée */
INSERT INTO TELECOMN.PERSPECTIVE  (
                NOM_PERSPECTIVE,
                DESC_PERSPECTIVE
                )
                VALUES (
                'Perspective 2',
                'Perspective 2 de Test'
                );



DELETE FROM PHONEBOOK.CONTACTS WHERE FIRSTNAME ='null';