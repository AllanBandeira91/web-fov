#!/bin/bash

set -euo

API_URL="${API_URL:-http://localhost:8080}"
PUBLISH_URL="${API_URL}/ffmpeg/register"

mkdir -p tmp
cd tmp

wget -nc https://download.blender.org/demo/movies/BBB/bbb_sunflower_1080p_60fps_normal.mp4.zip
unzip -n bbb_sunflower_1080p_60fps_normal.mp4.zip

wget -nc https://download.blender.org/demo/movies/caminandes_gran_dillama.mp4.zip
unzip -n caminandes_gran_dillama.mp4.zip

curl --header "Content-Type: application/json" \
  --request POST \
  --data '{
    "streamId": "FOVDemo",
    "tracks": 2,
    "videoTrackNames": ["BigBuckBunny", "Caminandes 2: Gran Dillama"],
    "audioTracks": 2,
    "audioTrackNames": ["BigBuckBunny", "Caminandes 2: Gran Dillama"]
  }' \
  "$PUBLISH_URL"

ffmpeg -re \
  -stream_loop -1 -i "bbb_sunflower_1080p_60fps_normal.mp4" \
  -stream_loop -1 -i "caminandes_gran_dillama.mp4" \
  -map 0:v:0 -c:v:0 libx264 -preset veryfast -b:v:0 2000k -pix_fmt yuv420p \
  -map 1:v:0 -c:v:1 libx264 -preset veryfast -b:v:1 2000k -pix_fmt yuv420p \
  -map 0:a:0 -c:a:0 aac -b:a:0 128k \
  -map 1:a:0 -c:a:1 aac -b:a:1 128k \
  -f mpegts "${SRT_URL}"