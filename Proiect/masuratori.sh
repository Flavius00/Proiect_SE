K_MAX=5

rm -f masuratoare.csv
touch masuratoare.csv


for ((k=1; k<=K_MAX; k++)); do
    echo "(batch go)
    (exit)
    " | clips > masuratori.tmp.txt
    cat masuratori.tmp.txt | grep "Decision time:" | cut -d: -f2 | cut -d\  -f2 | tr '\n' '\t' >> masuratoare.csv 
    echo '' >> masuratoare.csv
    rm -f masuratori.tmp.txt
done