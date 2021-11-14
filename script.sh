#!/bin/bash

# PLANSZA={"2"," "," ","2"," "," ","2"," "," ",}
PLANSZA=(" " " " " " " " " " " " " " " " " ")
KONIEC=0
GRACZ=1
function wyswietl {
    clear 
    echo "Plansza"
    for I in {0..8}
    do
        echo -n "${PLANSZA[$I]} | "
        if  [[ $I > 0 && $(( $I % 3 )) == 2 ]]
        then 
            echo "" 
        fi
    done
}

function sprawdz_wygrana {
    for POLE in {0..2}
    do
        let INDEX=POLE 
        if [[ ${PLANSZA[$INDEX]} -ne " " && ${PLANSZA[$INDEX]} -eq ${PLANSZA[$INDEX + 3]} 
         && ${PLANSZA[$INDEX]} -eq ${PLANSZA[$INDEX + 6]} ]]
        then
            let KONIEC=$GRACZ
        fi
        let INDEX=POLE*3 
        if [[ ${PLANSZA[$INDEX]} -ne " " && ${PLANSZA[$INDEX]} -eq ${PLANSZA[$INDEX + 1]} 
         && ${PLANSZA[$INDEX]} -eq ${PLANSZA[$INDEX + 2]} ]]
        then
            let KONIEC=$GRACZ
        fi
        if [[ ${PLANSZA[0]} -ne " " && ${PLANSZA[0]} -eq ${PLANSZA[4]}  && ${PLANSZA[0]} -eq ${PLANSZA[8]} ]]
        then
            let KONIEC=$GRACZ
        fi
        if [[ ${PLANSZA[6]} -ne " " && ${PLANSZA[6]} -eq ${PLANSZA[4]}  && ${PLANSZA[4]} -eq ${PLANSZA[2]} ]]
        then
            let KONIEC=$GRACZ
        fi
    done
}

function zmiana_gracza {
    let GRACZ=($GRACZ)%2+1 
}

function zaznacz {
    echo $1
    let PLANSZA[$1]="${GRACZ}"
}

while [ $KONIEC == 0 ]
do
    wyswietl
    echo "KOLEJ GRACZA ${GRACZ}"
    read POLE
    if [[ $POLE < 9 && $POLE -ge 0 && ${PLANSZA[$POLE]} -eq " " ]]
    then 
        zaznacz $POLE
        sprawdz_wygrana
        wyswietl
        zmiana_gracza
    fi
done
zmiana_gracza
echo "WYGRAŁ GRACZ NR.${GRACZ}"