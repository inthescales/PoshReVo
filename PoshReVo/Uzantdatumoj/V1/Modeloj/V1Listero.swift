import Foundation

// TODO: Kiam ni ne plu subtenas V1ajn uzantodatumojn, forigu ĉi-dosieron

/// Klaso uzata en PoŝReVo V1 por reprezenti eron in listo da vortoj. Retenata por legi uzant-datumojn skribitajn en V1.
final class V1Listero : NSObject, NSSecureCoding {
	let nomo: String, indekso: String
	
	init(_ ennomo: String, _ enindekso: String) {
		nomo = ennomo
		indekso = enindekso
	}
	
	// MARK: - NSSecureCoding
	
	static var supportsSecureCoding = true
	
	required convenience init?(coder aDecoder: NSCoder) {
		if let ennomo = aDecoder.decodeObject(forKey: "nomo") as? String,
			let enindekso = aDecoder.decodeObject(forKey: "indekso") as? String {
			self.init(ennomo, enindekso)
		} else {
			return nil
		}
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(nomo, forKey: "nomo")
		aCoder.encode(indekso, forKey: "indekso")
	}
}

// MARK: - Konservitajho

extension Konservitajho {
	init(nomo: String, indekso: String) {
		self.nomo = nomo
		self.indekso = indekso
		self.marko = nil
	}
	
	static func el(v1Listero listero: V1Listero) -> Konservitajho {
		Konservitajho(nomo: listero.nomo, indekso: listero.indekso)
	}
}
