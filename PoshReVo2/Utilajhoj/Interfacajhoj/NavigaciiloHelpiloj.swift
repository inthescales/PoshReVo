import UIKit

enum NavigaciiloHelpiloj {
	static func iksoButono(
		por vc: UIViewController,
		ago: Selector,
		stilo: InterfacStilo
	) -> UIBarButtonItem {
		let butono = UIBarButtonItem.init(
			title: "IKSO",
			style: .plain,
			target: vc,
			action: ago
		)
		butono.tintColor = stilo.navigaciaTeksto
		return butono
	}
	
	static func hejmoButono(por vc: UIViewController, ago: Selector, stilo: InterfacStilo) -> UIButton {
		let butono = UIButton(type: .system)
		butono.addTarget(vc, action: ago, for: .touchUpInside)
		butono.setImage(UIImage(named: "libro")!, for: .normal)
		butono.tintColor = stilo.navigaciaTeksto
		return butono
	}
}
