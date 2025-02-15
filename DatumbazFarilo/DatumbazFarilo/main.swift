import Foundation
import CoreData

import ReVoModelojOSX
import ReVoDatumbazoOSX

let komencTempo = Date()

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

print("Legas grundon")

let grundo = Grundo.legi(el: grundIndiko)
grundo.skribi(json: produktajhIndiko)
grundo.skribi(en: konteksto)

// Legi artikolojn
let finTempo = Date()
let dauro = finTempo.timeIntervalSince(komencTempo)

print("Legas artikolojn")

let artikolRezultoj = Artikolaro.legi(el: revoIndiko, grundo: grundo)
Artikolaro.skribi(artikolojn: artikolRezultoj.artikoloj, en: konteksto)

// Skribi vortlistojn

print("Skribas vortlistojn")

VortListoj.skribi(fakVortojn: artikolRezultoj.fakVortoj, en: konteksto)
VortListoj.skribi(ofcVortojn: artikolRezultoj.ofcVortoj, en: konteksto)

// Fari trie-on

let prefiksArboFarilo = PrefiksArboFarilo(
	konteksto: konteksto,
	serchVortoj: artikolRezultoj.serchVortoj,
	tradukaro: artikolRezultoj.tradukoj
)
prefiksArboFarilo.konstruiChiunArbon(kodoj: grundo.lingvoj.map { $0.kodo })

// Generi tekstojn

// TekstFarilo.generiTekstojn(fakoj: fakoj, mallongigoj: mallongigoj, destinIndiko: produktajhIndiko)

print("Ĉion finis :)")
print("- Daŭris " + DateComponentsFormatter().string(from: dauro)!)
