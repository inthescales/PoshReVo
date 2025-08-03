import UIKit

extension UIColor {
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
