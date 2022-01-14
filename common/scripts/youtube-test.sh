cd "/volume1/Entertainment/Youtube"
for dir in */; do
	cd "${dir}Extras"
	find . -name "*.mp4" -exec mv '{}' ../ \;
	cd "../../"
done	
