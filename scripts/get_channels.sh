curl -s http://localhost/api/v1/channels/availability.json | \
	grep '"id":' | tr -d ' ' |  tr -d '"' |  tr -d ',' | cut -d":" -f2 | \
	awk -F . '{print $1"_"$2}' | sort -u
