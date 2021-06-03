#!/run/current-system/sw/bin/bash

#curl -s -H "Accept-Language: ${LANG%_*}" --compressed "wttr.in/Linz?T&format=3"
curl -Ss 'https://wttr.in?0&T&Q33' | cut -c 16- | head -3 | xargs echo

