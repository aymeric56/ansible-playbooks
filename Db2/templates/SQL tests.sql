/*****************************************************/
/* Table Contacts pour le schéma PHONEBOOK           */
/*****************************************************/

SELECT * FROM PHONEBOOK.CONTACTS;

SELECT LASTNAME,
       FIRSTNAME,
       PHONE,
       ZIPCODE FROM PHONEBOOK.CONTACTS;


DELETE FROM PHONEBOOK.CONTACTS WHERE FIRSTNAME = 'null';

/*****************************************************/
/* Table Contacts pour le schéma HACKATHON           */
/*****************************************************/

SELECT * FROM HACKATHON.CONTACTS;

SELECT LASTNAME,
       FIRSTNAME,
       PHONE,
       ZIPCODE,
       EMAIL FROM HACKATHON.CONTACTS;

INSERT INTO HACKATHON.CONTACTS  (
                LASTNAME,
                FIRSTNAME,
                PHONE,
                ZIPCODE,
                EMAIL)
                VALUES (
                'AFFOUARD',
                'AYMERIC',
                '0605040302',
                '34000',
                'aymeric@gmail.com');



SELECT * FROM TELECOMN.TYPEEVT;
SELECT * FROM TELECOMN.LIEU;