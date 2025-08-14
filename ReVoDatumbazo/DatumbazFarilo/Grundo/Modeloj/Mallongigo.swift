import Foundation

/// Reprezentas vortaran mallongigon, kiuj inkluzivas fontojn, verikistojn, aldonojn.
struct Mallongigo: Codable {
    let kodo: String
    let nomo: String
}

// MARK: - Comparable

extension Mallongigo: Comparable {
	public static func < (lhs: Mallongigo, rhs: Mallongigo) -> Bool {
		lhs.kodo.compare(
			rhs.kodo,
			options: .caseInsensitive,
			range: nil,
			locale: Locale(identifier: Lingvo.esperantaKodo)
		) == .orderedAscending
	}
}
