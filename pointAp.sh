#!/bin/bash
COUNT=1
PAP_AVAILABLE=0
FUNCTION=""

git diff develop | grep -E '^(commit|@@|[+]\s.+\WAp)' > diff.txt

while IFS= read -r LINE; do

        if echo $LINE | egrep '^[+]\s.+\WAp'; then
                if [ $PAP_AVAILABLE == 1 ] ;then
                        echo "Ap used, pAp is also available in ${FUNCTION} ${LINE}"
#                else
#                        echo "Ap used, because pAp is not available in ${FUNCTION} ${LINE}"
                fi
        elif echo $LINE | egrep '[(].+pAp.?[)]'; then
                PAP_AVAILABLE=1
                FUNCTION=$LINE
        elif echo $LINE | egrep '[(].?[)]'; then
                PAP_AVAILABLE=0
                FUNCTION=$LINE
        fi

done < diff.txt

