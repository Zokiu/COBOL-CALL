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

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT F-INPUT ASSIGN TO "users.dat"
                                ORGANIZATION IS LINE SEQUENTIAL
                                FILE STATUS IS F-INPUT-STATUS.
           
           SELECT F-OUTPUT ASSIGN TO "errors.log"
                                ORGANIZATION IS LINE SEQUENTIAL
                                FILE STATUS IS F-OUTPUT-STATUS.

      ******************************************************************
      *                      DATA DIVISION
      ******************************************************************

       DATA DIVISION.
       FILE SECTION.

       FD  F-INPUT.

           COPY user.

       FD  F-OUTPUT.

       01 REC-F-OUTPUT        PIC X(80).
    
      ******************************************************************
           
       WORKING-STORAGE SECTION.

      *Flag pour gestion fichier input.
       01  F-INPUT-STATUS         PIC X(02) VALUE SPACE.
           88 F-INPUT-STATUS-OK             VALUE "00".
           88 F-INPUT-STATUS-EOF            VALUE "10".

      *Structure avec tableau dynamique pour les mails valides.
       01  DATA-USER.
           05 USER-LGHT         PIC 9(03).
           05 USER OCCURS 1 TO 999 TIMES DEPENDING ON USER-LGHT
                                         INDEXED   BY USER-IDX.
                10 USER-ID      PIC X(10).
                10 USER-NAME    PIC X(50).
                10 USER-EMAIL   PIC X(50).

      *Structure avec tableau dynamique pour les mails invalides.
       01  INVALID-USER.
           05 USER-I-LGHT         PIC 9(03).
           05 USER-I OCCURS 1 TO 999 TIMES DEPENDING ON USER-I-LGHT
                                           INDEXED BY   USER-I-IDX.
                10 USER-I-ID      PIC X(10).
                10 USER-I-NAME    PIC X(50).
                10 USER-I-EMAIL   PIC X(50).

      *Flag pour gestion fichier output.
       01  F-OUTPUT-STATUS        PIC X(02) VALUE SPACE.
           88 F-OUTPUT-STATUS-OK            VALUE "00".
           88 F-OUTPUT-STATUS-EOF           VALUE "10".

      *Structure pour formatage ecriture.
       01  WS-OUTPUT.
           05 FILLER              PIC X(01) VALUE "[".
           05 OUT-ID              PIC X(10).
           05 FILLER              PIC X(01) VALUE "]".
           05 FILLER              PIC X(10) VALUE " Erreur : ".
           05 FILLER              PIC X(24) 
                                   VALUE "Email ou Index invalide ".
           05 OUT-EMAIL           PIC X(50).

      ******************************************************************
      *                    PROCEDURE DIVISION
      ******************************************************************       
       PROCEDURE DIVISION.
      
      *Paragraphe gerant la lecture du fichier d'entree.
           PERFORM 0100-F-INPUT-START
           THRU    0100-F-INPUT-END.
    
      *Paragraphe pour vérifier le mail.
           PERFORM 0300-TEST-MAIL-START
           THRU    0300-TEST-MAIL-END.

      *Paragraphe gerant l'ecriture du fichier de sortie.
           PERFORM 0200-F-OUTPUT-START
           THRU    0200-F-OUTPUT-END.

           STOP RUN.

      ******************************************************************
      *                       PARAGRAPHES
      ******************************************************************

      
       0100-F-INPUT-START.

           OPEN INPUT F-INPUT.

           DISPLAY "Debut de lecture du fichier.".

           PERFORM UNTIL F-INPUT-STATUS-EOF
             READ F-INPUT
              AT END
               DISPLAY "Fin de lecture de fichier."
              NOT AT END
                  ADD  1               TO USER-LGHT
                  MOVE ID-USER         TO USER-ID   (USER-LGHT)
                  MOVE NOM             TO USER-NAME (USER-LGHT)
                  MOVE EMAIL           TO USER-EMAIL(USER-LGHT)
             END-READ
           END-PERFORM.

           CLOSE F-INPUT.

           EXIT.
       0100-F-INPUT-END.

      ******************************************************************

       0200-F-OUTPUT-START.
           
           OPEN OUTPUT F-OUTPUT.

           DISPLAY "Début de l'écriture du fichier log.".
      *Boucle pour écrire chaque ligne du fichier.
           PERFORM VARYING USER-I-IDX FROM 1 BY 1 
                                      UNTIL USER-I-IDX > USER-I-LGHT
             MOVE USER-I-ID(USER-I-IDX)     TO OUT-ID
             MOVE USER-I-EMAIL(USER-I-IDX)  TO OUT-EMAIL
             MOVE WS-OUTPUT                 TO REC-F-OUTPUT
             WRITE REC-F-OUTPUT

           END-PERFORM.
           
           DISPLAY "Fin de l'écriture du fichier.".

           CLOSE F-OUTPUT.

           EXIT.
       0200-F-OUTPUT-END.

      ******************************************************************

       0300-TEST-MAIL-START.
           
           PERFORM VARYING USER-IDX FROM 1 BY 1
                                       UNTIL USER-IDX > USER-LGHT
      *Appel du sous programme pour tester si présence "@".
             CALL "validate" USING USER-ID(USER-IDX) 
                                   USER-EMAIL(USER-IDX)
             DISPLAY "Test utilisateur."
      *Si mail incorrect on bouge dans la structure INVALID-USER.
             IF RETURN-CODE = 1
               DISPLAY "Erreur sur la ligne n° " USER-ID(USER-IDX)
               ADD  1                    TO USER-I-LGHT
               MOVE USER-ID(USER-IDX)    TO USER-I-ID   (USER-I-LGHT)
               MOVE USER-NAME(USER-IDX)  TO USER-I-NAME (USER-I-LGHT)
               MOVE USER-EMAIL(USER-IDX) TO USER-I-EMAIL(USER-I-LGHT)
             END-IF
           END-PERFORM.
           EXIT.
       0300-TEST-MAIL-END.
