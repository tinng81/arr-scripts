log () {
  m_time=`date "+%F %T"`
  echo $m_time" :: $scriptName :: $scriptVersion :: "$1
  echo $m_time" :: $scriptName :: $scriptVersion :: "$1 >> /config/logs/$scriptName.txt
}

logfileSetup () {
  # auto-clean up log file to reduce space usage
  if [ -f "/config/logs/$scriptName.txt" ]; then
    if find /config/logs -type f -name "$scriptName.txt" -size +1024k | read; then
      echo "" > /config/logs/$scriptName.txt
    fi
  fi
  
  if [ ! -f "/config/logs/$scriptName.txt" ]; then
    echo "" > /config/logs/$scriptName.txt
    chmod 666 "/config/logs/$scriptName.txt"
  fi
}

getArrAppInfo () {
  # Get Arr App information
  if [ -z "$arrUrl" ] || [ -z "$arrApiKey" ]; then
    arrUrlBase="$(xmllint --xpath "string(//UrlBase)" /config/config.xml)"
    if [ "$arrUrlBase" == "null" ]; then
      arrUrlBase=""
    else
      arrUrlBase="/$(echo "$arrUrlBase" | sed "s/\///g")"
    fi
    arrName="$(xmllint --xpath "string(//InstanceName)" /config/config.xml)"
    arrApiKey="$(xmllint --xpath "string(//ApiKey)" /config/config.xml)"
    arrPort="$(xmllint --xpath "string(//Port)" /config/config.xml)"
    arrUrl="http://127.0.0.1:${arrPort}${arrUrlBase}"
  fi
}

verifyApiAccess () {
  until false
  do
    arrApiTest=""
    arrApiVersion=""
    if [ "$arrPort" == "8989" ] || [ "$arrPort" == "7878" ]; then
      arrApiVersion="v3"
    elif [ "$arrPort" == "8686" ] || [ "$arrPort" == "8787" ]; then
      arrApiVersion="v1"
    fi
    arrApiTest=$(curl -s "$arrUrl/api/$arrApiVersion/system/status?apikey=$arrApiKey" | jq -r .instanceName)
    if [ "$arrApiTest" == "$arrName" ]; then
      break
    else
      log "$arrName is not ready, sleeping until valid response..."
      sleep 10
    fi
  done
}
