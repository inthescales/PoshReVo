import UIKit

import SnapKit

final class HejmaViewController: UIViewController {
	var stilo: InterfacStilo
	
	lazy var serchButono: SurkoloraButton = {
		return SurkoloraButton(teksto: Tekstoj.serchi)
	}()
	
	lazy var esplorButono: SurkoloraButton = {
		return SurkoloraButton(teksto: Tekstoj.esplori)
	}()
	
	lazy var konservitajButono: SurkoloraButton = {
		return SurkoloraButton(teksto: Tekstoj.konservitaj)
	}()
	
	lazy var historioButono: SurkoloraButton = {
		return SurkoloraButton(teksto: Tekstoj.historio)
	}()
	
	lazy var butonStaplo: UIStackView = {
		let staplo = UIStackView(arrangedSubviews: [
			serchButono,
			esplorButono,
			konservitajButono,
			historioButono
		])
		staplo.axis = .vertical
		staplo.spacing = 32
		return staplo
	}()
	
	init(stilo: InterfacStilo = .nuna) {
		self.stilo = stilo
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) ne realas") }
	
	override func viewDidLoad() {
		view.backgroundColor = stilo.koloraFono
		
		view.addSubview(butonStaplo)
		butonStaplo.snp.makeConstraints { make in
			make.center.equalTo(view)
		}
	}
}
