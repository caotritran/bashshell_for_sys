#/bin/bash
#exercise: Boi Chung
#description:
#Write a bash program to print out the console the integer numbers from a to b (b >= a, a and b input from keyboard) , 
#but if that number that is multiples of 7 then print out 'abc', if that number is multiples of 13 then print out 'xyz'. 
#For those numbers those are multiple of both 7 and 13 then print out 'a-z' .

echo -n "input 2 numbers, b >= a: "
read a b

if [ $b -ge $a ]; then
        for ((i=$a; i<=$b; i++ )); do
                if [ $(($i % 7)) -eq 0 ]; then
					echo -n "abc "
                elif [ $(($i % 13)) -eq 0 ]; then
					echo -n "xyz "
                elif [ $(($i % 7)) -eq 0 ] && [ $(($i % 13)) -eq 0 ]; then
					echo -n "a-z "
				else
					echo -n "$i "
                fi
        done
else
        echo "b=$b < a=$a, wrong!"
        exit 1
fi
