import UIKit

enum Tiparo {}

extension UIButton {
	func metiDinamikanTitolon(_ teksto: String, tiparo: UIFont) {
		let atributoj = [
			NSAttributedString.Key.font: UIFontMetrics.default.scaledFont(for: tiparo)
		]
		let atributaTeksto = NSAttributedString(string: teksto, attributes: atributoj)
		setAttributedTitle(atributaTeksto, for: .normal)
	}
}
