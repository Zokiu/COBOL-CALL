      ******************************************************************
      *                    IDENTIFICATION DIVISION
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. insrt.
       AUTHOR.     Terry.

      ******************************************************************
      *                      ENVIRONMENT DIVISION
      ******************************************************************
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.

      * SOURCE-COMPUTER. Zokiu WITH DEBUGGING MODE.

       

      ******************************************************************
      *                      DATA DIVISION
      ******************************************************************

       DATA DIVISION.
       

      ******************************************************************

       WORKING-STORAGE SECTION.


       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  WS-USER-NAME        PIC X(50).
       01  WS-USER-PASS        PIC X(50).
       EXEC SQL END DECLARE SECTION END-EXEC.


       EXEC SQL INCLUDE SQLCA END-EXEC.

      ******************************************************************
       LINKAGE SECTION.

       
       01  LK-USER-NAME        PIC X(50).
       01  LK-USER-PASS        PIC X(50).


      ******************************************************************
      *                    PROCEDURE DIVISION
      ******************************************************************    

       PROCEDURE DIVISION USING LK-USER-NAME LK-USER-PASS.

           MOVE LK-USER-NAME TO WS-USER-NAME.
           MOVE LK-USER-PASS TO WS-USER-PASS.

           EXEC SQL 
               INSERT INTO users (nom, password)
               VALUES (:WS-USER-NAME, :WS-USER-PASS)
           END-EXEC.

           IF SQLCODE = 0
               EXEC SQL COMMIT END-EXEC
               DISPLAY "Utilisateur ajouté"
               DISPLAY WS-USER-NAME
           ELSE
               DISPLAY "Erreur lors de l'ajout"
               DISPLAY "SQLCODE: " SQLCODE
               EXEC SQL ROLLBACK END-EXEC
           END-IF.

           MOVE WS-USER-NAME TO LK-USER-NAME.
           MOVE WS-USER-PASS TO LK-USER-PASS.

           END PROGRAM insrt.

