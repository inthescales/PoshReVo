import UIKit

extension UIColor {
	/// Dinamika koloro kun hela kaj malhela variaĵoj
	convenience init(hela: UIColor, malhela: UIColor) {
		self.init(dynamicProvider: { trajtaro in
			switch Heleco.el(trajtaro: trajtaro) {
			case .hela:
				return hela
			case .malhela:
				return malhela
			}
		})
	}
	
	/// Valorizas koloron per deksesuma (aŭ iu ajn, fakte) entjero
	convenience init(deksesuma valoro: Int, alpha: CGFloat = 1.0) {
		self.init(
			red:   CGFloat((valoro >> 16) & 0xFF) / 255,
			green: CGFloat((valoro >> 8)  & 0xFF) / 255,
			blue:  CGFloat(valoro         & 0xFF) / 255,
			alpha: alpha
		)
	}
}
