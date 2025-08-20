import UIKit

/// Krei kaj prezenti alarmojn kaze de eraroj
enum Alarmo {
	/// Montri avert-mesaĝon
	static func montri(eraron erarTeksto: String, prezentilo: UIViewController) {
		let alarmo = UIAlertController(
			title: Tekstoj.eraro,
			message: erarTeksto,
			preferredStyle: .alert
		)
		alarmo.addAction(okejAgo())
		
		prezentilo.present(alarmo, animated: true, completion: nil)
	}
	
	// MARK: - Eroj
	
	/// Kreas kaj liveras UIAlertAction por forigi alarmmesaĝon
	private static func okejAgo() -> UIAlertAction {
		UIAlertAction(title: Tekstoj.okej, style: .default) { _ in }
	}
}
