for i in {1..100000}; do
	dd if=/dev/zero of=test bs=1G count=1 conv=fdatasync
	echo "done lan thu $i"
	sleep 2
done
