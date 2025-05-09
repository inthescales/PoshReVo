import UIKit

import SnapKit

final class HejmaViewController: UIViewController {
	// MARK: Interfaceroj
	
	lazy var serchButono: SurkoloraButton = {
		let butono = SurkoloraButton(teksto: Tekstoj.serchi)
		butono.addTarget(self, action: #selector(premisSerchi), for: .touchUpInside)
		return butono
	}()
	
	lazy var esplorButono: SurkoloraButton = {
		let butono = SurkoloraButton(teksto: Tekstoj.esplori)
		butono.addTarget(self, action: #selector(premisEsplori), for: .touchUpInside)
		return butono
	}()
	
	lazy var konservitajButono: SurkoloraButton = {
		let butono = SurkoloraButton(teksto: Tekstoj.konservitaj)
		butono.addTarget(self, action: #selector(premisKonservitaj), for: .touchUpInside)
		return butono
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
	
	@objc private func premisSerchi() {
		guard let navigaciilo = navigationController else { return }
		kunordigilo.prezentiSerchPaghon(prezentilo: navigaciilo, radika: true)
	}
	
	@objc private func premisEsplori() {
		guard let navigaciilo = navigationController else { return }
		kunordigilo.prezentiEsplorMenuon(prezentilo: navigaciilo)
	}
	
	@objc private func premisKonservitaj() {
		guard let navigaciilo = navigationController else { return }
		kunordigilo.prezentiKonservitajn(prezentilo: navigaciilo)
	}
}
