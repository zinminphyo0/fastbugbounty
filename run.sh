#!/bin/sh

mkdir $1 
cd $1
amass enum -passive -d $1 > 1.txt
subfinder -d $1 -all -silent > 2.txt
cat 1.txt 2.txt | sort -u > subs.txt
httpx -l subs.txt -o http-subs.txt -t 150 -silent
nuclei -t ~/nuclei-templates/http/cves/ -t ~/nuclei-templates/http/default-logins/ -t ~/nuclei-templates/http/exposed-panels/ -t ~/nuclei-templates/http/takeovers/ -t ~/nuclei-templates/http/vulnerabilities/ -t ~/nuclei-templates/http/iot/ -l http-subs.txt -as -es info -etags ssl -rl 250 -si 20 -bs 50 -c 300 -silent -o vuln1.txt
nuclei -t ~/nuclei-templates/http/credential-stuffing/ -t ~/nuclei-templates/http/token-spray/ -t ~/nuclei-templates/http/exposures/ -t ~/nuclei-templates/http/misconfiguration/ -t ~/nuclei-templates/http/miscellaneous/ -l http-subs.txt -as -es info -etags ssl -rl 250 -si 20 -bs 50 -silent -o vuln2.txt -c 300
