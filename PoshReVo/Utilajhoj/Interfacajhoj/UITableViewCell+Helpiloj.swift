import UIKit

extension UITableViewCell {
	/// Metas kolorojn al la ĉelo laŭ tiu stilo.
	/// - 'grupa' indikas ĉu la enhavanta tabelo havas 'grupan' stilon
	func meti(stilon stilo: InterfacStilo, grupa: Bool = false) {
		backgroundColor = grupa ? stilo.menuaTekstejo : stilo.dokumentaFono
		textLabel?.textColor = stilo.dokumentaTeksto
		detailTextLabel?.textColor = stilo.dokumentaTeksto.withAlphaComponent(0.5)
	}
}
