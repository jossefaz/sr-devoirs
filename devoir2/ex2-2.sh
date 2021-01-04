#!/bin/bash

# On verifie qu'un seul nom de login a bien été passé en parametre
if [[ "${#}" -gt 2 ]] || [[ "${#}" -lt 2 ]]
then
	echo "Usage : USER DATE"
    echo "Vous devez rentrer un (et un seul!) nom d'utilisateur valide ainsi que une (et une seule) date valide"
    exit 1
fi

LOGIN=${1}
DATE=${2}

# On verifie si l'utilisateur saisi existe
EXISTS=$(grep -c "^${LOGIN}" </etc/passwd)
if [[ EXISTS -eq 0 ]]
then
    echo "L'utilisateur saisi n'existe pas"
    exit 1
fi

# On verifie la validité de la dat par une expression reguliere ^[0-9]{2}/[0-9]{2}/[0-9]{4}$ 
# Explication du regex
# ^ : commence par
# [0-9]{2} : accepte deux entiers (pour le mois)
# / : suivi d un slash
# les autres parties se repretent (pour le jour et l annee)
# $ : fin de l expression

# date "+%d/%m/%Y" -d "${DATE}" >/dev/null 2>&1
# l option -d permet de formater une date selon le format appliqué

# On a besoin de verifier les deux conditions car autrement la commande date renvera 0 dans tous les cas meme si la date en entrée ne correspond pas au format précisé - 
# d ou le besoin de passer par un regex 

if [[ $DATE =~ ^[0-9]{2}/[0-9]{2}/[0-9]{4}$ ]] && date "+%d/%m/%Y" -d "${DATE}" >/dev/null 2>&1
then 
    #On verifie que l'utilisateur a bien un historique crée précédement
    PROC_FILE=./"proc${LOGIN}"
    if [ ! -e "$PROC_FILE" ]; then
        echo "L'utilisateur donné n'a pas encore d'historique de processus. Veuillez executer le premier script afin d'en créer un"
        exit 1
    fi 

    if [[ $(grep -c "${DATE}" <${PROC_FILE}) -lt 1 ]]
    then
        echo "L'utilisateur n'as effectué aucune commande à la date indiqué"
        exit 0
    fi
    # On procede a la lecture des commande a la date donnée
    grep "${DATE}" <${PROC_FILE} | cut -d " " -f 4 | while read line 
    do
        echo $line 
    done
else
    echo "La date rentrée n'est pas valide; le format doit etre mm/dd/YYY"
    exit 1
fi

