import Foundation

// TODO: Faru strukt-on anstatau class-on post kiam ni ne plu subtenos konservitajn uzantdatumojn el V1

/// Lingvo en kiu tradukoj ekzistas
public class Lingvo: NSObject, Codable, NSSecureCoding {
    public let kodo: String
    public let nomo: String
    
	public static var esperanto: Lingvo {
		return Lingvo(kodo: "eo", nomo: "Esperanto")
	}
	
    public init(kodo: String, nomo: String) {
        self.kodo = kodo
        self.nomo = nomo
    }
	
	public var adverbo: String {
		return nomo.prefix(nomo.count - 1) + "e"
	}
	
	public var estasEsperanto: Bool {
		self.kodo == "eo"
	}
	
	// MARK: - NSSecureCoding
	// Necesas nur dum ni legas konservitajn uzantdatumojn de V1

	public static var supportsSecureCoding = true

	public required convenience init?(coder aDecoder: NSCoder) {
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
