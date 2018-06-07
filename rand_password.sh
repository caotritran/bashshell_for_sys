question(){
	echo "Nhap do dai chuoi password genarate: "
	read n
}
question
echo n

while true; do
	if [ $n -ge 0 ]; then
		</dev/urandom tr -dc '12345qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c$n; echo ""
		break
	#elif [[ "$n" =~ ^[-+]?([1-9][[:digit:]]*|0)$ && "$n" -le 0 ]]; then
	else
		question
	fi
done
