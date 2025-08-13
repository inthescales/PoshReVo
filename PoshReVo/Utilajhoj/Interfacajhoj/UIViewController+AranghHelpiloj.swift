import UIKit

extension UIViewController {
	/// La alto de la ekrana navigaciejo
	var navigaciAlto: CGFloat {
		let bazaAlto = (navigationController?.navigationBar.frame.size.height ?? 0.0)
			+ (view.window?.safeAreaInsets.top ?? 0.0)
		return bazaAlto - (bazaAlto - view.frame.minY)
	}
}
