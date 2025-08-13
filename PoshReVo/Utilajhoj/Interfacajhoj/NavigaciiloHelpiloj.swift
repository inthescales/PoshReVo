import UIKit

/// Butonofariloj kaj aliaj helpiloj por provizi navigaciejojn.
enum NavigaciiloHelpiloj {
	/// Fari kaj liveri X butono
	static func iksoButono(
		por vc: UIViewController,
		ago: Selector,
		stilo: InterfacStilo
	) -> UIBarButtonItem {
		let butono = UIBarButtonItem(
			image: UIImage(named: "ikso"),
			landscapeImagePhone: nil,
			style: .plain,
			target: vc,
			action: ago
		)
		butono.tintColor = stilo.navigaciaButono
		return butono
	}
	
	/// Fari kaj liveri 'Rezigni' butonon
	static func rezigniButono(
		por vc: UIViewController,
		ago: Selector,
		stilo: InterfacStilo
	) -> UIBarButtonItem {
		let butono = UIBarButtonItem.init(
			title: Tekstoj.rezigni,
			style: .plain,
			target: vc,
			action: ago
		)
		butono.tintColor = stilo.navigaciaButono
		return butono
	}
}
