#!/bin/sh
# Invocation
# sh script "A description" "Name in wiki" "Local file"
# Example invocation
# sh -x /home/lmwangi/bin/curl_wiki.sh "RPKI diagram" rpki_net_diag.dia ~/rpki_net_diag.dia
wpdesc=$1
wpremotefile=$2
wplocalfile=$3
WIKIURI="https://wiki.domain.net/wiki/index.php"
WIKIUSERNAME=theUsername
WIKIPASSWORD=thePassword

curl -k  -d "wpName=${WIKIUSERNAME}&wpPassword=${WIKIPASSWORD}&wpLoginattempt=Log in" -c cookie \
 "$WIKIURI?title=Special:UserLogin&amp;action=submitlogin&amp;type=login"


#curl -k -b cookie  --data-binary "wpDestFile=$wpremotefile&wpUploadDescription=$wpdesc&wpUpload='Upload file'&wpUploadFile=@$wplocalfile" 
#        "$WIKIURI/Special:Upload"

#-F requires separate invocations. Upload a file using the cookie obtained above
curl -v -k -b cookie  -F "wpDestFile=$wpremotefile" \
 -F "wpUpload='Upload file'" -F "wpIgnoreWarning=true"\
 -F "wpUploadFile=@$wplocalfile" -F "wpUploadDescription=$wpdesc"\
 "$WIKIURI/Special:Upload"

