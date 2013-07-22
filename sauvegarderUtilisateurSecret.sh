#/bin/sh

# Debut Fonctions


# Function : verifierRepertoireSauvegarde
# Paramètre :
#   Nom de l'utilisateur

function verifierRepertoireSauvegarde() {
    if [ ! -d ${REPERTOIRE_HOME_SAUVEGARDE}/$1 ]; then
        echo Le répertoire ${REPERTOIRE_HOME_SAUVEGARDE}/$1 n existe pas. Création.
        sudo mkdir ${REPERTOIRE_HOME_SAUVEGARDE}/$1
        sudo mkdir ${REPERTOIRE_HOME_SAUVEGARDE}/$1/${JOURNALIERE}
        sudo mkdir ${REPERTOIRE_HOME_SAUVEGARDE}/$1/${HEBDOMADAIRE}
        sudo mkdir ${REPERTOIRE_HOME_SAUVEGARDE}/$1/${MENSUEL}
        sudo mkdir ${REPERTOIRE_HOME_SAUVEGARDE}/$1/${ANNUEL}
        sudo mkdir ${REPERTOIRE_HOME_SAUVEGARDE}/$1/${SYNCHRO}
    fi
}

function pause(){
   read -p "$*"
}

# Function : compressionUtilisateur
# Paramètre :
#   Nom de l'utilisateur

function compressionUtilisateur () {
    echo tar cvfz ${REPERTOIRE_HOME_ORIGINE}/$1_$dateHeure.tar.gz /home/$1
    sudo tar cvfz ${REPERTOIRE_HOME_ORIGINE}/$1_$dateHeure.tar.gz /home/$1
}

# Function : deplacementArchiveVersSauvegarde
# Paramètre :
#   Nom de l'utilisateur
#   Type de sauvegarde (journaliere, hebdomadaire, mensuel, annuel)

function deplacementArchiveVersSauvegarde () {
    echo mv ${REPERTOIRE_HOME_ORIGINE}/$1_$dateHeure.tar.gz ${REPERTOIRE_HOME_SAUVEGARDE}/$1/$2
    sudo mv ${REPERTOIRE_HOME_ORIGINE}/$1_$dateHeure.tar.gz ${REPERTOIRE_HOME_SAUVEGARDE}/$1/$2
}

# Function : synchronisationUtilisateur
# Paramètre :
#   Nom de l'utilisateur

function synchronisationUtilisateur () {
    echo rsync -av --delete ${REPERTOIRE_HOME_ORIGINE}/$1 ${REPERTOIRE_HOME_SAUVEGARDE}/$1/${SYNCHRO}
    sudo rsync -av --delete ${REPERTOIRE_HOME_ORIGINE}/$1 ${REPERTOIRE_HOME_SAUVEGARDE}/$1/${SYNCHRO}
}

# Function : journalisation

function journalisation () {
    echo Journalisation
}

# Function : supprimerArchive
# Paramètre :
#   Nom de l'utilisateur
#   Type de sauvegarde (journaliere, hebdomadaire, mensuel, annuel)

function supprimerArchive () {
    echo supprimerArchive
}

# Fin fonctions

# Répertoire des utilisateurs
REPERTOIRE_HOME_ORIGINE=/home

# Répertoire de sauvegarde /!\ A modifier /!\
REPERTOIRE_HOME_SAUVEGARDE=/media/secret/SAUVEGARDE1

# Utilisateur à sauvegarder /!\ A modifier /!\
UTILISATEUR=test

# Répertoire de sauvegarde journaliere
JOURNALIERE=journaliere

# Répertoire de sauvegarde hebdomadaire
HEBDOMADAIRE=hebdomadaire

# Répertoire de sauvegarde mensuel
MENSUEL=mensuel

# Répertoire de sauvegarde annuel
ANNUEL=annuel

# Répertoire de synchronisation
SYNCHRO=synchro

# Horadateur :

jourCourant="`date +'%d'`"
moisCourant="`date +'%m'`"
anneeCourant="`date +'%y'`"
heureCourant="`date +'%k'`"
minuteCourant="`date +'%M'`"

dateHeure=${anneeCourant}${moisCourant}${jourCourant}_${heureCourant}${minuteCourant}


if [ $# -gt 0 ] && [ "$1" = "production" ] && [ "$2" = "sauvegarde" ]; then

    echo "*** Sauvegarde " ${UTILISATEUR} " ****"

    verifierRepertoireSauvegarde ${UTILISATEUR}

    #pause 'Appuyer sur la touche [Entrée] pour continuer...'

    echo "Horaire archive : " ${dateHeure}

    #pause 'Appuyer sur la touche [Entrée] pour continuer...'

    echo Sauvegarde de ${REPERTOIRE_HOME_ORIGINE}/${UTILISATEUR} vers ${REPERTOIRE_HOME_SAUVEGARDE}

    compressionUtilisateur ${UTILISATEUR}

    #pause 'Appuyer sur la touche [Entrée] pour continuer...'

    deplacementArchiveVersSauvegarde ${UTILISATEUR} ${JOURNALIERE}

    #pause 'Appuyer sur la touche [Entrée] pour continuer...'

    echo "Synchronisation"

    synchronisationUtilisateur ${UTILISATEUR} ${SYNCHRO}

    echo "*** Sauvegarde terminé ***"

else
    echo 
    echo Utilisation :
    echo 
    echo    - Sauvegarde en production :
    echo        ./sauvegarderUtilisateurSecret.sh production sauvegarde
    echo 
fi
