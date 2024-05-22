#!/bin/sh

mkdir -p "../datasetDN/"

wget -r -np -nH --max-threads=100 -o "download_yats.log" --limit-rate=0 --cut-dirs=5 --accept-regex "(2020)(03|04|05)([0-3][0-9])_(02|06|10|14|18|22)(00)([0-5][0-9])\.WAV" -P "../datasetDN/" http://colecciones.humboldt.org.co/rec/sonidos/publicaciones/MAP/JDT-Yataros/YAT1Audible/ http://colecciones.humboldt.org.co/rec/sonidos/publicaciones/MAP/JDT-Yataros/YAT2Audible/ http://colecciones.humboldt.org.co/rec/sonidos/publicaciones/MAP/JDT-Yataros/YAT3Audible/