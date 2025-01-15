import Foundation
import CoreData
import ReVoModelojOSX
import ReVoDatumbazoOSX

print(FileManager.default.currentDirectoryPath)
let radiko = ""
var revoIndiko: String = radiko + "/fontoj/revo"
var grundIndiko: String = radiko + "/fontoj/grundo"

let konteksto = kreiDatumbazon(fontIndiko: radiko + "/fontoj", destino: radiko + "/PoshReVoDatumbazo.sqlite")

// Legi grundaĵojn

let lingvoj = LingvoAnalizilo2.legi(el: grundIndiko + "/cfg/lingvoj.xml")
LingvoAnalizilo2.registri(lingvojn: lingvoj, en: konteksto)
FakoAnalizilo2.legi(el: grundIndiko + "/cfg/fakoj.xml", en: konteksto)
MallongigoAnalizilo2.legi(el: grundIndiko + "/cfg/mallongigoj.xml", en: konteksto)
StiloAnalizilo2.legi(el: grundIndiko + "/cfg/stiloj.xml", en: konteksto)
Oficialecoj.aldoni(al: konteksto)
let literoj = LiteroAnalizilo.legi(el: grundIndiko + "/cfg/literoj.xml")

// Legi artikolojn

var artikoloj: [Artikolo] = []
var serchTradukoj: [String: [SerchTraduko]] = [:]

if let rezulto = ArtikolAnalizilo.legi(
	el: revoIndiko + "/revo/abak.xml",
	en: konteksto,
	lingvoj: lingvoj,
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
	let dbObjekto = NSEntityDescription.insertNewObject(forEntityName: "Artikolo", into: konteksto)
	dbObjekto.setValue(artikolo.titolo, forKey: "titolo")
	dbObjekto.setValue(artikolo.radiko, forKey: "radiko")
	dbObjekto.setValue(artikolo.indekso, forKey: "indekso")
	dbObjekto.setValue(artikolo.ofc, forKey: "ofc")
	
	var subartArr = [[String: Any]]()
	for subartikolo in artikolo.subartikoloj {
		var novaSubart = [String: Any]()
		novaSubart["teksto"] = subartikolo.teksto
		
		var vortArr = [[String: Any]]()
		for vorto in subartikolo.vortoj {
			var novaVorto = [String: Any]()
			novaVorto["titolo"] = vorto.titolo
			novaVorto["teksto"] = vorto.teksto
			novaVorto["marko"] = vorto.marko
			novaVorto["ofc"] = vorto.ofc
			vortArr.append(novaVorto)
		}
		novaSubart["vortoj"] = vortArr
		
		subartArr.append(novaSubart)
	}
	
	let vortoJSON = try JSONSerialization.data(withJSONObject: subartArr, options: JSONSerialization.WritingOptions())
	dbObjekto.setValue(vortoJSON, forKey: "vortoj")
	
	var tradukArr = [String: Any?]()
	for traduko in artikolo.tradukoj {
		tradukArr[traduko.lingvo.kodo] = traduko.teksto
	}
	
	let tradukoJSON = try JSONSerialization.data(withJSONObject: tradukArr, options: JSONSerialization.WritingOptions())
	dbObjekto.setValue(tradukoJSON, forKey: "tradukoj")
	
	dbObjekto.setValue(numero, forKey: "numero")
	dbObjekto.setValue([], forKey: "destinoj")
	
	numero += 1
}

try! konteksto.save()

print("All done :)")
