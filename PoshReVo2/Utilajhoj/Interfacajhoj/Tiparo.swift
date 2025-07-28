import UIKit

enum Tiparo {}

extension UIFont {
	func dinamika() -> UIFont {
		UIFontMetrics.default.scaledFont(for: self)
	}
}

extension UIButton {
	func metiDinamikanTitolon(_ teksto: String, tiparo: UIFont) {
		let atributoj = [
			NSAttributedString.Key.font: UIFontMetrics.default.scaledFont(for: tiparo)
		]
		let atributaTeksto = NSAttributedString(string: teksto, attributes: atributoj)
		setAttributedTitle(atributaTeksto, for: .normal)
	}
}
