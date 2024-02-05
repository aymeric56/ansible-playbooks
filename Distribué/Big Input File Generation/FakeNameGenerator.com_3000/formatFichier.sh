#!/bin/bash
#--------------------------------------------------------------------------------
# Developer Credits:            Aymeric Affouard   aymeric.affouard@fr.ibm.com
# and other contributors:
#       ...
#--------------------------------------------------------------------------------

# Utilisation:
# 1ère étape: supprimer les spanned
# ./extractSMFRecord.sh DUMP.ZT00PLEX.G6733V00 NoSpanned replace
# 
# 2ère étape: établir la liste des records
# ./extractSMFRecord.sh DUMP.ZT00PLEX.G6733V00 LIST
#
# 3ème étape: pour une liste de record, faire l'extract
# ./extractSMFRecord.sh DUMP.ZT00PLEX.G6733V00 RECORDS fichier_records
# ou
#
# 3ème étape: juste donner un offset pour faire l'extract
# ./extractSMFRecord.sh DUMP.ZT00PLEX.G6733V00 OFFSET 277398

#fichier exemple d'entrée pour RECORDS mais il ne doit pas y avoir de spanned!!! :
#    220 Offset:    2051755 | 0 | length:   3818 | Type : 110 | 2019-12-19 13:15:00 | ZT01 CICS | subtype:  2 
#    221 Offset:    2055573 | 0 | length:   6098 | Type : 110 | 2019-12-19 13:15:00 | ZT01 CICS | subtype:  2 
#    222 Offset:    2061671 | 0 | length:   6922 | Type : 110 | 2019-12-19 13:15:00 | ZT01 CICS | subtype:  2 
#    223 Offset:    2068593 | 0 | length:    798 | Type : 110 | 2019-12-19 13:15:00 | ZT01 CICS | subtype:  2 
#    224 Offset:    2069391 | 0 | length:    334 | Type : 110 | 2019-12-19 13:15:00 | ZT01 CICS | subtype:  2 
#    225 Offset:    2069725 | 1 | length:   1831 | Type :  74 | 2019-12-19 13:15:00 | ZT01  RMF | subtype:  1 
#    226 Offset:    2071556 | 3 | length:  27994 | Type :   +
#    227 Offset:    2099550 | 2 | length:   2703 | Type :   +
#    228 Offset:    2102253 | 1 | length:  25291 | Type :  74 | 2019-12-19 13:15:00 | ZT01  RMF | subtype:  1 
#    229 Offset:    2127544 | 2 | length:   7233 | Type :   +
#    230 Offset:    2134777 | 1 | length:  20761 | Type :  74 | 2019-12-19 13:15:00 | ZT01  RMF | subtype:  1 
#    231 Offset:    2155538 | 2 | length:    211 | Type :   +
#    232 Offset:    2155749 | 0 | length:   3624 | Type :  78 | 2019-12-19 13:15:00 | ZT01  RMF | subtype:  3 
#    233 Offset:    2159373 | 0 | length:   2452 | Type :  71 | 2019-12-19 13:15:00 | ZT01  RMF | subtype:  1 
#    234 Offset:    2161825 | 0 | length:    272 | Type :  75 | 2019-12-19 13:15:00 | ZT01  RMF | subtype:  1 

# Pour voir si le fichier dump contient les RDW il doit commencer par le record 2 et finir par le record 3 qui ont une longueur de 18
# ATTENTION: les records 2 au debut et un 3 à la fin ne sont pas toujours inclus suivant le paramètre OUTDD(OUTDD1,TYPE(70:79)) or TYPE(2,4:7,9,30(2,4:6))
# DUMP:     //IEFPROC  EXEC PGM=IFASMFDP,ACCT=(DUMPXY)
# SMFCOPY:  //SMFCOPY  EXEC PGM=IFASMFDP
#   1 Record Offset:          0 | Type :   2 | length:     18 | 2020-01-08 17:59:25 | ZT01
# ...
# 590 Record Offset:     277398 | Type :   3 | length:     18 | 2020-01-08 17:59:25 | ZT01
#
# >xxd -p -l 18 -s 0 DUMP.ZT00PLEX.G6733V00
# RDW de 4   |  |record 2                                  -> la longeur de 12 en hex = 18 en dec
# 00 12 00 00 1e 02 00423ff50120010fe9e3f0f1
# >xxd -p -l 18 -s 21310808 DUMP.ZT00PLEX.G6733V00         -> taille du fichier 21310826 - 18 = 21310808
# RDW de 4   |  |record 3                                  -> la longeur de 12 en hex = 18 en dec
# 00 12 00 00 1e 03 004240670120010fe9e3f0f1

usage() {
    echo "
Usage:
$0 FakeNameGenerator simple|vaccins [arguments]

Examples:
$0 FakeNameGenerator simple
$0 FakeNameGenerator personnes
$0 FakeNameGenerator vaccins 50

Il faut aussi supprimer la première ligne qui contient les entêtes:
>tail -n +2 file
Attention: pour supprimer les accents: 
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
            #printf "$(date +'%Y-%m-%d|%H:%M:%S')   Fin du formatage du fichier Fake         : %s %10d lines\n" $fichierPersonnes $lignesFichierPersonnes
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