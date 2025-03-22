import UIKit

import SnapKit

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
		label.snp.makeConstraints { make in
			make.center.equalTo(view)
		}
	}
}
