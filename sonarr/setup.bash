#!/usr/bin/with-contenv bash

echo "************ install packages ************" && \
apt-get -qqy update && \
apt-get -qqy install \
    libxml2-utils
	flac \
	opus-tools \
	jq \
	git \
	wget \
	mkvtoolnix \
	python3-dev \
	libc-dev \
	python3-pip \
	gcc \
	ffmpeg

echo "************ install python packages ************" && \
pip3 install --upgrade --no-cache-dir -U \
	excludarr \
	xq \
  yt-dlp \
	yq

mkdir -p /custom-services.d
echo "Download AutoExtras service..."
curl https://raw.githubusercontent.com/tinng81/arr-scripts/main/sonarr/AutoExtras.service -o /custom-services.d/AutoExtras &>/dev/null
echo "Done"

echo "Download YoutubeSeriesDownloader service..."
curl https://raw.githubusercontent.com/tinng81/arr-scripts/main/sonarr/YoutubeSeriesDownloader.service -o /custom-services.d/YoutubeSeriesDownloader &>/dev/null
echo "Done"

mkdir -p /config/extended
echo "Download Naming script..."
curl https://raw.githubusercontent.com/tinng81/arr-scripts/main/sonarr/naming.json -o /config/extended/naming.json &>/dev/null
echo "Done"

mkdir -p /config/extended
echo "Download Script Functions..."
curl https://raw.githubusercontent.com/tinng81/arr-scripts/main/universal/functions.bash -o /config/extended/functions &>/dev/null
echo "Done"

echo "Download Extras script..."
curl https://raw.githubusercontent.com/tinng81/arr-scripts/main/sonarr/Extras.bash -o /config/extended/Extras.bash  &>/dev/null
echo "Done"

if [ ! -f /config/extended.conf ]; then
	echo "Download Extended config..."
	curl https://raw.githubusercontent.com/tinng81/arr-scripts/main/sonarr/extended.conf -o /config/extended.conf &>/dev/null
	chmod 777 /config/extended.conf
	echo "Done"
fi

chmod 777 -R /config/extended

exit
