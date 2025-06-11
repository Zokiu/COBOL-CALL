       IDENTIFICATION DIVISION.
       PROGRAM-ID. validate.
       AUTHOR.     Terry.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       
       01  AT-COUNT                         PIC 9(03).

       LINKAGE SECTION.

       01  LK-ID                            PIC X(10).
       01  LK-EMAIL                         PIC X(50).
       
       PROCEDURE DIVISION USING LK-ID LK-EMAIL.
      *On réinitialise la variable de comptage.
           MOVE 0                           TO AT-COUNT.    
      *On compte le nombre de "@" dans la chaine de caratère EMAIL.
           INSPECT LK-EMAIL TALLYING AT-COUNT FOR ALL "@".
      *Si il y en a 1 alors le mail est valide.
           
           IF AT-COUNT NOT = 1 OR LK-ID NOT NUMERIC
               MOVE 1                       TO RETURN-CODE
           ELSE IF AT-COUNT = 1 THEN
               MOVE 0                       TO RETURN-CODE
           END-IF.
           END PROGRAM validate.
