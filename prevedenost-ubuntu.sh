#!/bin/bash

#Avtor: Andrej Mernik, 2014-2017, https://andrej.mernik.eu/
#Licenca: GPLv3

jezik_a="sl"
jezik_b="pt" # izberemo jezik, ki je najbolj preveden
prvi_zagon=1 # nastavite ali je to prvi zagon (1|0)
statistika="statistika.txt" # izhodna datoteka s statističnimi podatki

skupno_a=0
skupno_b=0

if [ $prvi_zagon == 1 ]
then
  sudo apt-get install dselect gettext
  # posodobi podatkovno zbirko dselect
  sudo dselect update

  # namestitev jezikovnih paketov
  dpkg --get-selections | grep -E "\-$jezik_a.*install" | while read -r vrstica ; do
    echo "${vrstica/-$jezik_a/-$jezik_b}" | sudo dpkg --set-selections
  done
  sudo apt-get -y dselect-upgrade
fi

echo "Posodabljanje locatedb"
sudo updatedb
echo "paket $jezik_a $jezik_b odst." > $statistika

while read -r vrstica ; do
    mapa=$(dirname $vrstica)
    datoteka=$(basename $vrstica)
    ime_datoteke="${datoteka%.*}"
    echo "Obdelovanje $ime_datoteke v mapi $mapa: jezik $jezik_a"
    msgunfmt "$mapa/$datoteka" -o /tmp/tmp.po
    prevedenost_b=$(msgfmt --statistics -o /dev/null /tmp/tmp.po 2>&1 | awk -F' ' '{print $1}')
    mapa=${mapa/\/$jezik_b\//\/$jezik_a\//}
    if [ -f "$mapa/$datoteka" ]; then
      echo " jezik $jezik_b"
      msgunfmt "$mapa/$datoteka" -o /tmp/tmp.po
      prevedenost_a=$(msgfmt --statistics -o /dev/null /tmp/tmp.po  2>&1 | awk -F' ' '{print $1}')
    else
      echo "$ime_datoteke ne obstaja za jezik $jezik_a"      
      prevedenost_a=0
    fi
    odstotek=$(bc <<< "scale=2;$prevedenost_a/$prevedenost_b*100")
    if [ $(echo " $odstotek < 100" | bc) -eq 1 ]; then
      echo "$ime_datoteke $prevedenost_a $prevedenost_b $odstotek" >> $statistika
    fi
    skupno_a=$(bc <<< "scale=0;$skupno_a+$prevedenost_a")
    skupno_b=$(bc <<< "scale=0;$skupno_b+$prevedenost_b")    

done < <(locate --regexp ^\/usr\/.*\/$jezik_b\/.*\.mo$)
koncni_odstotek=$(bc <<< "scale=2;$skupno_a/$skupno_b*100")    
echo "total $skupno_a $skupno_b $koncni_odstotek" >> $statistika
