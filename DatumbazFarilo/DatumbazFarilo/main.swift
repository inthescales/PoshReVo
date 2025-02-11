import Foundation
import CoreData

import ReVoModelojOSX
import ReVoDatumbazoOSX

// Indikoj

let radiko = "/Users/robin/Desktop"

let fontIndiko = radiko + "/fontoj"
var revoIndiko = fontIndiko + "/revo/revo/"
var grundIndiko = fontIndiko + "/grundo"

let produktajhIndiko = radiko + "/produktajhoj"

// Datumbazaĵoj

let konteksto = kreiDatumbazon(
	fontIndiko: radiko + "/fontoj",
	destino: produktajhIndiko + "/PoshReVoDatumbazo.sqlite"
)

// Legi grundaĵojn

let grundo = Grundo.legi(el: grundIndiko)
grundo.skribi(json: produktajhIndiko)

// Legi artikolojn

let artikolRezultoj = Artikolaro.legi(el: revoIndiko, grundo: grundo)
Artikolaro.skribi(artikolojn: artikolRezultoj.artikoloj, en: konteksto)

// Fari trie-on

// let trieFarilo = TrieFarilo(konteksto: konteksto, tradukaro: serchTradukoj)
// trieFarilo.konstruiChiuTrie(kodoj: lingvoj.map { $0.kodo })

// Generi tekstojn

// TekstFarilo.generiTekstojn(fakoj: fakoj, mallongigoj: mallongigoj, destinIndiko: produktajhIndiko)

print("All done :)")
