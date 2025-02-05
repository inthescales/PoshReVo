import Foundation
import CoreData

import ReVoModelojOSX
import ReVoDatumbazoOSX

/// Analizas XMLan dosieron enhavantan liston da lingvoj, kaj aldonas ilin al la datumbazo
/// Parses the XML file containing the list of languages, and adds them to the database
class LingvoAnalizilo: NSObject, XMLParserDelegate {
	var lingvoj: [Lingvo] = []
	
	private var nunaKodo: String?
	private var teksto: String = ""
	
	override init() {
		super.init()
		print("Legas lingvojn")
	}
	
	func parserDidEndDocument(_ parser: XMLParser) {
		print("Legis \(lingvoj.count) lingvojn")
	}
	
	func parser(
		_ parser: XMLParser,
		didStartElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?,
		attributes attributeDict: [String : String] = [:]
	) {
		if elementName == "lingvo", 
			let kodo = attributeDict["kodo"] {
			nunaKodo = kodo
			teksto = ""
		}
	}
	
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		teksto += string
	}
	
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if elementName == "lingvo",
		   let kodo = nunaKodo {
			lingvoj.append(Lingvo(kodo: kodo, nomo: teksto))
			nunaKodo = nil
		}
	}
}

// MARK: - Vokilo

extension LingvoAnalizilo {
	public static func registri(lingvojn lingvoj: [Lingvo], en konteksto: NSManagedObjectContext) {
		for lingvo in lingvoj {
			lingvo.skribi(en: konteksto)
		}
		
		try! konteksto.save()
	}
	
	/// Legas lingvojn el la donata indikilo, en la donatan datumbaz-kontekston
	/// Reads languages from the given file path, into the given database context
	public static func legi(el indikilo: String) -> [Lingvo] {
		let lingvoAnalizilo = LingvoAnalizilo()
		let datumoj = try! Data(contentsOf: URL(fileURLWithPath: indikilo))
		let analizilo = XMLParser(data: datumoj)
		analizilo.delegate = lingvoAnalizilo
		analizilo.parse()
		
		return lingvoAnalizilo.lingvoj
	}
}
