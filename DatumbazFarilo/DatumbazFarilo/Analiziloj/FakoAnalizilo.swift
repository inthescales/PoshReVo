import Foundation

class FakoAnalizilo : NSObject, XMLParserDelegate {
	var nunaKodo: String?
	var teksto = ""
	var fakoj: [String: String] = [:]
	
	func parserDidStartDocument(_ parser: XMLParser) {
		print("Eklegas fakojn")
	}

	func parserDidEndDocument(_ parser: XMLParser) {
		print("Finlegis fakojn")
	}
	
	func parser(
		_ parser: XMLParser,
		didStartElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?,
		attributes attributeDict: [String : String] = [:]
	) {
		if elementName == "fako" {
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
		if elementName == "fako" {
			if let nunaKodo = nunaKodo {
				fakoj[nunaKodo] = teksto
			}
			
			teksto = ""
			nunaKodo = nil
		}
	}
}
