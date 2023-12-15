//
//IVTN2DDL   JOB 0,'JULIA CHEVALIER',                                   
//             NOTIFY=&SYSUID.,CLASS=W,MSGCLASS=H                       
//*                                                                     
//             SET SYS=DBC1,DB2PREF=DBC0CFG,DB2=DB2.V12
//*                                                                     
//*
//*
//DDL      PROC
//DDL      EXEC PGM=IKJEFT01,DYNAMNBR=20                                
//STEPLIB   DD DSN=&DB2PREF..&DB2..SDSNLOAD,DISP=SHR                    
//          DD DISP=SHR,DSN=&DB2PREF..&DB2..SDSNEXIT                    
//SYSTSPRT  DD SYSOUT=*                                                 
//SYSTSIN   DD DISP=(SHR,PASS),DSN=*.GENER.SYSLIN                       
//SYSPRINT  DD SYSOUT=*                                                 
//         PEND
//*
//*
//*
//GENER    EXEC PGM=ASMA90,REGION=0K,PARM='OBJ,NODECK,SYSPARM(&SYS.)'
//SYSLIB    DD DSN=SYS1.MACLIB,DISP=SHR
//SYSLIN    DD UNIT=SYSDA,DISP=(,PASS),
//             SPACE=(TRK,(1,1),RLSE),RECFM=FB,LRECL=80
//SYSUT1    DD UNIT=SYSDA,SPACE=(CYL,(1,1))
//SYSPRINT  DD SYSOUT=*
//SYSIN     DD *
 PUNCH ' DSN SYSTEM(&SYSPARM.)'
 PUNCH ' RUN  PROGRAM(DSNTIAD) PLAN(DSNTIA12) -'
 PUNCH '      LIB(''DBC0CFG.RUNLIB.LOAD'')'
 END
//********************************************************************* 
//*                                                                     
//*        STEP  1: CREATE SAMPLE STORAGE GROUPS, TABLESPACES           
//*                                                                     
//********************************************************************* 
//         IF RC <= 4 THEN
//STEP1    EXEC DDL                                                     
//SYSIN     DD *                                                        
  CREATE DATABASE BILLDB                                                
    STOGROUP SYSDEFLT                                                   
    BUFFERPOOL BP0                                                      
    CCSID EBCDIC;                                                       

  CREATE TABLESPACE BILLTS                                              
    IN BILLDB                                                           
    USING STOGROUP SYSDEFLT                                             
              PRIQTY 20                                                 
              SECQTY 20                                                 
              ERASE NO                                                  
    LOCKSIZE PAGE LOCKMAX SYSTEM                                        
    BUFFERPOOL BP0                                                      
    CLOSE NO                                                            
    CCSID EBCDIC;                                                       
                                                                        
  COMMIT ;                                                              
//         ENDIF
//*                                                                     
//*        STEP  2: CREATE SAMPLE TABLES                                
//*                                                                     
//         IF RC <= 4 THEN
//STEP2    EXEC DDL                                                     
//*   DROP TABLE TELECOMN.TYPEEVT;
//SYSIN     DD  *                                                       
                                               
  CREATE TABLE TELECOMN.TYPEEVT                                         
      (ID_TYPE INTEGER NOT NULL,                              
       DESCRIPTION CHAR(30),
       constraint DESCRIPTION_CHK
            CHECK (DESCRIPTION IN ('Concert', 'Football', 'Rugby')),     
       PRIMARY KEY(ID_TYPE))                                  
       IN BILLDB.BILLTS                                               
       CCSID EBCDIC;                                                  

  CREATE UNIQUE INDEX TELECOMN.TYPEEVTI
        ON TELECOMN.TYPEEVT
            (ID_TYPE ASC)
        USING STOGROUP SYSDEFLT
                  PRIQTY 12
                  ERASE NO
        BUFFERPOOL BP0
        CLOSE NO;

  CREATE TABLE TELECOMN.EVENT                                           
          (ID INTEGER NOT NULL,                                   
            TYPE INTEGER,                                          
            DESCRIPTION CHAR(30),                                  
            DATE_DEBUT DATE,                                       
            DATE_FIN DATE,                                         
            HEURE_DEBUT TIME,                                      
            HEURE_FIN TIME,                                        
            PRIMARY KEY(ID),                                       
            FOREIGN KEY(TYPE) REFERENCES TELECOMN.TYPEEVT(ID_TYPE))         
         IN BILLDB.BILLTS                                               
         CCSID EBCDIC;

  CREATE UNIQUE INDEX TELECOMN.EVENTI
        ON TELECOMN.EVENT
            (ID ASC)
        USING STOGROUP SYSDEFLT
                  PRIQTY 12
                  ERASE NO
        BUFFERPOOL BP0
        CLOSE NO;

  COMMIT ;    
/*                                                          
//         ENDIF
//*                                                                  
//*        STEP  3: GRANT AUTHORITY                                     
//*                                                                     
//         IF RC <= 4 THEN
//STEP3    EXEC DDL                                                     
//SYSIN     DD  *                                                       
  GRANT DBADM ON DATABASE BILLDB TO PUBLIC;                             
  GRANT USE OF TABLESPACE BILLDB.BILLTS TO PUBLIC;                      
  GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE TELECOMN.TYPEEVT        
        TO PUBLIC;                                                      
  GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE TELECOMN.EVENT          
        TO PUBLIC;
/*
//         ENDIF
//*                                                                     
//*                                                                     
//*        STEP  4: LOAD DATA INTO SAMPLE PROGRAM TABLES                
//*                                                                     
         IF RC <= 4 THEN
//STEP4    EXEC DSNUPROC,                                               
//             SYSTEM=&SYS,LIB=&DB2PREF..&DB2..SDSNLOAD
//SORTOUT   DD UNIT=SYSDA,SPACE=(CYL,(5,5))
//SYSUT1    DD UNIT=SYSDA,SPACE=(CYL,(5,5))
//SYSIN     DD  *                                                       
  LOAD DATA INDDN(SAMPLE)                                              
       INTO TABLE TELECOMN.TYPEEVT                                      
            (ID_TYPE     POSITION(1) INTEGER EXTERNAL(1),                       
             DESCRIPTION POSITION(2) CHAR(30))                          
       SORTDEVT SYSDA SORTNUM 4                                         
//SAMPLE   DD *                                                        
1Concert
2Football
3Rugby
/*
         ENDIF
//*
