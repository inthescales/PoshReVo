import Foundation

/// Fako al kiu apartenas vortoj kaj frazetoj
public struct Fako: Codable {
    public let kodo: String
    public let nomo: String
}

// MARK: - Comparable

extension Fako: Comparable {
    public static func < (lhs: Fako, rhs: Fako) -> Bool {
        return lhs.nomo.compare(
			rhs.nomo,
			options: .caseInsensitive,
			range: nil,
			locale: Locale(identifier: Lingvo.esperantaKodo)
		) == .orderedAscending
    }
}
