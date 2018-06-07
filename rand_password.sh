question(){
        echo "Nhap do dai chuoi password genarate: "
        read n
}
question
echo "do dai chuoi password la: $n"

while true; do
        if [ $n -gt 0 ]; then
                </dev/urandom tr -dc '12345qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c$n; echo ""
                break
        #elif [[ "$n" =~ ^[-+]?([1-9][[:digit:]]*|0)$ && "$n" -le 0 ]]; then
        else
                echo "do dai chuoi password phai lon hon 0!"
                question
        fi
done
