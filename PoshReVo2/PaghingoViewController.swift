import UIKit

final class PaghingoViewController: UIViewController {
	// MARK: Interfaceroj
	
	lazy var tripunktoButono = {
		let butono = UIBarButtonItem.init(
			image: UIImage(named: "tripunkto"),
			style: .plain,
			target: self,
			action: #selector(Self.premisTripunkton)
		)
		butono.tintColor = DinamikaStilo.navigaciaTeksto
		butono.accessibilityLabel = AlirebloTekstoj.malfermiMenuon
		
		return butono
	}()
	
	// MARK: - Agordoj
	
	let chefpagho: UIViewController
	
	let kunordigilo: Kunordigilo
	
	init(chefpagho: UIViewController, kunordigilo: Kunordigilo = .komuna) {
		self.chefpagho = chefpagho
		self.kunordigilo = kunordigilo
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = Tekstoj.poshaRetaVortaro
		navigationItem.rightBarButtonItem = tripunktoButono
		
		addChild(chefpagho)
		view.addEdgeMatchedSubview(chefpagho.view)
	}
	
	// MARK: Paĝ-navigaciado
	
	@objc private func premisTripunkton() {
		let menuo = ShovMenuoViewController(
			eroj: [
				ShovMenuoViewController.Menuero(
					bildo: UIImage(named: "libro"),
					teksto: Tekstoj.historio,
					ago: { [weak self] in self?.premisHistorio() }
				),
				ShovMenuoViewController.Menuero(
					bildo: UIImage(named: "plenaStelo"),
					teksto: Tekstoj.konservitaj,
					ago: { [weak self] in self?.premisKonservitaj() }
				),
				ShovMenuoViewController.Menuero(
					bildo: UIImage(named: "mapo"),
					teksto: Tekstoj.esplori,
					ago: { [weak self] in self?.premisEsplori() }
				),
				ShovMenuoViewController.Menuero(
					bildo: UIImage(named: "dentrado"),
					teksto: Tekstoj.agordoj,
					ago: { [weak self] in self?.premisAgordoj() }
				),
				ShovMenuoViewController.Menuero(
					bildo: UIImage(named: "nudatripunkto"),
					teksto: Tekstoj.mallongigoj,
					ago: { [weak self] in self?.premisMallongigoj() }
				),
				ShovMenuoViewController.Menuero(
					bildo: UIImage(named: "informoj"),
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
