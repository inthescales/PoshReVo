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

// MARK: - Konstantoj

extension Oficialeco {
	static let neoficialaKodo = "n"
}

// MARK: - Hashable

extension Oficialeco: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(kodo)
	}
}

// MARK: - Comparable

extension Oficialeco: Comparable {
	public static func < (lhs: Oficialeco, rhs: Oficialeco) -> Bool {
		lhs.vico < rhs.vico
	}
}
