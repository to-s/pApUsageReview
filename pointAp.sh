#!/bin/bash
COUNT=1
PAP_AVAILABLE=0
FUNCTION=""

echo "start"

set_comment() {

        API_HEADER="Accept: application/vnd.github.v3+json; application/vnd.github.antiope-preview+json"
        AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

        curl -sSL \
                -H "Content-Type: application/json" \
                -H "${AUTH_HEADER}" \
                -H "${API_HEADER}" \
                -X POST \
                -d "{\"body\":\"$1\"}" \
                "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${number}/comments"
}

cd /github/workspace

git diff origin/develop | grep -E '^(commit|@@|[+]\s.+\WAp)' > diff.txt

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

set_comment "checked"
