import Foundation
import CoreData

import ReVoModelojOSX
import ReVoDatumbazoOSX

/// Analizas XMLan dosieron enhavantan liston da mallongigoj, kaj aldonas ilin al la datumbazo
/// Parses the XML file containing the list of abbreviations, and adds them to the database
class MallongigoAnalizilo: NSObject, XMLParserDelegate {
	var mallongigoj: [Mallongigo] = []
	
	private var nunaMallongigo: String?
	private var teksto: String = ""
	
	override init() {
		super.init()
		print("Legas mallingigojn")
	}
	
	func parserDidEndDocument(_ parser: XMLParser) {
		print("Legis \(mallongigoj.count) mallongigojn")
	}
	
	func parser(
		_ parser: XMLParser,
		didStartElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?,
		attributes attributeDict: [String : String] = [:]
	) {
		if elementName == "mallongigo",
			let mll = attributeDict["mll"] {
			nunaMallongigo = mll
			teksto = ""
		}
	}
	
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		teksto += string
	}
	
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if elementName == "mallongigo",
		   let nunaMallongigo = nunaMallongigo {
			mallongigoj.append(Mallongigo(kodo: nunaMallongigo, nomo: teksto))
		}
	}
}

// MARK: - Vokilo

extension MallongigoAnalizilo {
	public static func registri(
		mallongigojn mallongigoj: [Mallongigo],
		en konteksto: NSManagedObjectContext) {
		for mallongigo in mallongigoj {
			mallongigo.skribi(en: konteksto)
		}
		
		try! konteksto.save()
	}
	
	/// Legas mallongigojn el la donata indikilo, en la donatan datumbaz-kontekston
	/// Reads abbreviations from the given file path, into the given database context
	public static func legi(el indikilo: String) -> [Mallongigo] {
		let mallongigoAnalizilo = MallongigoAnalizilo()
		let datumoj = try! Data(contentsOf: URL(fileURLWithPath: indikilo))
		let analizilo = XMLParser(data: datumoj)
		analizilo.delegate = mallongigoAnalizilo
		analizilo.parse()
		
		return mallongigoAnalizilo.mallongigoj
	}
}
