#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0 ]}" )" && pwd )
source $DIR/config.sh

WANTED=$(echo "${1//[^a-zA-Z]/}" | tr '[a-z]' '[A-Z]')
DATE=$(date +%s)
for FILE in $(ls -1tr ${FOLDER}); do
  MTIME=$(stat -c %Y ${FOLDER}/${FILE})
  DIFF=$(expr ${DATE} - ${MTIME})
  STATUS=✓
  AWAYMSG=
  if [ ${DIFF} -gt 600 ]; then
    AWAYMSG=" since $(ls -l ${FOLDER}/${FILE} | cut -d' ' -f5-8)"
    STATUS=❌
  fi
  NAME=$(cat ${FOLDER}/${FILE})
  VAR=$(echo "${NAME//[^a-zA-Z]/}" | tr '[a-z]' '[A-Z]')
  if [ "${WANTED}" == "${VAR}" ]; then
    if [ ${STATUS} == ✓ ]; then
      exit 0
    fi
    exit 1
  fi
  DETAIL="${STATUS} ${NAME}${AWAYMSG}"
  echo "<li><a href=\"${FOLDER/${DOCROOT}/}/.log.${FILE}\">${DETAIL}</a></li>"
  PREVIOUS=$(cat ${FOLDER}/.previous.${FILE} 2> /dev/null)
  [ "${PREVIOUS}" != "${DETAIL}" ] && echo "$(date +'%F %H:%M') ${DETAIL}" >> ${FOLDER}/.log.${FILE}
  [ "${PREVIOUS}" != "${DETAIL}" ] && echo "${DETAIL}" > ${FOLDER}/.previous.${FILE}
  [ "${STATUS}" == ✓ ] && touch ${FOLDER}/${FILE}
  # if [ "${PREVIOUS}" != "${DETAIL}" ]; then
  #   echo "$(date +'%F %H:%M') ${DETAIL}" >> ${FOLDER}/.log.${FILE}
  #   echo "${DETAIL}" > ${FOLDER}/.previous.${FILE}
  # fi
done
