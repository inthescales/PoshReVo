import Foundation

public struct Oficialeco: Codable {
	/// Kodo kiu reprezentas ĉi-oficialeco
	public let kodo: String
	
	/// Teksta indikilo kiu montriĝos apud vortoj. Kutime samas al kodo
	public let indikilo: String?
	
	/// Plenteksta nomo de la oficialeco
	public let nomo: String
	
	/// Loko en ordigoj
	public let vico: Int
}

// MARK: - Comparable

extension Oficialeco: Comparable {
	public static func < (lhs: Oficialeco, rhs: Oficialeco) -> Bool {
		lhs.vico < rhs.vico
	}
}
