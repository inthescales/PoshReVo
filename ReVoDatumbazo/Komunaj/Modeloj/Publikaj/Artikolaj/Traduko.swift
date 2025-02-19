import Foundation

/// Traduko de esperanta vorto aŭ derivaĵo en alian lingvon.
public struct Traduko: Codable {
    public let lingvo: Lingvo
    public let teksto: String
}
