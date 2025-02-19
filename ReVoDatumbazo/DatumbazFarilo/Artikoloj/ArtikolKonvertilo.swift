import Foundation
import CoreData

/// Konvertas artikolajn-datumojn el XML en ArikolNodan arbon.
class ArtikolKonvertilo: NSObject, XMLParserDelegate {
	private let literoj: [String: String]
	
	var arbo: [ArtikolNodo] = [ArtikolNodo(tipo: .arbo)]
	
	init(literoj: [String: String]) {
		self.literoj = literoj
	}
	
	func parser(_ parser: XMLParser, parseErrorOccurred parseError: any Error) {
		assert(false, "Analizeraro: \(parseError)")
	}
	
	func parserDidEndDocument(_ parser: XMLParser) {}
	
	func parser(
		_ parser: XMLParser,
		didStartElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?,
		attributes attributeDict: [String : String] = [:]
	) {
		let novaNodo = ArtikolNodo(nomo: elementName, ecoj: attributeDict)!
		
		if arbo.last != nil {
			arbo.last?.filoj.append(novaNodo)
		}
		
		arbo.append(novaNodo)
	}
	
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		if let nunaNodo = arbo.last {
			nunaNodo.filoj.append(ArtikolNodo(tipo: .teksto(string)))
		}
	}
	
	func parser(
		_ parser: XMLParser,
		didEndElement elementName: String,
		namespaceURI: String?,
		qualifiedName qName: String?
	) {
		_ = arbo.popLast()
	}
}

// MARK: - Vokilo

extension ArtikolKonvertilo {	
	/// Konvertas XML-ajn artikoldatumojn en artikol-arbon, liverante la radika nodo de la arbo
	public static func konverti(
		el indikilo: String,
		signoj: [String: String],
		mallongigoj: [String: String],
		urloj: [String: String]
	) -> ArtikolNodo? {
		let artikolKonvertilo = ArtikolKonvertilo(literoj: signoj)
		var teksto = try! String(contentsOfFile: indikilo, encoding: .utf8)
		
		teksto = Antautraktado.antautrakti(
			tekston: teksto,
			literoj: signoj,
			mallongigoj: mallongigoj,
			urloj: urloj
		)
		
		let datumoj = teksto.data(using: .utf8)!
		let analizilo = XMLParser(data: datumoj)
		analizilo.externalEntityResolvingPolicy = .never
		analizilo.delegate = artikolKonvertilo
		analizilo.parse()
		
		assert(artikolKonvertilo.arbo.count == 1, "Eraro: Devas resti nur unu nodo post analizo")
		
		return artikolKonvertilo.arbo.first
	}
}
