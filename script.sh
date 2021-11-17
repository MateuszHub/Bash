#!/bin/bash
PLANSZA=(" " " " " " " " " " " " " " " " " " 9)
KONIEC=0
GRACZ=1
TRYB=""
PLIK_Z_ZAPISAMI=./saves

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
        if [[ ${PLANSZA[$INDEX]} -ne 0 && ${PLANSZA[$INDEX]} -eq ${PLANSZA[$INDEX + 3]} 
         && ${PLANSZA[$INDEX]} -eq ${PLANSZA[$INDEX + 6]} ]]
        then
            let KONIEC=$GRACZ
        fi
        let INDEX=POLE*3 
        if [[ ${PLANSZA[$INDEX]} -ne 0 && ${PLANSZA[$INDEX]} -eq ${PLANSZA[$INDEX + 1]} 
         && ${PLANSZA[$INDEX]} -eq ${PLANSZA[$INDEX + 2]} ]]
        then
            let KONIEC=$GRACZ
        fi
        if [[ ${PLANSZA[0]} -ne 0 && ${PLANSZA[0]} -eq ${PLANSZA[4]}  && ${PLANSZA[0]} -eq ${PLANSZA[8]} ]]
        then
            let KONIEC=$GRACZ
        fi
        if [[ ${PLANSZA[6]} -ne 0 && ${PLANSZA[6]} -eq ${PLANSZA[4]}  && ${PLANSZA[4]} -eq ${PLANSZA[2]} ]]
        then
            let KONIEC=$GRACZ
        fi
    done
}

function zmiana_gracza {
    let GRACZ=($GRACZ)%2+1 
}

function zaznacz {
    let PLANSZA[$1]="${GRACZ}"
}

function zapisz_informacje_o_trybie {
    if [[ $TRYB == "B" ]]
    then
        let PLANSZA[9]="8"
    else
        let PLANSZA[9]="9"
    fi
}

function wczytaj_informacje_o_trybie {
    if [[ ${PLANSZA[9]} -eq 8 ]]
    then
        TRYB="B"
    else
        TRYB="H"
    fi
}

function zapisz_stan {
    zapisz_informacje_o_trybie
    printf "%s\n" "${PLANSZA[@]}" > ${PLIK_Z_ZAPISAMI}
    echo "Zapisano!"
}

function wczytaj_stan {
    readarray -t PLANSZA < ${PLIK_Z_ZAPISAMI}      
    wczytaj_informacje_o_trybie
    ustal_gracza
}

function ustal_gracza {
    local LICZNIK_TUR=0;
    for I in {0..8}
    do
        if  [[ ${PLANSZA[$I]} -gt 0 ]]
        then 
            let LICZNIK_TUR=$(($LICZNIK_TUR+1));
        fi
    done
    echo $LICZNIK_TUR
    
    let GRACZ=($LICZNIK_TUR)%2+1 
    echo $GRACZ
    echo $TRYB
}


function wyborStanuGry {
    if [[ -s "$PLIK_Z_ZAPISAMI" ]]
    then
        echo "Czy chcesz wczytać zapis? T/N"
        read ODPOWIEDZ
        if [ $ODPOWIEDZ == "T" ]
        then
            wczytaj_stan
        else 
            nowa_gra
        fi
    else
        nowa_gra
    fi         

}

function nowa_gra {
    while [[ $TRYB != "B" && $TRYB != "H" ]] 
    do
        echo "Wybierz tryb gry: B - (bot)gra z komputerem, H - hot seat"
        read TRYB
    done    
}
function standardowa_obsluga {
    if [[ $1 -lt 9 && $1 -ge 0 && ${PLANSZA[$1]} -eq " " ]]
    then 
        zaznacz $1
        sprawdz_wygrana
        wyswietl
        zmiana_gracza
    fi
}
function obsluga_czlowieka {
    
        echo "Aby zapisać stan gry wpisz S"
        echo "KOLEJ GRACZA ${GRACZ}"
        read WEJSCIE
        
        standardowa_obsluga $WEJSCIE
        
        if [[ $WEJSCIE -eq "S" ]]
        then
            zapisz_stan
        fi
}

function obsluga_bota {
        echo "KOLEJ BOTA ${GRACZ}"
        standardowa_obsluga $(($RANDOM%9))
    
}

wyborStanuGry
while [ $KONIEC == 0 ]
do
    wyswietl
    if [[ $GRACZ -eq 1 || $TRYB == "H" ]]
    then
        obsluga_czlowieka
    elif [[ $TRYB == "B" && $GRACZ -eq 2 ]]
    then
        obsluga_bota
    fi
done
zmiana_gracza
echo "WYGRAŁ GRACZ NR.${GRACZ}"
