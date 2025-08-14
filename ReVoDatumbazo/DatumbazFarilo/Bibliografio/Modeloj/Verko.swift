import Foundation

/// Verko en la bibliografio
struct Verko {
	let mallongigo: String
	let titolo: String
	let titolAldono: String?
	let autoro: String?
	let tradukisto: String?
	let eldono: Eldono?
	let url: String?
}

// MARK: - Equatable

extension Verko: Equatable {
	public static func == (lhs: Verko, rhs: Verko) -> Bool {
		return lhs.mallongigo == rhs.mallongigo
	}
}
	
// MARK: - Comparable

extension Verko: Comparable {
	public static func < (lhs: Verko, rhs: Verko) -> Bool {
		return lhs.mallongigo.compare(
			rhs.mallongigo,
			options: .caseInsensitive,
			range: nil,
			locale: Locale(identifier: Lingvo.esperantaKodo)
		) == .orderedAscending
	}
}
