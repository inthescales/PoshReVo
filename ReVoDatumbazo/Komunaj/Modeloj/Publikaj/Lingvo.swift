import Foundation

/// Lingvo en kiu tradukoj ekzistas
public struct Lingvo: Codable, Hashable {
    public let kodo: String
    public let nomo: String
    
    public init(kodo: String, nomo: String) {
        self.kodo = kodo
        self.nomo = nomo
    }
	
	public static var esperanto: Lingvo {
		return Lingvo(kodo: "eo", nomo: "Esperanto")
	}
}

// MARK: - Comparable

extension Lingvo: Comparable {
    public static func < (lhs: Lingvo, rhs: Lingvo) -> Bool {
        return lhs.nomo.compare(
			rhs.nomo,
			options: .caseInsensitive,
			range: nil,
			locale: Locale(identifier: "eo")
		) == .orderedAscending
    }
}

