import UIKit

enum NavigaciiloHelpiloj {
	static func iksoButono(ago: Selector, stilo: InterfacStilo) -> UIBarButtonItem {
		let butono = UIBarButtonItem.init(
			title: "IKSO",
			style: .plain,
			target: self,
			action: ago
		)
		butono.tintColor = stilo.surkoloraTeksto
		return butono
	}
}
