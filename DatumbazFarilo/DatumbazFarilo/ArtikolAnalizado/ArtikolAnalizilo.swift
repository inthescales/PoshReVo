import Foundation
import CoreData

import ReVoModelojOSX

/// Analizas XMLan dosieron kiu reprezentas artikolon.
class ArtikolAnalizilo: NSObject, XMLParserDelegate {
	private let literoj: [String: String]
	
	var arbo: [ArtikolNodo] = [ArtikolNodo(tipo: .arbo)]
	var rezultoj: ArtikolAnalizRezulto?
	
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

extension ArtikolAnalizilo {	
	/// Legas artikolon je la indikilo, metante ĝin en la datumbaz-kontekston
	public static func legi(
		el indikilo: String,
		lingvoj: [String: Lingvo],
		stiloj: [String: String],
		signoj: [String: String],
		mallongigoj: [String: String],
		urloj: [String: String]
	) -> ArtikolAnalizRezulto? {
		let artikolAnalizilo = ArtikolAnalizilo(literoj: signoj)
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
		analizilo.delegate = artikolAnalizilo
		analizilo.parse()
		
		assert(artikolAnalizilo.arbo.count == 1, "Eraro: Devas resti nur unu nodo post analizo")
		
		let dosierNomo = indikilo.split(separator: "/").last!
		let indekso = String(dosierNomo[..<dosierNomo.index(dosierNomo.endIndex, offsetBy: -4)])
		return analizi(
			arbon: artikolAnalizilo.arbo.first!,
			indekso: indekso,
			lingvoj: lingvoj,
			stiloj: stiloj
		)
	}
}
