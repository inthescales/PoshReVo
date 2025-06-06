import Foundation

/// Klaso uzata en PoŝReVo V1 por reprezenti eron in listo da vortoj. Retenata por legi uzant-datumojn skribitajn en V1.
/// Kiam ni ne plu subtenas V1ajn uzantodatumojn, forigu ĉi-klason.
final class Listero : NSObject, NSSecureCoding {
	let nomo: String, indekso: String
	
	init(_ ennomo: String, _ enindekso: String) {
		nomo = ennomo
		indekso = enindekso
	}
	
	// MARK: - NSSecureCoding
	
	static var supportsSecureCoding = true
	
	required convenience init?(coder aDecoder: NSCoder) {
		if let ennomo = aDecoder.decodeObject(forKey: "teksto") as? String,
			let enindekso = aDecoder.decodeObject(forKey: "indekso") as? String {
			self.init(ennomo, enindekso)
		} else {
			return nil
		}
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(nomo, forKey: "teksto")
		aCoder.encode(indekso, forKey: "indekso")
	}
}

// MARK: - Konservitajho

extension Konservitajho {
	init(nomo: String, indekso: String) {
		self.nomo = nomo
		self.indekso = indekso
	}
	
	static func el(v1Listero listero: Listero) -> Konservitajho {
		Konservitajho(nomo: listero.nomo, indekso: listero.indekso)
	}
}
