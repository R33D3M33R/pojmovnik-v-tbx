#!/usr/bin/python
# -*- coding: utf-8 -*-

import requests
import re
import codecs
from pyquery import PyQuery

__author__ = "Andrej Mernik"
__copyright__ = "Copyright 2014 Andrej Mernik"
__license__ = "GPLv3"

'''
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
'''


class PojmovnikVTBX:
    def __init__(self, pot):
        try:
            self.f = codecs.open(pot, 'w', 'utf-8')
            self.req = requests.get('https://wiki.lugos.si/slovenjenje:pojmovnik', verify=False)    # dobi spletno stran
            self.ustvari_tbx()
        except IOError:
            raise SystemExit('Napaka! Izhodne datoteke ni bilo mogoče odpreti, preverite pot in poskusite znova.')
        except requests.ConnectionError:
            raise SystemExit('Prišlo je do napake med povezovanjem s strežnikom.')
        except Exception as e:
            raise SystemExit('Prišlo je do neobravnavane napake. ' + e.message)

    def ustvari_tbx(self):
        if self.req.status_code is 200:
            self.f.write('<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE martif PUBLIC "ISO 12200:1999A//DTD MARTIF core (DXFcdV04)//EN" "TBXcdv04.dtd">\n<martif type="TBX" xml:lang="en_US">\n\t<text>\n\t\t<body>\n')
            stran = PyQuery(self.req.text)
            pojmovnik_tabela = stran.find('table.inline').html()
            pojmovnik_seznam = pojmovnik_tabela.split('\n')    # spremeni tabelo v seznam
            for pojem in pojmovnik_seznam:
                # izlušči samo par izvirnik => prevod
                najdi = re.search('<td>(.*)</td><td>(.*)</td><td>(.*)</td>', pojem)
                if najdi is not None:
                    opomba = najdi.group(3).strip()
                    if len(opomba) > 3:
                        opomba_termina = '\n\t\t\t\t\t\t<note>' + opomba + '</note>'
                    else:
                        opomba_termina = ''
                    self.f.write('\t\t<termEntry id="lugos-sl-' + self.pretvori_id(najdi.group(1).strip()) + '">\n\t\t\t<langSet xml:lang="en_US">\n\t\t\t\t<ntig>\n\t\t\t\t\t<termGrp>\n\t\t\t\t\t\t<term>' + najdi.group(1).strip() + '</term>\n\t\t\t\t\t</termGrp>\n\t\t\t\t</ntig>\n\t\t\t</langSet>\n\t\t\t<langSet xml:lang="sl">\n\t\t\t\t<ntig>\n\t\t\t\t\t<termGrp>\n\t\t\t\t\t\t<term>' + najdi.group(2).strip() + '</term>' + opomba_termina + '\n\t\t\t\t\t</termGrp>\n\t\t\t\t</ntig>\n\t\t\t</langSet>\n\t\t</termEntry>\n')
            self.f.write('\t\t</body>\n\t\t</text>\n</martif>')
            self.f.close()

    def pretvori_id(self, str):
        return re.sub('\-+', '-', (re.sub('[^\w]', '-', str)).lower())    # zamenjaj vse kar ni črka ali številka z minusom

if __name__ == "__main__":
    pot = '/home/andrej/Dropbox/prevod-KDE/terms.tbx'
    PojmovnikVTBX(pot)
