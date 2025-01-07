import Foundation

class MallongigoAnalizilo : NSObject, XMLParserDelegate {
	var nunaMll: String?
	var teksto = ""
	var mallongigoj: [String: String] = [:]
	
	func parserDidStartDocument(_ parser: XMLParser) {
		print("Eklegas mallongigojn")
	}

	func parserDidEndDocument(_ parser: XMLParser) {
		print("Finlegis mallongigojn")
	}
	
	func parser(
		_ parser: XMLParser,
		didStartElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?,
		attributes attributeDict: [String : String] = [:]
	) {
		if elementName == "mallongigo" {
			nunaMll = attributeDict["mll"]
		}
	}
	
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		if nunaMll != nil {
			teksto += string
		}
	}
	
	func parser(
		_ parser: XMLParser,
		didEndElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?
	) {
		if elementName == "mallongigo" {
			if let nunaMll = nunaMll {
				mallongigoj[nunaMll] = teksto
			}
			
			teksto = ""
			nunaMll = nil
		}
	}
}
