import UIKit

/// Enhavas ĉiujn tiparojn de la apo, inkluzive iliajn grandojn kaj stilojn
enum Tiparo {
	/// Stilo de tipara teksto
	private enum Stilo {
		case baza
		case kursiva
		case grasa
		case graskursiva
	}
		
	// MARK: Serĉado
	
	static let lingvoBreto = tiparo(18.0, dinamika: false)
	
	// MARK: Vortlistoj
	
	static let nulstato = tiparo(20.0, stilo: .kursiva)
	
	// MARK: Menuoj
	
	static let shovMenuoTitolo = tiparo(18.0, stilo: .grasa)
	static let shovMenuero = tiparo(18.0)
	
	// MARK: Artikoloj
	
	static let subartikolaTitolo = tiparo(32.0, stilo: .grasa)
	static let derivajhaTitolo = tiparo(30, stilo: .grasa)
	static let artikolaTeksto = tiparo(17.0)
	
	static let tradukaroEtikedoForta = tiparo(18.0, stilo: .graskursiva)
	static let tradukaroEtikedoMalforta = tiparo(18.0, stilo: .kursiva)
	static let tradukaElektiButono = tiparo(18.0, dinamika: false)
	static let tradukaLingvo = artikolaTeksto
	static let tradukaSignifo = artikolaTeksto
	
	// MARK: Mallongigolistoj
	
	static let mallongigo = tiparo(20.0)
	static let mallongigoDifino = tiparo(18.0)
	
	// MARK: Informopaĝo
	
	static let informoTitolo = derivajhaTitolo
	static let informoTeksto = tiparo(18.0)
	
	/// Kreas novan tiparon el la baza tiparo, havantan certan grandon kaj stilon.
	///
	/// Se 'dinamika' estas 'true', la tiparo kreskas kaj malkreskas laŭ aparat-agordoj.
	/// Notu ke nedinamika tiparo necesas por meti dinamikan tekston en butonon
	private static func tiparo(
		_ grando: CGFloat,
		stilo: Stilo = .baza,
		dinamika: Bool = true
	) -> UIFont {
		let tiparo: UIFont
		switch stilo {
		case .baza:
			tiparo = .systemFont(ofSize: grando)
		case .grasa:
			tiparo = .boldSystemFont(ofSize: grando)
		case .kursiva:
			tiparo = .italicSystemFont(ofSize: grando)
		case .graskursiva:
			let priskribilo = UIFont.systemFont(ofSize: grando)
				.fontDescriptor
				.withSymbolicTraits([.traitItalic, .traitBold])
			tiparo = UIFont(descriptor: priskribilo!, size: grando)
		}
		
		if dinamika {
			return tiparo.dinamika()
		} else {
			return tiparo
		}
	}
}

extension UIFont {
	/// Dinamika tiparo ŝanĝiĝas je grando laŭ aparataj agordoj
	func dinamika() -> UIFont {
		UIFontMetrics.default.scaledFont(for: self)
	}
}

extension UIButton {
	/// Metas titolon al la butono en certa tiparo.
	/// Ĉi-kodo necesas por havi dinamikan tiparon en UIButton{
	func metiDinamikanTitolon(_ teksto: String, tiparo: UIFont) {
		let atributoj = [
			NSAttributedString.Key.font: UIFontMetrics.default.scaledFont(for: tiparo)
		]
		let atributaTeksto = NSAttributedString(string: teksto, attributes: atributoj)
		setAttributedTitle(atributaTeksto, for: .normal)
	}
}
