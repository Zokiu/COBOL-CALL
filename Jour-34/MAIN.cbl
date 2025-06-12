      ******************************************************************
      *                    IDENTIFICATION DIVISION
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
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

       01  WS-INPUT        PIC X(50).
    
       01  WS-ADD-QUESTION PIC X(1).
           88 WS-ADD-QUESTION-OK VALUE "Y".
           88 WS-ADD-QUESTION-KO VALUE "n".

       01  WS-LGTH         PIC 9(2).
       
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 WS-USER-NAME       PIC X(50).
       01 WS-USER-PASS       PIC X(50).
       01 DB-USER            PIC X(20).
       01 DB-PASS            PIC X(20).
       01 DB-NAME            PIC X(20).
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       

      ******************************************************************
      *                    PROCEDURE DIVISION
      ******************************************************************    

       PROCEDURE DIVISION.

           PERFORM 0000-CONNEXION-START
           THRU    0000-CONNEXION-END.

           PERFORM 0100-ADD-USER-START
           THRU    0100-ADD-USER-END.

           STOP RUN.

      ******************************************************************
      *                       PARAGRAPHES
      ******************************************************************

       0000-CONNEXION-START.
           DISPLAY "Connexion a la base de donnee...".
           DISPLAY "Veuillez renseigner votre username: ".
           ACCEPT DB-USER.
           DISPLAY "Veuillez renseigner votre mot de passe: ".
           ACCEPT DB-PASS.
           DISPLAY "Veuillez renseigner la base de donnee: ".
           ACCEPT DB-NAME.

           EXEC SQL 
           CONNECT :DB-USER IDENTIFIED BY :DB-PASS USING :DB-NAME 
           END-EXEC.

           IF SQLCODE NOT = 0
             DISPLAY "Erreur de connexion SQLCODE: " SQLCODE
           END-IF.

           EXIT.
       0000-CONNEXION-END.

      ******************************************************************

       0100-ADD-USER-START.

           PERFORM 3 TIMES
             DISPLAY "Voulez vous ajouter un utilisateur ? (Y/n)"
             PERFORM UNTIL WS-ADD-QUESTION-OK OR WS-ADD-QUESTION-KO
               ACCEPT WS-INPUT
               EVALUATE WS-INPUT
                   WHEN = "Y"
                       SET WS-ADD-QUESTION-OK TO TRUE
                       DISPLAY "Veuillez renseigner le nom"
                       ACCEPT WS-USER-NAME
                       DISPLAY "Veuillez renseigner le mot de passe"
                       ACCEPT WS-USER-PASS
                       CALL "insrt" USING WS-USER-NAME WS-USER-PASS
                   WHEN = "n"
                       SET WS-ADD-QUESTION-KO TO TRUE
                       DISPLAY "Fin de programme."
                   WHEN OTHER
                       DISPLAY "Saisie incorrecte, veuillez recommencer"
               END-EVALUATE
             END-PERFORM
           END-PERFORM.

           EXIT.
       0100-ADD-USER-END.

