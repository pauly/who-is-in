#!/bin/bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/config.sh

arp-scan --interval=2 --localnet --interface=wlan0 --retry=3 --quiet | grep 192.168 > /tmp/arp-scan.txt
while read LINE; do
  FILE=$(echo "${LINE}" | cut -f2).txt
  NAME=$(echo "${LINE}" | cut -f3)
  echo ${NAME} > ${FOLDER}/${FILE}
  if [ -f ${FOLDER}/.alias.${FILE} ]; then
    cp ${FOLDER}/.alias.${FILE} ${FOLDER}/${FILE} 
  fi
done < /tmp/arp-scan.txt

echo "<!doctype html><html><head>"
echo "<title>Who is in?</title>"
echo "<link rel=\"manifest\" href=\"scan-manifest.json\">"
echo "<style>a {text-decoration: none}</style>"
echo "</head><body><ol>"
$DIR/status.sh
echo "</ol></body></html>"