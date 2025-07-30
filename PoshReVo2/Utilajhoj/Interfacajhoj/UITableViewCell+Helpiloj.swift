import UIKit

extension UITableViewCell {
	func meti(stilon stilo: InterfacStilo) {
		backgroundColor = stilo.dokumentaFono
		textLabel?.textColor = stilo.dokumentaTeksto
		detailTextLabel?.textColor = stilo.dokumentaTeksto.withAlphaComponent(0.5)
	}
}
