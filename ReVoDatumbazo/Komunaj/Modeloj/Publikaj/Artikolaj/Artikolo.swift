import Foundation
import CoreData

/// Ĉiuj enhavoj de unu vortara artikolo
public final class Artikolo: Codable {
	/// Titolo de la artikolo – kutime la radiko kaj ĝia baza formo
    public let titolo: String
	
	/// La radiko reprezentata de la artikolo, sen finaĵo
    public let radiko: String
	
	/// Indekso serĉebla kiu indikas ĉi-artikolon
    public let indekso: String
	
	/// Oficialeco de la radiko. Se ekzistas pluraj variaĵoj, la plej frua oficialeco
    public let ofc: String?
	
	/// Subartikolaj dividoj de la artikolo
    public let subartikoloj: [Subartikolo]
	
	/// Ĉiuj nacilingvaj tradukoj
    public let tradukoj: [Traduko]
    
    public init(
		titolo: String,
		radiko: String,
		indekso: String,
		ofc: String?,
		subartikoloj: [Subartikolo],
		tradukoj: [Traduko]
	) {
        self.titolo = titolo
        self.radiko = radiko
        self.indekso = indekso
        self.ofc = ofc
        self.subartikoloj = subartikoloj
        self.tradukoj = tradukoj
    }
	
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(titolo, forKey: .titolo)
		try container.encode(radiko, forKey: .radiko)
		try container.encode(indekso, forKey: .indekso)
		try ofc.flatMap { try container.encode($0, forKey: .ofc) }
		
		try container.encode(subartikoloj, forKey: .subartikoloj)
		
		// Alfabetigi tradukojn tiel ke ĝi ĉiam je sama ordigo
		try container.encode(tradukoj.sorted(by: { $0.lingvo < $1.lingvo }), forKey: .tradukoj)
	}
}
