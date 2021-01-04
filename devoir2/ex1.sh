#!/bin/bash

# On verifie qu'un seul nom de login a bien été passé en parametre
if [[ "${#}" -gt 1 ]] || [[ "${#}" -eq 0 ]]
then
	echo "Usage : USER"
    echo "Vous devez rentrer un (et un seul!) nom d'utilisateur valide"
    exit 1
fi
fi

LOGIN=${1}

# On verifie si l'utilisateur saisi existe
EXISTS=$(grep -c "^${LOGIN}" </etc/passwd)
if [[ EXISTS -eq 0 ]]
then
    echo "L'utilisateur saisi n'existe pas"
    exit 1
fi


# Quel est le shell de l utilisateur root

ROOT_SHELL=$(grep '^root' </etc/passwd | cut -d: -f 7)
echo "Le shell de l'utilisateur root est ${ROOT_SHELL}"

#Lister tous les membres du groupes principal de l'utilisateur saisi

# Recurperer le group ID
PR_GR_ID=$(grep "^${LOGIN}" </etc/passwd | cut -d: -f 4)
PR_GR_NAME=$(grep "${PR_GR_ID}" </etc/group | cut -d: -f 1)
# Recuperer les donnes du groupe en fonction de l'idet en extraire les noms des membres du groupe
PR_GR_MEMBERS=$(grep "${PR_GR_ID}" </etc/group | cut -d: -f 4)

# Si l'utilisateur est l'unique membre de son groupe principal (si la taille de la liste des membres est egale a 1)
if [[ ${#PR_GR_MEMBERS[@]} -eq 1 ]]
then
    #afficher que l'utilisateur est l'unique membre se son group principal
    echo "L'utilisateur ${LOGIN} est l'unique membre du groupe principal ${PR_GR_NAME} "
else 
    # afficher la liste des membres
    echo "Les membres du groupe ${PR_GR_NAME} sont : ${PR_GR_MEMBERS}"
fi




# Explication de la commande "grep 'XXXX' <nomFichier | cut -d: -f 7" qui est la commande principal utilisé dans ce script
: '
grep "XXX" : va rechercher l expression reguliere
<nomFichier : fait passer le contenu du fichier nomFichier en entrée standard (stdin) de la commande grep
| : le pipe fait passer la sortie standard de la commande précédente (ici grep) en entrée standard de la commande suivante (ici cut)
cut : commande permettant de decouper l entrée standard et d en séléctionner certaines partie par différentes options passées en flag
-d : défini un délimiteur de champs. Ici on a ecrit d: car les deux points ":" sont le délimiteur de champs des fichiers de configuration /etc/passzd et /etc/group
-f : défini quel champ séléctioner en précisant son index. Pour les fichiers de configuration nous avons donc a chaque fois ecrit l index correspondant à la valeur cherchée (que ce soit l id di groupe ou le nom d un utilisateur par exemple)
'
