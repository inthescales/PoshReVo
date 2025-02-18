import Foundation
import CoreData

import ReVoModelojOSX
import ReVoDatumbazoOSX

/// Analizas XMLan dosieron enhavantan liston da fakoj, kaj aldonas ilin al la datumbazo
/// Parses the XML file containing the list of languages, and adds them to the database
class FakoAnalizilo: NSObject, XMLParserDelegate {
	var fakoj: [Fako] = []
	
	private var nunaKodo: String?
	private var teksto: String = ""
	
	override init() {
		super.init()
		print("Legas fakojn")
	}
	
	func parserDidEndDocument(_ parser: XMLParser) {
		print("Legis \(fakoj.count) fakojn")
	}
	
	func parser(
		_ parser: XMLParser,
		didStartElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?,
		attributes attributeDict: [String : String] = [:]
	) {
		if elementName == "fako",
			let kodo = attributeDict["kodo"] {
			nunaKodo = kodo
			teksto = ""
		}
	}
	
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		teksto += string
	}
	
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if elementName == "fako",
		   let kodo = nunaKodo {
			fakoj.append(Fako(kodo: kodo, nomo: teksto))
			nunaKodo = nil
		}
	}
}

// MARK: - Vokilo

extension FakoAnalizilo {
	public static func skribi(fakojn fakoj: [Fako], en konteksto: NSManagedObjectContext) {
		for fako in fakoj {
			fako.skribi(en: konteksto)
		}
		
		try! konteksto.save()
	}
	
	/// Legas fakojn el la donata indikilo, en la donatan datumbaz-kontekston
	/// Reads languages from the given file path, into the given database context
	public static func legi(el indikilo: String) -> [Fako] {
		let fakoAnalizilo = FakoAnalizilo()
		let datumoj = try! Data(contentsOf: URL(fileURLWithPath: indikilo))
		let analizilo = XMLParser(data: datumoj)
		analizilo.delegate = fakoAnalizilo
		analizilo.parse()
		
		return fakoAnalizilo.fakoj
	}
}
