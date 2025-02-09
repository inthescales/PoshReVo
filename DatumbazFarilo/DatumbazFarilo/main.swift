import Foundation
import CoreData

import ReVoModelojOSX
import ReVoDatumbazoOSX

let radiko = "/Users/robin/Desktop"

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

let vortarajMallongigoj = VortarajMallongigojAnalizilo.legi(el: grundIndiko + "/cfg/mallongigoj.xml")
VortarajMallongigojAnalizilo.registri(mallongigojn: vortarajMallongigoj, en: konteksto)

let stiloj = StiloAnalizilo.legi(el: grundIndiko + "/cfg/stiloj.xml")
StiloAnalizilo.registri(stilojn: stiloj, en: konteksto)

Oficialecoj.aldoni(al: konteksto)

let signoj = SignoAnalizilo.analizi(el: grundIndiko + "/dtd/vokosgn.dtd")

let verkajMallongigoj = DTDAnalizilo.entoj(el: grundIndiko + "/dtd/vokomll.dtd")

let urloj = DTDAnalizilo.entoj(el: grundIndiko + "/dtd/vokourl.dtd")

// Legi artikolojn

let artikolRezultoj = Artikolaro.legi(
	el: revoIndiko,
	lingvoj: lingvoj,
	stiloj: stiloj,
	signoj: signoj,
	mallongigoj: verkajMallongigoj,
	urloj: urloj
)
Artikolaro.registri(artikolojn: artikolRezultoj.artikoloj, en: konteksto)

// Fari trie-on

// let trieFarilo = TrieFarilo(konteksto: konteksto, tradukaro: serchTradukoj)
// trieFarilo.konstruiChiuTrie(kodoj: lingvoj.map { $0.kodo })

// Generi tekstojn

// TekstFarilo.generiTekstojn(fakoj: fakoj, mallongigoj: mallongigoj, destinIndiko: produktajhIndiko)

print("All done :)")
