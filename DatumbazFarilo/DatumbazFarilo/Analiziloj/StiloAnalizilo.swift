import Foundation

class StiloAnalizilo : NSObject, XMLParserDelegate {
	var nunaKodo: String?
	var teksto = ""
	var stiloj: [String: String] = [:]
	
	func parserDidStartDocument(_ parser: XMLParser) {
		print("Eklegas stilojn")
	}

	func parserDidEndDocument(_ parser: XMLParser) {
		print("Finlegis stilojn")
	}
	
	func parser(
		_ parser: XMLParser,
		didStartElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?,
		attributes attributeDict: [String : String] = [:]
	) {
		if elementName == "stilo" {
			nunaKodo = attributeDict["kodo"]
		}
	}
	
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		if nunaKodo != nil {
			teksto += string
		}
	}
	
	func parser(
		_ parser: XMLParser,
		didEndElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?
	) {
		if elementName == "stilo" {
			if let nunaKodo = nunaKodo {
				stiloj[nunaKodo] = teksto
			}
			
			teksto = ""
			nunaKodo = nil
		}
	}
}
