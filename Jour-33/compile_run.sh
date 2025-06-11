#!/bin/bash
# Déclaration de l'interpréteur Bash utilisé pour exécuter ce script.

echo "Compilation des fichiers COBOL..."
# Affiche un message indiquant que la compilation des fichiers COBOL commence.

for file in *.cbl; do
    # Boucle sur tous les fichiers avec l'extension .cbl dans le répertoire courant.
    # La variable 'file' prend successivement le nom de chaque fichier .cbl.

    if [[ -f "$file" ]]; then
        # Vérifie si le fichier existe et est un fichier régulier (non un dossier).
        # Cette condition évite des erreurs si aucun fichier .cbl n'est trouvé.

        if [[ "$file" == "MAIN.cbl" ]]; then
            # Vérifie si le fichier courant est main.cbl.
            # Le fichier main.cbl est traité différemment car il contient probablement le point d'entrée du programme.

            cobc -x -o mail "$file"
            # Compile le fichier main.cbl avec le compilateur COBOL (cobc).
            # -x : Indique que le fichier doit être compilé en un exécutable.
            # -o main : Spécifie que l'exécutable généré s'appellera 'main'.
            # "$file" : Le fichier COBOL à compiler (ici main.cbl).

        else
            # Si le fichier n'est pas main.cbl, il est traité comme un module.

            cobc -c "$file"
            # Compile le fichier COBOL en un fichier objet (.o).
            # -c : Indique une compilation partielle, générant un fichier objet sans lier.
        fi
        # Fin de la condition vérifiant si le fichier est main.cbl.

    fi
    # Fin de la condition vérifiant si le fichier existe.
done
# Fin de la boucle sur les fichiers .cbl.

if [[ -f "mail" ]]; then
    # Vérifie si l'exécutable 'main' a été créé avec succès.
    # Cela indique que la compilation de main.cbl a réussi.

    echo "Liaison des fichiers objets..."
    # Affiche un message indiquant que la phase de liaison commence.

    cobc -x -o run MAIN.cbl *.o
    # Lie tous les fichiers objets (.o) pour créer un exécutable final nommé 'run'.
    # -x : Indique la création d'un exécutable.
    # -o run : Spécifie que l'exécutable final s'appellera 'run'.
    # main.o *.o : Inclut main.o et tous les autres fichiers objets (.o) dans le répertoire.

    echo "Exécution du programme..."
    # Affiche un message indiquant que l'exécutable va être lancé.

    ./run
    # Exécute le programme généré (run).
    # Le './' indique que l'exécutable se trouve dans le répertoire courant.

    echo "Nettoyage des fichiers objets..."
    # Affiche un message indiquant que les fichiers objets temporaires vont être supprimés.

    rm -f *.o
    # Supprime tous les fichiers objets (.o) pour nettoyer le répertoire.
    # -f : Force la suppression sans demander de confirmation.

else
    # Si l'exécutable 'mail' n'existe pas, cela signifie que MAIN.cbl n'a pas été trouvé ou que sa compilation a échoué.

    echo "Erreur : MAIN.cbl non trouvé ou compilation échouée."
    # Affiche un message d'erreur pour informer l'utilisateur.

    exit 1
    # Termine le script avec un code de retour 1, indiquant une erreur.
fi
# Fin de la condition vérifiant l'existence de l'exécutable 'main'.