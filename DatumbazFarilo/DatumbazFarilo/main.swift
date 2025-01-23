import Foundation
import CoreData

import ReVoModelojOSX
import ReVoDatumbazoOSX

print(FileManager.default.currentDirectoryPath)
let radiko = ""

let fontIndiko = radiko + "/fontoj"
var revoIndiko = fontIndiko + "/revo/revo/"
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

let stiloj = StiloAnalizilo.legi(el: grundIndiko + "/cfg/stiloj.xml")
StiloAnalizilo.registri(stilojn: stiloj, en: konteksto)

Oficialecoj.aldoni(al: konteksto)
let literoj = LiteroAnalizilo.legi(el: grundIndiko + "/cfg/literoj.xml")

// Legi artikolojn

var artikolRezultoj: [ArtikolAnalizRezulto] = []

let legotaj = [
	// "om.xml"
	"not.xml"
]

// let legotaj = try! FileManager.default.contentsOfDirectory(atPath: revoIndiko)

let lingvoDict = lingvoj.reduce(into: [String: Lingvo]()) { dict, lingvo in
	dict[lingvo.kodo] = lingvo
}

let stiloDict = stiloj.reduce(into: [String: String]()) { dict, stilo in
	dict[stilo.kodo] = stilo.nomo
}

func legiArtikolon(che indiko: String, lingvoDict: [String: Lingvo], stiloDict: [String: String]) -> ArtikolAnalizRezulto? {
	if let rezulto = ArtikolAnalizilo.legi(
		el: indiko,
		en: konteksto,
		lingvoj: lingvoDict,
		stiloj: stiloDict,
		literoj: literoj
	) {
		return rezulto
	}
	
	return nil
}

var artikoloj: [Artikolo] = []
var serchTradukoj: [String: [SerchTraduko]] = [:]
var markSencoj: [String: Int] = [:]

for indiko in legotaj {
	guard let rezulto = legiArtikolon(che: revoIndiko + indiko, lingvoDict: lingvoDict, stiloDict: stiloDict) else {
		continue
	}
	
	artikoloj.append(rezulto.artikolo)
	for subartikolo in rezulto.artikolo.subartikoloj {
		print(subartikolo.teksto)
		print(subartikolo.vortoj.forEach { print($0.titolo + " (\($0.ofc ?? "n"))" + "\n---\n" + $0.teksto + "\n\n--------\n\n")})
	}
	
	for (lingvo, tradukoj) in rezulto.serchTradukoj {
		if serchTradukoj[lingvo] == nil {
			serchTradukoj[lingvo] = []
		}
		
		serchTradukoj[lingvo]? += tradukoj
	}
	
	rezulto.markSencoj.forEach { marko, senco in
		markSencoj[marko] = senco
	}
}

// Posttrakti artikolojn

artikoloj = artikoloj.map { artikolo in
	return postTrakti(artikolon: artikolo, markSencoj: markSencoj)
}

// Skribi artikolojn en datumbazon

var numero = 0
for artikolo in artikoloj {
	artikolo.skribi(en: konteksto, numero: numero)
	numero += 1
}

try! konteksto.save()

// Fari trie-on

// let trieFarilo = TrieFarilo(konteksto: konteksto, tradukaro: serchTradukoj)
// trieFarilo.konstruiChiuTrie(kodoj: lingvoj.map { $0.kodo })

// Generi tekstojn

// TekstFarilo.generiTekstojn(fakoj: fakoj, mallongigoj: mallongigoj, destinIndiko: produktajhIndiko)

print("All done :)")
