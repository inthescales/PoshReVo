import Foundation

/// Lingvo en kiu tradukoj ekzistas
public struct Lingvo: Codable {
    public let kodo: String
    public let nomo: String
    
	public static var esperanto: Lingvo {
		return Lingvo(kodo: Lingvo.esperantaKodo, nomo: "Esperanto")
	}
	
    public init(kodo: String, nomo: String) {
        self.kodo = kodo
        self.nomo = nomo
    }
	
	public var adverbo: String {
		return nomo.prefix(nomo.count - 1) + "e"
	}
	
	public var estasEsperanto: Bool {
		self.kodo == Lingvo.esperantaKodo
	}
	
	// MARK: - NSSecureCoding
	// Necesas nur dum ni legas konservitajn uzantdatumojn de V1

	public static var supportsSecureCoding = true

	public init?(coder aDecoder: NSCoder) {
		if let enkodo = aDecoder.decodeObject(forKey: "kodo") as? String,
		   let ennomo = aDecoder.decodeObject(forKey: "nomo") as? String {
			self.init(kodo: enkodo, nomo: ennomo)
		} else {
			return nil
		}
	}

	public func encode(with aCoder: NSCoder) {
		aCoder.encode(kodo, forKey: "kodo")
		aCoder.encode(nomo, forKey: "nomo")
	}
}

// MARK: - Konstantoj

extension Lingvo {
	public static let esperantaKodo = "eo"
}

// MARK: - Comparable

extension Lingvo: Comparable {
    public static func < (lhs: Lingvo, rhs: Lingvo) -> Bool {
        return lhs.nomo.compare(
			rhs.nomo,
			options: .caseInsensitive,
			range: nil,
			locale: Locale(identifier: Lingvo.esperantaKodo)
		) == .orderedAscending
    }
}
