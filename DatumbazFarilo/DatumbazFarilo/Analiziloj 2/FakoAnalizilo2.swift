import Foundation
import CoreData

/// Analizas XMLan dosieron enhavantan liston da fakoj, kaj aldonas ilin al la datumbazo
/// Parses the XML file containing the list of fields, and adds them to the database
class FakoAnalizilo2: NSObject, XMLParserDelegate {
	private let konteksto: NSManagedObjectContext
	
	private var nunaFako: NSManagedObject?
	private var teksto: String = ""
	private var kvanto = 0
	
	init(_ konteksto: NSManagedObjectContext) {
		self.konteksto = konteksto
		print("Legas fakojn")
	}
	
	func parserDidEndDocument(_ parser: XMLParser) {
		try! konteksto.save()
		print("Legis \(kvanto) fakojn")
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
			nunaFako = NSEntityDescription.insertNewObject(forEntityName: "Fako", into: konteksto)
			nunaFako?.setValue(korektitaKodo(por: kodo), forKey: "kodo")
			teksto = ""
		}
	}
	
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		teksto += string
	}
	
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if elementName == "fako",
		   let nunaFako = nunaFako {
			nunaFako.setValue(teksto, forKey: "nomo")
			kvanto += 1
		}
	}

	// MARK - Helpiloj
	
	/// Ricevas fak-kodon, kaj liveras korektitan kodon (aŭ tiun saman kodon, se korekto ne necesas)
	private func korektitaKodo(por kodo: String) -> String {
		switch kodo {
		case "POSX":
			return "POŜ"
		case "SHI":
			return "ŜIP"
		case "MAS":
			return "MAŜ"
		case "AUT":
			return "AŬT"
		default:
			return kodo
		}
	}
}

// MARK: - Vokilo

extension FakoAnalizilo2 {
	/// Legas fakojn el la donata indikilo, en la donatan datumbaz-kontekston
	/// Reads fields from the given file path, into the given database context
	public static func legi(el indikilo: String, en konteksto: NSManagedObjectContext) {
				
		let fakoAnalizilo = FakoAnalizilo2(konteksto)
		let datumoj = try! Data(contentsOf: URL(fileURLWithPath: indikilo))
		let analizilo = XMLParser(data: datumoj)
		analizilo.delegate = fakoAnalizilo
		analizilo.parse()
	}
}
