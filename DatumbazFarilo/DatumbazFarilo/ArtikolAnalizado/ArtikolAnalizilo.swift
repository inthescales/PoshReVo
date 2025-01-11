import Foundation
import CoreData

/// Analizas XMLan dosieron kiu reprezentas artikolo
/// Parses an XML file representing an article
class ArtikolAnalizilo: NSObject, XMLParserDelegate {
	private let konteksto: NSManagedObjectContext
	private let literoj: [String: String]
	
	var arbo: [ArtikolNodo] = [ArtikolNodo(tipo: .radiko)]
	
	init(_ konteksto: NSManagedObjectContext, literoj: [String: String]) {
		self.konteksto = konteksto
		self.literoj = literoj
		
		print("Konstruas artikol-arbon")
	}
	
	func parserDidEndDocument(_ parser: XMLParser) {
		print("Konstruis artikol-arbon")
	}
	
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
	
	func parser(_ parser: XMLParser, resolveExternalEntityName name: String, systemID: String?) -> Data? {
		if let litero = literoj[name] {
			if let nunaNodo = arbo.last {
				nunaNodo.filoj.append(ArtikolNodo(tipo: .teksto(litero)))
			}
			return litero.data(using: .utf8)
		}
		
		return nil
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
	/// Legas artikolon el la donata indikilo, en la donatan datumbaz-kontekston
	/// Reads the article from the given file path, into the given database context
	public static func legi(
		el indikilo: String,
		en konteksto: NSManagedObjectContext,
		literoj: [String: String]
	) {
		let artikolAnalizilo = ArtikolAnalizilo(konteksto, literoj: literoj)
		let datumoj = try! Data(contentsOf: URL(fileURLWithPath: indikilo))
		let analizilo = XMLParser(data: datumoj)
		analizilo.externalEntityResolvingPolicy = .always
		analizilo.delegate = artikolAnalizilo
		analizilo.parse()
		
		assert(artikolAnalizilo.arbo.count == 1, "Devas resti nur unu nodo")
		
		let dosierNomo = indikilo.split(separator: "/").last!
		let indekso = String(dosierNomo[..<dosierNomo.index(dosierNomo.endIndex, offsetBy: -4)])
		let artikolo = kreiArtikolon(el: artikolAnalizilo.arbo.first!, indekso: indekso)
		print(artikolo.subartikoloj.first!.vortoj.first!.teksto)
	}
}
