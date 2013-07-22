#/bin/sh

# Debut Fonctions

function verifierRepertoireSauvegarde() {
    sudo mkdir ${REPERTOIRE_HOME_SAUVEGARDE}/$1
    sudo mkdir ${REPERTOIRE_HOME_SAUVEGARDE}/$1/${JOURNALIERE}
    sudo mkdir ${REPERTOIRE_HOME_SAUVEGARDE}/$1/${HEBDOMADAIRE}
    sudo mkdir ${REPERTOIRE_HOME_SAUVEGARDE}/$1/${MENSUEL}
    sudo mkdir ${REPERTOIRE_HOME_SAUVEGARDE}/$1/${ANNUEL}
    sudo mkdir ${REPERTOIRE_HOME_SAUVEGARDE}/$1/${SYNCHRO}
}

function pause(){
   read -p "$*"
}

function compressionUtilisateur () {
    echo tar cvfz ${REPERTOIRE_HOME_ORIGINE}/$1_$dateHeure.tar.gz /home/$1
    sudo tar cvfz ${REPERTOIRE_HOME_ORIGINE}/$1_$dateHeure.tar.gz /home/$1
}

function deplacementArchiveVersSauvegarde () {
    echo mv ${REPERTOIRE_HOME_ORIGINE}/$1_$dateHeure.tar.gz ${REPERTOIRE_HOME_SAUVEGARDE}/$1/$2
    sudo mv ${REPERTOIRE_HOME_ORIGINE}/$1_$dateHeure.tar.gz ${REPERTOIRE_HOME_SAUVEGARDE}/$1/$2
}

function synchronisationSauvegarde () {
    echo rsync -av --delete ${REPERTOIRE_HOME_ORIGINE}/$1 ${REPERTOIRE_HOME_SAUVEGARDE}/$1/${SYNCHRO}
    sudo rsync -av --delete ${REPERTOIRE_HOME_ORIGINE}/$1 ${REPERTOIRE_HOME_SAUVEGARDE}/$1/${SYNCHRO}
}

# Fin fonctions

# Répertoire des utilisateurs
REPERTOIRE_HOME_ORIGINE=/home

# Répertoire de sauvegarde
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

# Répertoire de synchonisation
SYNCHRO=synchro

# Horadateur :

jourCourant="`date +'%d'`"
moisCourant="`date +'%m'`"
anneeCourant="`date +'%y'`"
heureCourant="`date +'%k'`"
minuteCourant="`date +'%M'`"

dateHeure=${anneeCourant}${moisCourant}${jourCourant}_${heureCourant}${minuteCourant}

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

synchronisationSauvegarde ${UTILISATEUR} ${SYNCHRO}

echo "*** Sauvegarde terminé ***"
