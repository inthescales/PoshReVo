import Foundation
import CoreData

let komencTempo = Date()

// Indikoj

let radiko = "/Users/robin/Desktop"

let fontIndiko = radiko + "/fontoj"
let grundIndiko = fontIndiko + "/grundo"
let revoIndiko = fontIndiko + "/revo"
let artikolIndiko = revoIndiko + "/revo/"

let produktajhIndiko = radiko + "/produktajhoj"

// Datumbazaĵoj

let konteksto = ReVoDatumbazo.kreiDatumbazon(destino: produktajhIndiko + "/PoshReVoDatumbazo.sqlite")

// Legi grundaĵojn

print("Legas grundon")

let grundo = Grundo.legi(el: grundIndiko)
grundo.skribi(json: produktajhIndiko)
grundo.skribi(en: konteksto)

// Legi neartikolajn revaĵojn

print("Legas bibliografion")

let bibliografioIndiko = revoIndiko + "/cfg/bibliogr.xml"
let bibliografio = BibliografioAnalizilo.legi(el: bibliografioIndiko, grundo: grundo)

// Legi artikolojn

print("Legas artikolojn")

let artikolAnalizajho = Artikolaro.legi(el: artikolIndiko, grundo: grundo)
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

MallongigoListoj.generiDosieron(
	fakoj: grundo.fakoj,
	mallongigoj: grundo.mallongigojVortaraj,
	bibliografio: bibliografio,
	destinIndiko: produktajhIndiko
)

print("Ĉion finis :)")

let dauro = Date().timeIntervalSince(komencTempo)
print("- Daŭris " + DateComponentsFormatter().string(from: dauro)!)
