import Foundation
import CoreData

let komencTempo = Date()

// Indikoj

let radiko = "/Users/robin/Desktop"

let fontIndiko = radiko + "/fontoj"
var revoIndiko = fontIndiko + "/revo/revo/"
var grundIndiko = fontIndiko + "/grundo"

let produktajhIndiko = radiko + "/produktajhoj"

// Datumbazaĵoj

let konteksto = kreiDatumbazon(destino: produktajhIndiko + "/PoshReVoDatumbazo.sqlite")

// Legi grundaĵojn

print("Legas grundon")

let grundo = Grundo.legi(el: grundIndiko)
grundo.skribi(json: produktajhIndiko)
grundo.skribi(en: konteksto)

// Legi artikolojn

print("Legas artikolojn")

let artikolAnalizajho = Artikolaro.legi(el: revoIndiko, grundo: grundo)
let artikolSkribajho = Artikolaro.skribi(artikolojn: artikolAnalizajho.artikoloj, en: konteksto)

// Skribi vortlistojn

print("Skribas vortlistojn")

VortListoj.skribi(
	fakVortojn: artikolAnalizajho.fakVortoj,
	artikolObjektoj: artikolSkribajho.artikoloj,
	en: konteksto)
VortListoj.skribi(
	ofcVortojn: artikolAnalizajho.ofcVortoj,
	artikolObjektoj: artikolSkribajho.artikoloj,
	en: konteksto
)

// Fari trie-on

let prefiksArboFarilo = PrefiksArboFarilo(
	konteksto: konteksto,
	serchVortoj: artikolAnalizajho.serchVortoj,
	tradukaro: artikolAnalizajho.tradukoj,
	artikolObjektoj: artikolSkribajho.artikoloj
)
prefiksArboFarilo.kreiArbojn()
prefiksArboFarilo.skribi(en: konteksto)

// Generi tekstojn

// TekstFarilo.generiTekstojn(fakoj: fakoj, mallongigoj: mallongigoj, destinIndiko: produktajhIndiko)

print("Ĉion finis :)")

let dauro = Date().timeIntervalSince(komencTempo)
print("- Daŭris " + DateComponentsFormatter().string(from: dauro)!)
