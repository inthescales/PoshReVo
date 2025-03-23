import UIKit

import SnapKit

final class HejmaViewController: UIViewController {
	let stilo: InterfacStilo
	
	lazy var serchilo = SerchiloView(lokokupaTeksto: "Serĉi vorton aŭ frazon")
	
	init(stilo: InterfacStilo = .nuna) {
		self.stilo = stilo
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) ne realas") }
	
	override func viewDidLoad() {
		view.backgroundColor = InterfacStilo.nuna.koloraFono
		
		view.addSubview(serchilo)
		serchilo.snp.makeConstraints { make in
			make.top.left.right.equalTo(view)
		}
	}
}
