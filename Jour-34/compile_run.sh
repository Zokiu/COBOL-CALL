#!/bin/bash
# Déclaration de l'interpréteur Bash utilisé pour exécuter ce script.

echo "Compilation des fichiers COBOL..."
# Affiche un message indiquant que la compilation des fichiers COBOL commence.

for filepath in *.cbl; do
    # Boucle sur tous les fichiers avec l'extension .cbl dans le répertoire courant.
    # La variable 'file' prend successivement le nom de chaque fichier .cbl.

    if [[ -f "$filepath" ]]; then
        # Vérifie si le fichier existe et est un fichier régulier (non un dossier).
        # Cette condition évite des erreurs si aucun fichier .cbl n'est trouvé.

        file="${filepath%.cbl}"

        ocesql "$filepath" "$file.cob"
        

    fi
    # Fin de la condition vérifiant si le fichier existe.
done
# Fin de la boucle sur les fichiers .cbl.

if [[ -f "main_sql.cob" ]]; then
    # Vérifie si l'exécutable 'main' a été créé avec succès.
    # Cela indique que la compilation de main.cbl a réussi.

    echo "Liaison des fichiers objets..."
    # Affiche un message indiquant que la phase de liaison commence.

    cobc -locesql -x -o run main_sql.cob *.cob

    echo "Exécution du programme..."
    # Affiche un message indiquant que l'exécutable va être lancé.

    ./run
    # Exécute le programme généré (run).
    # Le './' indique que l'exécutable se trouve dans le répertoire courant.

    echo "Nettoyage des fichiers objets..."
    # Affiche un message indiquant que les fichiers objets temporaires vont être supprimés.

    rm -f *.cob
    # Supprime tous les fichiers objets (.o) pour nettoyer le répertoire.
    # -f : Force la suppression sans demander de confirmation.

else
    # Si l'exécutable 'main' n'existe pas, cela signifie que main.cbl n'a pas été trouvé ou que sa compilation a échoué.

    echo "Erreur : main.cbl non trouvé ou compilation échouée."
    # Affiche un message d'erreur pour informer l'utilisateur.

    exit 1
    # Termine le script avec un code de retour 1, indiquant une erreur.
fi
# Fin de la condition vérifiant l'existence de l'exécutable 'main'.