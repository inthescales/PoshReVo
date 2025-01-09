import Foundation
import CoreData

/// Analizas XMLan dosieron enhavantan liston da mallongigoj, kaj aldonas ilin al la datumbazo
/// Parses the XML file containing the list of abbreviations, and adds them to the database
class MallongigoAnalizilo2: NSObject, XMLParserDelegate {
	private let konteksto: NSManagedObjectContext
	
	private var nunaMallongigo: NSManagedObject?
	private var teksto: String = ""
	private var kvanto = 0
	
	init(_ konteksto: NSManagedObjectContext) {
		self.konteksto = konteksto
		print("Legas mallingigojn")
	}
	
	func parserDidEndDocument(_ parser: XMLParser) {
		try! konteksto.save()
		print("Legis \(kvanto) mallongigojn")
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
			nunaMallongigo = NSEntityDescription.insertNewObject(forEntityName: "Mallongigo", into: konteksto)
			nunaMallongigo?.setValue(mll, forKey: "kodo")
			teksto = ""
		}
	}
	
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		teksto += string
	}
	
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if elementName == "mallongigo",
		   let nunaMallongigo = nunaMallongigo {
			nunaMallongigo.setValue(teksto, forKey: "nomo")
			kvanto += 1
		}
	}
}

// MARK: - Vokilo

extension MallongigoAnalizilo2 {
	/// Legas mallongigojn el la donata indikilo, en la donatan datumbaz-kontekston
	/// Reads abbreviations from the given file path, into the given database context
	public static func legi(el indikilo: String, en konteksto: NSManagedObjectContext) {
				
		let mallongigoAnalizilo = MallongigoAnalizilo2(konteksto)
		let datumoj = try! Data(contentsOf: URL(fileURLWithPath: indikilo))
		let analizilo = XMLParser(data: datumoj)
		analizilo.delegate = mallongigoAnalizilo
		analizilo.parse()
	}
}
