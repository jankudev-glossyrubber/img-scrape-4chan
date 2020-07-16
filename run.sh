#!/usr/bin/env bash

DEST="${VOLUME_DEST}"
if [[ -z "${DEST}" ]]; then
	DEST=$(pwd)
fi

function printBlock {
	echo ""
	echo "==============================="
	echo " $1"
	echo "==============================="
}

echo "Scraping from 4chan threads..."

printBlock "Artistic nudes" 
./scrape.sh wg 'artistic nudes|hegre|elegant ladies|angels' "${DEST}/img/art_nude"

printBlock "Space"
./scrape.sh wg 'space' "${DEST}/img/space"

printBlock "Emma Watson"
./scrape.sh hr 'emma watson' "${DEST}/img/emma_watson"

printBlock "Models"
./scrape.sh hr 'model' "${DEST}/img/models"

printBlock "Redheads"
./scrape.sh s 'red hair|redhead|red head|ginger' "${DEST}/img/redhead"

printBlock "Latex"
./scrape.sh s latex "${DEST}/img/latex"

printBlock "B.D.S.M."
./scrape.sh s 'bondage|bdsm|dominant|mistress' "${DEST}/img/bondage"

printBlock "Swim suits"
./scrape.sh s 'swimsuit|bikini' "${DEST}/img/swimsuit"

printBlock "Petite Women"
./scrape.sh s 'petite' "${DEST}/img/petite"

printBlock "Blonde"
./scrape.sh hr 'blonde' "${DEST}/img/blonde"
./scrape.sh s 'blonde' "${DEST}/img/blonde"

printBlock "You become the girl below"
./scrape.sh s 'you become the girl' "${DEST}/img/ybtgb"
./scrape.sh hr 'you become the girl' "${DEST}/img/ybtgb"

printBlock "Women in fur"
./scrape.sh s 'fur thread' "${DEST}/img/fur"

printBlock "Wallpapers"
./scrape.sh hr 'current wallpaper' "${DEST}/img/wallpapers"
./scrape.sh wg 'nature|mountain|forrest' "${DEST}/img/wallpapers"

printBlock "Sci-fi, cyberpunk and steampunk"
./scrape.sh wg 'sci-?fi|science|fractal|math|steampunk|cyberpunk' "${DEST}/img/scifi"
