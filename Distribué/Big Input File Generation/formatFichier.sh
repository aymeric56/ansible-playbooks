#!/bin/bash
#--------------------------------------------------------------------------------
# Developer Credits:            Aymeric Affouard   aymeric.affouard@fr.ibm.com
# and other contributors:
#       ...
#--------------------------------------------------------------------------------

#--------------------------------------------------------------------------------
# Generation of files with lot of records for student COBOL exercices
#--------------------------------------------------------------------------------

usage() {
    echo "
Usage:
$0 FakeNameGenerator simple|vaccins [arguments]

Examples:
$0 FakeNameGenerator simple
$0 FakeNameGenerator personnes
$0 FakeNameGenerator vaccins 50

Il faut aussi supprimer la première ligne qui contient les entêtes:
>tail -n +2 file.csv > Fake1.csv
Attention: il faut également supprimer les accents: 
>cat Fake1.csv | tr "àçéèêëîïôöùüÂÇÉÈÊËÎÏÔÖÙÜ" "aceeeeiioouuACEEEEIIOOUU" > Fake2.csv
"
}



# ************************************************************************
# Mofification pour formater le gros fichier
# 
# list_records ne fait qu'afficher à l'écran
# ************************************************************************
list_records() {
   
    while IFS= read -r lineListRecord ; do
        # on récupère les entrées
        Nom=$(echo $lineListRecord | awk -F "," '{print $2}')
        Prenom=$(echo $lineListRecord | awk -F "," '{print $1}')
        Adresse=$(echo $lineListRecord | awk -F "," '{print $3}' | sed 's/"//g')
        Ville=$(echo $lineListRecord | awk -F "," '{print $4}' | sed 's/"//g')
        Zipcode=$(echo $lineListRecord | awk -F "," '{print $5}')
        #echo "$Nom"
        printf "%-30s%-30s%-40s%-6s%-30s\n" "$Nom" "$Prenom" "$Adresse" "$Zipcode" "$Ville"
    done < $ListRecordsInput

}

# ************************************************************************
# Mofification pour formater le gros fichier
# 
# list_personnes liste les Personnes provenant de la base TPERS
# ************************************************************************
list_personnes() {
   
    while IFS= read -r lignePersonne ; do
        # on récupère les entrées
        Nom=$(echo $lignePersonne | awk -F "," '{print $2}' | sed 's/"//g')
        Prenom=$(echo $lignePersonne | awk -F "," '{print $1}' | sed 's/"//g')
        Adresse=$(echo $lignePersonne | awk -F "," '{print $3}' | sed 's/"//g')
        Ville=$(echo $lignePersonne | awk -F "," '{print $4}' | sed 's/"//g')
        Zipcode=$(echo $lignePersonne | awk -F "," '{print $5}')
        AdresseComplete=$(echo $Adresse $Zipcode $Ville )
        printf "%-64s%-32s%-64s\n" "$Nom" "$Prenom" "$AdresseComplete" >> $OutputFile
    done < $fichierPersonnes

}

# ************************************************************************
# Mofification pour formater le gros fichier
# 
# list_vaccins crée un fichier d'input pour le projet n°7 vaccins
# ************************************************************************
list_vaccins() {

    echo "On va créer $1 enregistrements dans le fichier : $OutputFile"
    echo "  en partant d'un fichier de personnes $fichierPersonnes à $lignesFichierPersonnes lignes"
    
    for i in $(seq 1 $1); do
        ligneRandom=$(shuf -i 1-$lignesFichierPersonnes -n 1)
        #echo $ligneRandom
        lignePersonne=$(awk -v ligne=$ligneRandom 'NR==ligne' $fichierPersonnes)
        #echo $lignePersonne

        #on récupère les entrées
        Nom=$(echo $lignePersonne | awk -F "," '{print $2}' | sed 's/"//g')
        Prenom=$(echo $lignePersonne | awk -F "," '{print $1}' | sed 's/"//g')
        NumSS=$(awk -v min=100000000000000 -v max=299999999999999 -v seed=$RANDOM 'BEGIN{srand(seed); print int(min+rand()*(max-min+1))}')
        jourDeMoins=$(shuf -i 1-600 -n 1)
        #DateVaccination=$(date -v-3y -v-'$jourDeMoins'd +'%Y%m%d')
        # Format Linux
        DateVaccination=$(date --date="${jourDeMoins} days ago" '+%Y%m%d')
        # Format MacOS
        #DateVaccination=$(date -v-1y -v-${jourDeMoins}d +'%Y%m%d')
        randomTypeVaccin=$(shuf -i 0-10 -n 1)
        randomIndicateurDeRappel=$(shuf -i 0-1 -n 1)
        if [ $randomIndicateurDeRappel == 0 ]; then
            # pour jourDePlus on prend entre +1an et +"5ans"
            jourDePlus=$(shuf -i 365-1825 -n 1)
            # Format Linux
            DateRelanceVaccin=$(date --date="${jourDePlus} days" '+%Y%m%d')
            # Format MacOS
            #DateRelanceVaccin=$(date -v+${jourDePlus}d +'%Y%m%d')
        else
            DateRelanceVaccin=""
        fi
        #echo "$Nom | $NumSS | $DateVaccination"
        printf "%-64s%-32s%15d%8s%-20s%s%-8s\n" "$Nom" "$Prenom" "$NumSS" $DateVaccination "${TypeVaccin[$randomTypeVaccin]}" "${IndicateurDeRappel[$randomIndicateurDeRappel]}" $DateRelanceVaccin >> $OutputFile
    done
}


#-----------------------------
# Main code starts here.            
#-----------------------------



#declare -a indices     -> declare indices comme un array

DumpSMFFile=$1
#OffsetInput=$(awk -F "|" '{print $1}' RecordsInput.txt | awk -F ":" '{print $2}')

SMFoffset=0
numSMF=0
sharedVariable=0
GOtoReplaceFile=0
fullRecordVariable=""
mapRecord=""
sec=0
min=0
hour=0

TypeVaccin=("COVID-19" "Tetanos" "Gripe" "Coqueluche" "Hepatite B" "Dengue" "Fievre Jaune" "Hepatite A" "HPV" "Meningite" "Varicelle")
IndicateurDeRappel=("O" "N")

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "I don't understand!"
    usage
else
    case $2 in
        simple)
            fileSize=$(wc -l $1 | awk '{print $1}')
            ListRecordsInput=$1
            printf "$(date +'%Y-%m-%d|%H:%M:%S')   On va faire la formatage du fichier Fake : %s %10d lines\n" $ListRecordsInput $fileSize
            OutputFile=$(echo "$1.format")
            rm -Rf $OutputFile
            list_records
            printf "$(date +'%Y-%m-%d|%H:%M:%S')   Fin du formatage du fichier Fake         : %s %10d lines\n" $ListRecordsInput $fileSize
            ;;
        personnes)
            lignesFichierPersonnes=$(wc -l $1 | awk '{print $1}')
            fichierPersonnes=$1
            printf "$(date +'%Y-%m-%d|%H:%M:%S')   On va faire la formatage du fichier Personnes en sortie de TPERS : %s %10d lines\n" $fichierPersonnes $lignesFichierPersonnes
            OutputFile=$(echo "fichierPersonnes.input")
            rm -Rf $OutputFile
            list_personnes
            printf "$(date +'%Y-%m-%d|%H:%M:%S')   Fin du formatage du fichier Personnes en sortie de TPERS         : %s %10d lines\n" $fichierPersonnes $lignesFichierPersonnes
            ;;
        vaccins)
            lignesFichierPersonnes=$(wc -l $1 | awk '{print $1}')
            fichierPersonnes=$1
            OutputFile=$(echo "fichierInputProjet7Vaccins.input")
            rm -Rf $OutputFile
            printf "$(date +'%Y-%m-%d|%H:%M:%S')   On va faire la formatage du fichier %s à partir du fichier de personnes : %s %10d lines\n" $OutputFile $fichierPersonnes $lignesFichierPersonnes
            if [ -z "$3" ] ; then
                echo "Il faut préciser le nombre de ligne à créer !"
                usage
            else
                list_vaccins $3
            fi
            printf "$(date +'%Y-%m-%d|%H:%M:%S')   Fin du formatage du fichier %s\n" $OutputFile
            ;;    
        *)
            echo "I don't understand!"
            usage
            ;;
    esac
fi

# Un peu de nettoyage
rm -Rf map
rm -Rf mapToPrint
#rm -Rf $DumpSMFFile.tmp1
#rm -Rf $DumpSMFFile.tmp2