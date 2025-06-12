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


OCESQL*EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  WS-USER-NAME        PIC X(50).
       01  WS-USER-PASS        PIC X(50).
OCESQL*EXEC SQL END DECLARE SECTION END-EXEC.


OCESQL*EXEC SQL INCLUDE SQLCA END-EXEC.
OCESQL     copy "sqlca.cbl".

      ******************************************************************
OCESQL*
OCESQL 01  SQ0001.
OCESQL     02  FILLER PIC X(051) VALUE "INSERT INTO users (nom, passwo"
OCESQL  &  "rd) VALUES ( $1, $2 )".
OCESQL     02  FILLER PIC X(1) VALUE X"00".
OCESQL*
       LINKAGE SECTION.

       
       01  LK-USER-NAME        PIC X(50).
       01  LK-USER-PASS        PIC X(50).


      ******************************************************************
      *                    PROCEDURE DIVISION
      ******************************************************************    

       PROCEDURE DIVISION USING LK-USER-NAME LK-USER-PASS.

           MOVE LK-USER-NAME TO WS-USER-NAME.
           MOVE LK-USER-PASS TO WS-USER-PASS.

OCESQL*    EXEC SQL 
OCESQL*        INSERT INTO users (nom, password)
OCESQL*        VALUES (:WS-USER-NAME, :WS-USER-PASS)
OCESQL*    END-EXEC.
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 50
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE WS-USER-NAME
OCESQL     END-CALL
OCESQL     CALL "OCESQLSetSQLParams" USING
OCESQL          BY VALUE 16
OCESQL          BY VALUE 50
OCESQL          BY VALUE 0
OCESQL          BY REFERENCE WS-USER-PASS
OCESQL     END-CALL
OCESQL     CALL "OCESQLExecParams" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE SQ0001
OCESQL          BY VALUE 2
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL.

           IF SQLCODE = 0
OCESQL*        EXEC SQL COMMIT END-EXEC
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE "COMMIT" & x"00"
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL
               DISPLAY "Utilisateur ajouté"
               DISPLAY WS-USER-NAME
           ELSE
               DISPLAY "Erreur lors de l'ajout"
               DISPLAY "SQLCODE: " SQLCODE
OCESQL*        EXEC SQL ROLLBACK END-EXEC
OCESQL     CALL "OCESQLStartSQL"
OCESQL     END-CALL
OCESQL     CALL "OCESQLExec" USING
OCESQL          BY REFERENCE SQLCA
OCESQL          BY REFERENCE "ROLLBACK" & x"00"
OCESQL     END-CALL
OCESQL     CALL "OCESQLEndSQL"
OCESQL     END-CALL
           END-IF.

           MOVE WS-USER-NAME TO LK-USER-NAME.
           MOVE WS-USER-PASS TO LK-USER-PASS.

           END PROGRAM insrt.

