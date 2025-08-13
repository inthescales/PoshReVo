import ReVoDatumbazo

import Foundation

// TODO: Kiam ni ne plu subtenas V1ajn uzantodatumojn, forigu ĉi-dosieron

/// Lingvo kiel ĝi ekzistis en V1. Por migrado de V1ajn datumojn
public class V1Lingvo: NSObject, Codable, NSSecureCoding {
	public let kodo: String
	public let nomo: String
	
	public init(kodo: String, nomo: String) {
		self.kodo = kodo
		self.nomo = nomo
	}
	
	// MARK: - NSSecureCoding

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

extension V1Lingvo: Comparable {
	public static func < (lhs: V1Lingvo, rhs: V1Lingvo) -> Bool {
		return lhs.nomo.compare(
			rhs.nomo,
			options: .caseInsensitive,
			range: nil,
			locale: Locale(identifier: Lingvo.esperantaKodo)
		) == .orderedAscending
	}
}

// MARK: - Migrado el V1ajn datumojn al V2
// TODO: Forigi kiam ni ne plu subtenos V1

extension Lingvo {
	init(el v1: V1Lingvo) {
		self.init(kodo: v1.kodo, nomo: v1.nomo)
	}
}
