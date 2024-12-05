#!/bin/sh
#

echo "iconv en cours ..."
iconv -f UTF-8 -t IBM-1140 /u/aymeric/SRC_IMS/API00I01.cpy > /u/aymeric/SRC_IMS/tmp
awk '{printf "%-79s\n", $0}' /u/aymeric/SRC_IMS/tmp > /u/aymeric/SRC_IMS/API00I01

iconv -f UTF-8 -t IBM-1140 /u/aymeric/SRC_IMS/API00P01.cpy > /u/aymeric/SRC_IMS/tmp
awk '{printf "%-79s\n", $0}' /u/aymeric/SRC_IMS/tmp > /u/aymeric/SRC_IMS/API00P01

iconv -f UTF-8 -t IBM-1140 /u/aymeric/SRC_IMS/API00Q01.cpy > /u/aymeric/SRC_IMS/tmp
awk '{printf "%-79s\n", $0}' /u/aymeric/SRC_IMS/tmp > /u/aymeric/SRC_IMS/API00Q01

iconv -f UTF-8 -t IBM-1140 /u/aymeric/SRC_IMS/BAQHCONC.cpy > /u/aymeric/SRC_IMS/tmp
awk '{printf "%-79s\n", $0}' /u/aymeric/SRC_IMS/tmp > /u/aymeric/SRC_IMS/BAQHCONC

iconv -f UTF-8 -t IBM-1140 /u/aymeric/SRC_IMS/BAQHAREC.cpy > /u/aymeric/SRC_IMS/tmp
awk '{printf "%-79s\n", $0}' /u/aymeric/SRC_IMS/tmp > /u/aymeric/SRC_IMS/BAQHAREC

iconv -f UTF-8 -t IBM-1140 /u/aymeric/SRC_IMS/IVTNDB2.cbl > /u/aymeric/SRC_IMS/tmp
awk '{printf "%-79s\n", $0}' /u/aymeric/SRC_IMS/tmp > /u/aymeric/SRC_IMS/IVTNDB2

iconv -f UTF-8 -t IBM-1140 /u/aymeric/SRC_IMS/IVTNDB2C.cpy > /u/aymeric/SRC_IMS/tmp
awk '{printf "%-79s\n", $0}' /u/aymeric/SRC_IMS/tmp > /u/aymeric/SRC_IMS/IVTNDB2C

rm -Rf /u/aymeric/SRC_IMS/tmp