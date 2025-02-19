import Foundation
import CoreData

import ReVoModelojOSX

/// Analizas XMLan dosieron enhavantan liston da stiloj, kaj aldonas ilin al la datumbazo
/// Parses the XML file containing the list of styles, and adds them to the database
class StiloAnalizilo: NSObject, XMLParserDelegate {
	var stiloj: [Stilo] = []
	
	private var nunaStilo: String?
	private var teksto: String = ""
	
	override init() {
		super.init()
		print("Legas stilojn")
	}
	
	func parserDidEndDocument(_ parser: XMLParser) {
		print("Legis \(stiloj.count) stilojn")
	}
	
	func parser(
		_ parser: XMLParser,
		didStartElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?,
		attributes attributeDict: [String : String] = [:]
	) {
		if elementName == "stilo",
			let mll = attributeDict["kodo"] {
			nunaStilo = mll
			teksto = ""
		}
	}
	
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		teksto += string
	}
	
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if elementName == "stilo",
		   let nunaStilo = nunaStilo {
			stiloj.append(Stilo(kodo: nunaStilo, nomo: teksto))
		}
	}
}

// MARK: - Vokilo

extension StiloAnalizilo {
	/// Legas Stilojn el la donata indikilo, en la donatan datumbaz-kontekston
	/// Reads abbreviations from the given file path, into the given database context
	public static func legi(el indikilo: String) -> [Stilo] {
		let StiloAnalizilo = StiloAnalizilo()
		let datumoj = try! Data(contentsOf: URL(fileURLWithPath: indikilo))
		let analizilo = XMLParser(data: datumoj)
		analizilo.delegate = StiloAnalizilo
		analizilo.parse()
		
		return StiloAnalizilo.stiloj
	}
}
