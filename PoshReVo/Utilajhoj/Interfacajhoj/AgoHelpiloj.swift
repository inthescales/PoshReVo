import UIKit

enum AgoHelpiloj {
	/// Prezenti sisteman ago-konfirmilon
	static func prezentiKonfirmilon(
		teksto: String,
		prezentilo: UIViewController,
		fontoView: UIView? = nil,
		efiko: @escaping () -> Void
	) {
		let konfirmilo: UIAlertController = UIAlertController(
			title: teksto,
			message: nil,
			preferredStyle:.actionSheet
		)
		
		let agoJes = UIAlertAction(
			title: Tekstoj.jes,
			style: .destructive,
			handler: { _ in
			   efiko()
			}
		)
		
		let agoNe = UIAlertAction(title: Tekstoj.ne, style: .cancel, handler: nil)

		for ago in [agoJes, agoNe] {
			konfirmilo.addAction(ago)
		}
		
		prezentilo.present(konfirmilo, animated: true, completion: nil)
	}
}
