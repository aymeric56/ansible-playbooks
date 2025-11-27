#!/bin/sh
#

echo "iconv en cours ..."
# on va chercher tous les fichiers qui finissent pas .cpy ou .cbl
# on va tailing sur 80 colonnes pour que le compilateur Cobol soit content

search_dir=/u/aymeric/SRC_CICS
for entry in "$search_dir"/*.c*
do
  echo "entry  : $entry"
  entry1=`echo $entry | cut -d . -f 1`
  echo "entry1 : $entry1"
  iconv -f UTF-8 -t IBM-1140 $entry > /u/aymeric/SRC_CICS/tmp
  awk '{printf "%-79s\n", $0}' /u/aymeric/SRC_CICS/tmp > $entry1
done

rm -Rf /u/aymeric/SRC_CICS/tmp