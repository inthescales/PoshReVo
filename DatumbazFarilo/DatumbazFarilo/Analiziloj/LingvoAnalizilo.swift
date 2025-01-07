import Foundation

class LingvoAnalizilo : NSObject, XMLParserDelegate {
	var nunaKodo: String?
	var teksto = ""
	var lingvoj: [String: String] = [:]
	
	func parserDidStartDocument(_ parser: XMLParser) {
		print("Eklegas lingvojn")
	}

	func parserDidEndDocument(_ parser: XMLParser) {
		print("Finlegis lingvojn")
	}
	
	func parser(
		_ parser: XMLParser,
		didStartElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?,
		attributes attributeDict: [String : String] = [:]
	) {
		if elementName == "lingvo" {
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
		if elementName == "lingvo" {
			if let nunaKodo = nunaKodo {
				lingvoj[nunaKodo] = teksto
			}
			
			teksto = ""
			nunaKodo = nil
		}
	}
}
