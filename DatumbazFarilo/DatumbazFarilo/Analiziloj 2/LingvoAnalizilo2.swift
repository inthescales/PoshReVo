import Foundation
import CoreData

/// Analizas XMLan dosieron enhavantan liston da lingvoj, kaj aldonas ilin al la datumbazo
/// Parses the XML file containing the list of languages, and adds them to the database
class LingvoAnalizilo2: NSObject, XMLParserDelegate {
	var lingvoj: [String: String] = [:]
	
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
			lingvoj[kodo] = teksto
			nunaKodo = nil
		}
	}
}

// MARK: - Vokilo

extension LingvoAnalizilo2 {
	public static func registri(lingvojn lingvoj: [String: String], en konteksto: NSManagedObjectContext) {
		for (kodo, nomo) in lingvoj {
			let novaLingvo = NSEntityDescription.insertNewObject(forEntityName: "Lingvo", into: konteksto)
			novaLingvo.setValue(kodo, forKey: "kodo")
			novaLingvo.setValue(nomo, forKey: "nomo")
		}
		
		try! konteksto.save()
	}
	/// Legas lingvojn el la donata indikilo, en la donatan datumbaz-kontekston
	/// Reads languages from the given file path, into the given database context
	public static func legi(el indikilo: String) -> [String: String] {
		let lingvoAnalizilo = LingvoAnalizilo2()
		let datumoj = try! Data(contentsOf: URL(fileURLWithPath: indikilo))
		let analizilo = XMLParser(data: datumoj)
		analizilo.delegate = lingvoAnalizilo
		analizilo.parse()
		
		return lingvoAnalizilo.lingvoj
	}
}
