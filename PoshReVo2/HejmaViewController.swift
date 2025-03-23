import UIKit

import SnapKit

final class HejmaViewController: UIViewController {
	var stilo: InterfacStilo
	
	lazy var serchilo = SerchiloView(lokokupaTeksto: "Serĉi vorton aŭ frazon")
	
	lazy var esplorButono: SurkoloraButton = {
		return SurkoloraButton(teksto: "Esplori")
	}()
	
	lazy var konservitajButono: SurkoloraButton = {
		return SurkoloraButton(teksto: "Konservitaj")
	}()
	
	lazy var historioButono: SurkoloraButton = {
		return SurkoloraButton(teksto: "Historio")
	}()
	
	lazy var butonStaplo: UIStackView = {
		let staplo = UIStackView(arrangedSubviews: [
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
		
		view.addSubview(serchilo)
		serchilo.snp.makeConstraints { make in
			make.top.left.right.equalTo(view)
		}
		
		view.addSubview(butonStaplo)
		butonStaplo.snp.makeConstraints { make in
			make.center.equalTo(view)
			make.top.greaterThanOrEqualTo(serchilo)
		}
	}
}
