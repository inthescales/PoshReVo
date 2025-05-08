import UIKit

import SnapKit

final class HejmaViewController: UIViewController {
	// MARK: Interfaceroj
	
	lazy var serchButono: SurkoloraButton = {
		return SurkoloraButton(teksto: Tekstoj.serchi)
	}()
	
	lazy var esplorButono: SurkoloraButton = {
		let butono = SurkoloraButton(teksto: Tekstoj.esplori)
		butono.addTarget(self, action: #selector(premisEsplori), for: .touchUpInside)
		return butono
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
	
	// MARK: Agordoj
	
	let kunordigilo: Kunordigilo
	
	var stilo: InterfacStilo
	
	init(
		kunordigilo: Kunordigilo = .komuna,
		stilo: InterfacStilo = .nuna
	) {
		self.kunordigilo = kunordigilo
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
	
	// MARK: Uzantaj agoj
	
	@objc private func premisEsplori() {
		guard let navigaciilo = navigationController else { return }
		kunordigilo.vortListoj.prezentiHazardanArtikolon(prezentilo: navigaciilo)
	}
}
