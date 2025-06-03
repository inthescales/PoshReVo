import UIKit

import SnapKit

final class HejmaViewController: UIViewController {
	// MARK: Interfaceroj
	
	lazy var tripunktoButono = {
		let butono = UIBarButtonItem.init(
			image: UIImage(named: "tripunkto"),
			style: .plain,
			target: self,
			action: #selector(Self.premisTripunkton)
		)
		butono.tintColor = DinamikaStilo.surkoloraTeksto
		return butono
	}()
	
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
		let butono = SurkoloraButton(teksto: Tekstoj.historio)
		butono.addTarget(self, action: #selector(premisHistorio), for: .touchUpInside)
		return butono
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
	
	init(
		kunordigilo: Kunordigilo = .komuna
	) {
		self.kunordigilo = kunordigilo
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) ne realas") }
	
	override func viewDidLoad() {
		view.backgroundColor = DinamikaStilo.koloraFono
		
		navigationItem.rightBarButtonItem = tripunktoButono
		
		view.addSubview(butonStaplo)
		butonStaplo.snp.makeConstraints { make in
			make.center.equalTo(view)
		}
	}
	
	// MARK: Uzantaj agoj
	
	@objc private func premisTripunkton() {
		let menuo = ShovMenuoViewController(
			eroj: [
				ShovMenuoViewController.Menuero(
					teksto: "Agordoj",
					ago: { [weak self] in self?.premisAgordoj() }
				),
				ShovMenuoViewController.Menuero(
					teksto: "Mallongigoj",
					ago: { [weak self] in self?.premisMallongigoj() }
				),
				ShovMenuoViewController.Menuero(
					teksto: "Pri PoŝReVo",
					ago: { [weak self] in self?.premisInformoj() }
				)
			],
			navigaciilaAlto: navigationController?.navigationBar.bounds.height ?? 0.0,
			forigi: { [weak self] in
				self?.dismiss(animated: false)
			}
		)
		menuo.modalPresentationStyle = .overFullScreen
		present(menuo, animated: false)
	}

	@objc private func premisSerchi() {
		guard let navigaciilo = navigationController else { return }
		kunordigilo.prezentiSerchPaghon(prezentilo: navigaciilo, radika: true)
	}
	
	@objc private func premisEsplori() {
		guard let navigaciilo = navigationController else { return }
		kunordigilo.prezentiEsplorMenuon(prezentilo: navigaciilo)
	}

	@objc private func premisHistorio() {
		guard let navigaciilo = navigationController else { return }
		kunordigilo.prezentiHistorion(prezentilo: navigaciilo)
	}
	
	@objc private func premisKonservitaj() {
		guard let navigaciilo = navigationController else { return }
		kunordigilo.prezentiKonservitajn(prezentilo: navigaciilo)
	}
	
	private func premisAgordoj() {
		guard let navigaciilo = navigationController else { return }
		kunordigilo.prezentiAgordMenuon(prezentilo: navigaciilo)
	}
	
	private func premisMallongigoj() {
		guard let navigaciilo = navigationController else { return }
		kunordigilo.prezentiMallongigoMenuon(prezentilo: navigaciilo)
	}
	
	private func premisInformoj() {
		guard let navigaciilo = navigationController else { return }
		kunordigilo.prezentiInformoPaghon(prezentilo: navigaciilo)
	}
}
