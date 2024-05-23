#!/bin/sh

set -e

mkdir -p "./datasetAll/"

wget -r -v -nc -np -nH --max-threads=30 -a "download_yats.log" --limit-rate=0 --cut-dirs=5 --accept-regex "([1,2]{1}[0-9]{3})([0,1]{1}[0-9]{1})([0-3]{1}[0-9]{1})_([0-2]{1}[0-9]{1})([0-5]{1}[0-9]{1})([0-5][0-9])\.WAV" -P "./datasetAll/" http://colecciones.humboldt.org.co/rec/sonidos/publicaciones/MAP/JDT-Yataros/YAT1Audible/