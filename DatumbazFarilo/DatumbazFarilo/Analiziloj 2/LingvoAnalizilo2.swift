import Foundation
import CoreData

/// Analizas XMLan dosieron enhavantan liston da lingvoj, kaj aldonas ilin al la datumbazo
/// Parses the XML file containing the list of languages, and adds them to the database
class LingvoAnalizilo2: NSObject, XMLParserDelegate {
	
	private let konteksto: NSManagedObjectContext
	
	private var nunaLingvo: NSManagedObject?
	private var teksto: String = ""
	private var kvanto = 0
	
	init(_ konteksto: NSManagedObjectContext) {
		self.konteksto = konteksto
		print("Legas lingvojn")
	}
	
	func parserDidEndDocument(_ parser: XMLParser) {
		try! konteksto.save()
		print("Legis \(kvanto) lingvojn")
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
			nunaLingvo = NSEntityDescription.insertNewObject(forEntityName: "Lingvo", into: konteksto)
			nunaLingvo?.setValue(kodo, forKey: "kodo")
			teksto = ""
		}
	}
	
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		teksto += string
	}
	
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if elementName == "lingvo",
		   let nunaLingvo = nunaLingvo {
			nunaLingvo.setValue(teksto, forKey: "nomo")
			kvanto += 1
		}
	}
}

// MARK: - Vokilo

extension LingvoAnalizilo2 {
	/// Legas lingvojn el la donata indikilo, en la donatan datumbaz-kontekston
	/// Reads languages from the given file path, into the given database context
	public static func legi(el indikilo: String, en konteksto: NSManagedObjectContext) {
				
		let lingvoAnalizilo = LingvoAnalizilo2(konteksto)
		let datumoj = try! Data(contentsOf: URL(fileURLWithPath: indikilo))
		let analizilo = XMLParser(data: datumoj)
		analizilo.delegate = lingvoAnalizilo
		analizilo.parse()
	}
}
