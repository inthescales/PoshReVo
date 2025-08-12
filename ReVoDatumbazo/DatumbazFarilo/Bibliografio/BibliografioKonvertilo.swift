import Foundation
import CoreData

/// Konvertas bibliografiajn-datumojn el XML en BibliografioNodan arbon.
class BibliografioKonvertilo: NSObject, XMLParserDelegate {
	/// Signoj laŭ kodoj kiujn ili devos anstataŭi
	private let signoj: [String: String]
	
	/// La arbo konstruata
	var arbo: [BibliografioNodo] = [BibliografioNodo(tipo: .arbo)]
	
	init(literoj: [String: String]) {
		self.signoj = literoj
	}
	
	// MARK: - XMLParserDelegate
	
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
		let novaNodo = BibliografioNodo(nomo: elementName, ecoj: attributeDict)!
		
		if arbo.last != nil {
			arbo.last?.filoj.append(novaNodo)
		}
		
		arbo.append(novaNodo)
	}
	
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		if let nunaNodo = arbo.last {
			nunaNodo.filoj.append(BibliografioNodo(tipo: .teksto(string)))
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

extension BibliografioKonvertilo {
	/// Konvertas XML-ajn bibliografiodatumojn en bibliografion-arbon, liverante la radikan nodon de la arbo
	public static func konverti(
		el indikilo: String,
		signoj: [String: String]
	) -> BibliografioNodo? {
		let bibliografioKonvertilo = BibliografioKonvertilo(literoj: signoj)
		var teksto = try! String(contentsOfFile: indikilo, encoding: .utf8)
		
		teksto = BibliografioAntautraktado.antautrakti(
			tekston: teksto,
			signoj: signoj
		)
		
		let datumoj = teksto.data(using: .utf8)!
		let analizilo = XMLParser(data: datumoj)
		analizilo.externalEntityResolvingPolicy = .never
		analizilo.delegate = bibliografioKonvertilo
		analizilo.parse()
		
		assert(bibliografioKonvertilo.arbo.count == 1, "Eraro: Devas resti nur unu nodo post analizo")
		
		return bibliografioKonvertilo.arbo.first
	}
}
