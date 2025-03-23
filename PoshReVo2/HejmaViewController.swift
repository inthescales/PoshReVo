import UIKit

import SnapKit

final class HejmaViewController: UIViewController {
	let stilo: InterfacStilo
	
	lazy var label = {
		let nova = UILabel()
		nova.text = "Saluton, mondo"
		nova.translatesAutoresizingMaskIntoConstraints = false
		nova.textColor = InterfacStilo.nuna.teksto
		
		return nova
	}()
	
	init(stilo: InterfacStilo = .nuna) {
		self.stilo = stilo
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) { fatalError() }
	
	override func viewDidLoad() {
		view.addSubview(label)
		view.backgroundColor = InterfacStilo.nuna.koloraFono
		
		label.snp.makeConstraints { make in
			make.center.equalTo(view)
		}
	}
}
