import Foundation
import CoreData

import ReVoModelojOSX
import ReVoDatumbazoOSX

print(FileManager.default.currentDirectoryPath)
let radiko = ""

let fontIndiko = radiko + "/fontoj"
var revoIndiko = fontIndiko + "/revo"
var grundIndiko = fontIndiko + "/grundo"

let produktajhIndiko = radiko + "/produktajhoj"
let konteksto = kreiDatumbazon(fontIndiko: radiko + "/fontoj", destino: produktajhIndiko + "/PoshReVoDatumbazo.sqlite")

// Legi grundaĵojn

let lingvoj = LingvoAnalizilo.legi(el: grundIndiko + "/cfg/lingvoj.xml")
LingvoAnalizilo.registri(lingvojn: lingvoj, en: konteksto)

let fakoj = FakoAnalizilo.legi(el: grundIndiko + "/cfg/fakoj.xml")
FakoAnalizilo.registri(fakojn: fakoj, en: konteksto)

let mallongigoj = MallongigoAnalizilo.legi(el: grundIndiko + "/cfg/mallongigoj.xml")
MallongigoAnalizilo.registri(mallongigojn: mallongigoj, en: konteksto)

StiloAnalizilo2.legi(el: grundIndiko + "/cfg/stiloj.xml", en: konteksto)
Oficialecoj.aldoni(al: konteksto)
let literoj = LiteroAnalizilo.legi(el: grundIndiko + "/cfg/literoj.xml")

// Legi artikolojn

var artikoloj: [Artikolo] = []
var serchTradukoj: [String: [SerchTraduko]] = [:]

let lingvoDict = lingvoj.reduce(into: [String: Lingvo]()) { dict, lingvo in
	dict[lingvo.kodo] = lingvo
}
if let rezulto = ArtikolAnalizilo.legi(
	el: revoIndiko + "/revo/abak.xml",
	en: konteksto,
	lingvoj: lingvoDict,
	literoj: literoj
) {
	artikoloj.append(rezulto.artikolo)
	
	for (lingvo, tradukoj) in rezulto.serchTradukoj {
		if serchTradukoj[lingvo] == nil {
			serchTradukoj[lingvo] = []
		}
		
		serchTradukoj[lingvo]? += tradukoj
	}
}

// Skribi artikolojn en datumbazon

var numero = 0
for artikolo in artikoloj {
	artikolo.skribi(en: konteksto, numero: numero)
	numero += 1
}

try! konteksto.save()

// Generi tekstojn

TekstFarilo.generiTekstojn(fakoj: fakoj, mallongigoj: mallongigoj, destinIndiko: produktajhIndiko)

// Fari trie-on

let trieFarilo = TrieFarilo(konteksto: konteksto, tradukaro: serchTradukoj)
trieFarilo.konstruiChiuTrie(kodoj: lingvoj.map { $0.kodo })

print("All done :)")
