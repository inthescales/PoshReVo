import Foundation
import CoreData

/// Analizas XMLan dosieron enhavantan liston da stiloj, kaj aldonas ilin al la datumbazo
/// Parses the XML file containing the list of styles, and adds them to the database
class StiloAnalizilo2: NSObject, XMLParserDelegate {
	private let konteksto: NSManagedObjectContext
	
	private var nunaStilo: NSManagedObject?
	private var teksto: String = ""
	private var kvanto = 0
	
	init(_ konteksto: NSManagedObjectContext) {
		self.konteksto = konteksto
		print("Legas stilojn")
	}
	
	func parserDidEndDocument(_ parser: XMLParser) {
		try! konteksto.save()
		print("Legis \(kvanto) stilojn")
	}
	
	func parser(
		_ parser: XMLParser,
		didStartElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?,
		attributes attributeDict: [String : String] = [:]
	) {
		if elementName == "stilo",
			let kodo = attributeDict["kodo"] {
			nunaStilo = NSEntityDescription.insertNewObject(forEntityName: "Stilo", into: konteksto)
			nunaStilo?.setValue(kodo, forKey: "kodo")
			teksto = ""
		}
	}
	
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		teksto += string
	}
	
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if elementName == "stilo",
		   let nunaStilo = nunaStilo {
			nunaStilo.setValue(teksto, forKey: "nomo")
			kvanto += 1
		}
	}
}

// MARK: - Vokilo

extension StiloAnalizilo2 {
	/// Legas stilojn el la donata indikilo, en la donatan datumbaz-kontekston
	/// Reads styles from the given file path, into the given database context
	public static func legi(el indikilo: String, en konteksto: NSManagedObjectContext) {
				
		let stiloAnalizilo = StiloAnalizilo2(konteksto)
		let datumoj = try! Data(contentsOf: URL(fileURLWithPath: indikilo))
		let analizilo = XMLParser(data: datumoj)
		analizilo.delegate = stiloAnalizilo
		analizilo.parse()
	}
}
