#!/usr/bin/env bash

# params check
if [[ $# -ne 2 ]] && [[ $# -ne 3 ]]; then
	echo "Usage: ./scrape.sh BOARD TERMS DEST"
	echo "Download media content from 4chan.org from BOARD threads containing TERMS into DEST"
	echo "Example: ./scrape.sh 's' 'latex thread' 'img/latex'"
	exit 1
fi

# config properties
BOARD="$1"		
TERMS="$2" #Latex Thread, Swimsuit, Got Tier, bondage, fur thread
DEST="$3"

# static properties
WAIT=1
CURL_CMD="curl -s -S"
API_URL="https://a.4cdn.org"
IMG_API_URL="https://i.4cdn.org"

# temp and cleanup
tmp_dir=$(mktemp -d)
trap "rm -rf ${tmp_dir}" EXIT

# create dest if not existent
mkdir -p "${DEST}"

# randomize sleep timer in ms between WAIT_LBOUND_MS, WAIT_HBOUND_MS
function fn_randomSleepMs {
	sleep $(bc -l <<< "scale=2 ; ${RANDOM} / (32767 / 2)")
}

# scraping
for page_num in `seq 1 10`; do
	# board page content
	page_url="${API_URL}/${BOARD}/${page_num}.json"
	page_file="${tmp_dir}/scrape_${page_num}.json"

	echo "Parsing page ${page_url}"
	${CURL_CMD} -o "${page_file}" "${page_url}"

	# find threads in stream by sub (description) or com (comment detail)
	threads_file="${tmp_dir}/threads.list"
	cat "${page_file}" | jq ".threads | .[] | .posts | .[] | select(.sub!=null) | select(.sub|test(\"${TERMS}\"; \"i\")) | .no" > "${threads_file}"
	cat "${page_file}" | jq ".threads | .[] | .posts | .[] | select(.com!=null) | select(.com|test(\"${TERMS}\"; \"i\")) | .no" >> "${threads_file}"

	while read thread_id; do
		thread_url="${API_URL}/${BOARD}/thread/${thread_id}.json"	
		thread_file="${tmp_dir}/scrape_${thread_id}.json"
		
		echo "Found thread for terms \"${TERMS}\", parsing thread ${thread_url}"
		${CURL_CMD} -o "${thread_file}" "${thread_url}"
		
		# extract images md5, id, filetype from thread posts view (md5 for duplicity checking cross-threads)
		images_file="${tmp_dir}/images.list"
		cat "${thread_file}" | jq '.posts | .[] | select(.filename!=null) | .md5+":"+(.tim|tostring)+":"+.ext' | sed 's:"::g' > "${images_file}"
		
		fn_randomSleepMs

		# download images
		while read image_info; do
			md5=$(echo "${image_info}" | cut -f1 -d\:  | sed 's:/:-:g') 
			img_id=$(echo "${image_info}" | cut -f2 -d\:)
			img_ext=$(echo "${image_info}" | cut -f3 -d\:)
		
			# skip existing by name (since its composed of md5 hash)
			if [[ -f "${DEST}/${md5}${img_ext}" ]]; then
				#echo "Image already downloaded ${img_id}${img_ext} (md5: ${md5})"
				continue
			fi

			img_url="${IMG_API_URL}/${BOARD}/${img_id}${img_ext}"

			echo "Downloading image ${img_url}"
			${CURL_CMD} -o "${DEST}/${md5}${img_ext}" "${img_url}"

			fn_randomSleepMs	
		
		done < "${images_file}"
		
		fn_randomSleepMs

	done < "${threads_file}"	

	fn_randomSleepMs
done
