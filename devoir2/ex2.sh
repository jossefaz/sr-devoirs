#!/bin/bash

# On verifie qu'un seul nom de login a bien été passé en parametre
if [[ "${#}" -gt 1 ]] || [[ "${#}" -eq 0 ]]
then
	echo "Usage : USER"
    echo "Vous devez rentrer un (et un seul!) nom d'utilisateur valide"
    exit 1
fi

LOGIN=${1}

# On verifie si l'utilisateur saisi existe
EXISTS=$(grep -c "^${LOGIN}" </etc/passwd)
if [[ EXISTS -eq 0 ]]
then
    echo "L'utilisateur saisi n'existe pas"
    exit 1
fi

# recherche des processus correspondant a cet utilisateur
# On doit imprimer les processus selon le format nom-d-utilisateur pid-du-processus durée-du-processus nom-de-la-commande date-du-jour
# On utilise pour cela le flag -o de la commande ps qui nous permet de preciser les parametres que l'on souhaite afficher pour chaque processus
: '
Respectivement 
nom-d-utilisateur : user
pid-du-processus : pid
durée-du-processus(temps CPU) : cputime
nom-de-la-commande : command
Pour la date on va la rajouter a la commande echo
'
ps -ao user,pid,cputime,command | grep "^${LOGIN}" | while read line 
do
    echo $line $(date +"%m/%d/%Y") >> proc${LOGIN}
done
