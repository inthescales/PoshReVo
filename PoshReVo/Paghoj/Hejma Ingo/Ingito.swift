import UIKit

/// Paĝo kiu povas aperi en la hejma paĝingo
protocol Ingito: UIViewController {
	/// Titolo montrota paĝsupre
	var titolo: String { get }
	
	/// Restarigi la staton de la paĝo
	func restarigi()
}
