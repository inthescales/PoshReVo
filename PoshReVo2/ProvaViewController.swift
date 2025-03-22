import UIKit

final class ProvaViewController: UIViewController {
	lazy var label = {
		let nova = UILabel()
		nova.text = "Saluton, mondo"
		nova.translatesAutoresizingMaskIntoConstraints = false
		return nova
	}()
	
	override func viewDidLoad() {
		view.addSubview(label)
		view.backgroundColor = .white
		view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
		view.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0))
	}
}
