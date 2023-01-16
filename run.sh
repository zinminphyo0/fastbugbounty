#!/bin/sh

mkdir $1 
cd $1
amass enum -passive -d $1 > 1.txt
subfinder -d $1 -all -silent > 2.txt
cat *.txt | sort -u > subs.txt
httpx -l subs.txt -o http-subs.txt -t 150 -silent
nuclei -t ~/nuclei-templates/cves/ -t ~/nuclei-templates/default-logins/ -t ~/nuclei-templates/exposed-panels/ -t ~/nuclei-templates/takeovers/ -t ~/nuclei-templates/vulnerabilities/ -t ~/nuclei-templates/iot/ -l http-subs.txt -as -es info -etags ssl -rl 250 -si 20 -bs 50 -c 300 -silent -o vuln1.txt
nuclei -t ~/templates/ ~/fuzzing-templates/ -t ~/nuclei-templates/exposures/ -t ~/nuclei-templates/misconfiguration/ -t ~/nuclei-templates/miscellaneous/ -l http-subs.txt -as -es info -etags ssl -rl 250 -si 20 -bs 50 -silent -o vuln2.txt -c 300
