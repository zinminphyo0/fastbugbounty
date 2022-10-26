#!/bin/sh

mkdir $1 
cd $1
amass enum -passive -d $1 > 1.txt
subfinder -d $1 -all > 2.txt
cat *.txt | sort -u > subs.txt
httpx-toolkit -l subs.txt -o http-subs.txt -t 150
nuclei -t cves/ -t default-logins/ -t exposed-panels/ -t takeovers/ -t vulnerabilities/ -t iot/ -l http-subs.txt -es info -etags ssl -rl 250 -bs 50
nuclei -t exposures/ -t misconfiguration/ -t miscellaneous/ -l http-subs.txt -es info -etags ssl -rl 250 -bs 50
