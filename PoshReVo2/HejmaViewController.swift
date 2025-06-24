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
		butono.tintColor = DinamikaStilo.navigaciaTeksto
		return butono
	}()
	
	lazy var serchButono: HejmaNavigaciButton = {
		let butono = HejmaNavigaciButton(teksto: Tekstoj.serchi)
		butono.addTarget(self, action: #selector(premisSerchi), for: .touchUpInside)
		return butono
	}()
	
	lazy var esplorButono: HejmaNavigaciButton = {
		let butono = HejmaNavigaciButton(teksto: Tekstoj.esplori)
		butono.addTarget(self, action: #selector(premisEsplori), for: .touchUpInside)
		return butono
	}()
	
	lazy var konservitajButono: HejmaNavigaciButton = {
		let butono = HejmaNavigaciButton(teksto: Tekstoj.konservitaj)
		butono.addTarget(self, action: #selector(premisKonservitaj), for: .touchUpInside)
		return butono
	}()
	
	lazy var historioButono: HejmaNavigaciButton = {
		let butono = HejmaNavigaciButton(teksto: Tekstoj.historio)
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
		view.backgroundColor = DinamikaStilo.navigaciaFono
		
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
					teksto: Tekstoj.agordoj,
					ago: { [weak self] in self?.premisAgordoj() }
				),
				ShovMenuoViewController.Menuero(
					teksto: Tekstoj.mallongigoj,
					ago: { [weak self] in self?.premisMallongigoj() }
				),
				ShovMenuoViewController.Menuero(
					teksto: Tekstoj.priPoshReVo,
					ago: { [weak self] in self?.premisInformoj() }
				)
			],
			agordoj: ShovMenuoViewController.Agordoj(
				titolo: nil,
				navigaciaKoloro: DinamikaStilo.navigaciaFono,
				navigaciaTekstKoloro: DinamikaStilo.navigaciaTeksto,
				navigaciaDividiloKoloro: DinamikaStilo.navigaciaTeksto.withAlphaComponent(0.3),
				menuaKoloro: DinamikaStilo.navigaciaFono,
				malplenaKoloro: DinamikaStilo.navigaciaFono,
				tekstKoloro: DinamikaStilo.navigaciaTeksto,
				dividiloKoloro: DinamikaStilo.navigaciaTeksto.withAlphaComponent(0.3)
			),
			navigaciilaAlto: navigaciAlto,
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
