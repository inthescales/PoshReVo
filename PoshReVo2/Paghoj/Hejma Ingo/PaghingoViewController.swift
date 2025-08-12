import UIKit

/// VC kiu enhavas alian VC-on, sed prezentas siajn proprajn navigaciaĵojn.
/// Ĝia ĉefa celo estas apartigi la ŝovmenuan butonon kaj la serĉpaĝon.
final class PaghingoViewController: UIViewController {
	// MARK: - Interfaceroj
	
	/// Butono montranta shovmenuon navigacian
	lazy var tripunktoButono = {
		let butono = UIBarButtonItem.init(
			image: UIImage(named: "tripunkto"),
			style: .plain,
			target: self,
			action: #selector(Self.premisTripunkton)
		)
		butono.tintColor = DinamikaStilo.navigaciaButono
		butono.accessibilityLabel = AlirebloTekstoj.malfermiMenuon
		
		return butono
	}()
	
	// MARK: - Agordoj
	
	/// La paĝo kiu estos prezentata al uzanto
	let chefpagho: Ingito
	
	let kunordigilo: Kunordigilo
	
	// MARK: - Valorizado
	
	init(chefpagho: Ingito, kunordigilo: Kunordigilo = .komuna) {
		self.chefpagho = chefpagho
		self.kunordigilo = kunordigilo
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = chefpagho.titolo
		navigationItem.rightBarButtonItem = tripunktoButono
		
		addChild(chefpagho)
		view.addEdgeMatchedSubview(chefpagho.view)
	}
	
	// MARK: - Paĝ-navigaciado
	
	@objc private func premisTripunkton() {
		chefpagho.view.endEditing(true) // Kaŝi la klavaron
		
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
			agordoj: ShovMenuoViewController.Agordoj.el(stilo: UzantDatumaro.komuna.stilo, titolo: nil),
			navigaciilaAlto: navigaciAlto,
			forigi: { [weak self] in
				self?.dismiss(animated: false)
			}
		)
		menuo.modalPresentationStyle = .overFullScreen
		present(menuo, animated: false)
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
	
	// MARK: - Publikaj agoj
	
	/// Forigi antaŭan staton de la prezentata paĝo
	func restarigi() {
		chefpagho.restarigi()
	}
}
