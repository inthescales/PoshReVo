import Foundation

/// Parto de artikolo enhavanta tekston kaj liston da vortoj.
public struct Subartikolo: Codable {
	/// Teksto kiu aperos supre
    public let teksto: String
	
	/// Vortoj kaj derivaĵoj kiuj aperos sube, en apartaj sekcioj
    public let vortoj: [Vorto]
}
