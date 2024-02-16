#/bin/sh
#
# Script pour renommer les fichiers JCL ou sources COBOL depuis un import FTP du z/OS
#

# Liste les fichiers du repertoire
for i in {0..31}
do
  ii=$(printf "%02d" $i)
  # search_dir=./ENSISA\ 2024\ Exam/ENSIS$ii.JCL
  search_dir=./ENSISA\ 2024\ Exam/ENSIS$ii.SOURCES
  for entry in "$search_dir"/*
  do
    echo "$entry"
    # mv "$entry" "$entry.jcl"
    mv "$entry" "$entry.cbl"
  done
done