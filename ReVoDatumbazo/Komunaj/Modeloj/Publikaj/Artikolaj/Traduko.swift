import Foundation

/// Traduko de esperanta vorto aŭ derivaĵo en alian lingvon.
public struct Traduko: Codable {
	/// Lingvo de la traduko
    public let lingvo: Lingvo
	
	/// Tutan tekston de la traduko, kiu povas enhavi kelkajn vortojn kaj terminojn
    public let teksto: String
}

extension Traduko: Comparable {
	public static func < (lhs: Traduko, rhs: Traduko) -> Bool {
		lhs.lingvo < rhs.lingvo
	}
}
