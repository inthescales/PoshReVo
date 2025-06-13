import UIKit

import ReVoDatumbazo

import TTTAttributedLabel

final class ArtikoloViewController: UIViewController {
	private enum Konstantoj {
		static let derivajhTitoloIdentigilo = "derivajhTitolaIdentigilo"
		static let ekzemplaroIdentigilo = "ekzemplaIdentigilo"
		static let dividiloIdentigilo = "dividiloIdentigilo"
		static let tekstoIdentigilo = "tekstaIdentigilo"
		static let tradukaroIdentigilo = "tradukaIdentigilo"
	}
	
	// MARK: Interfaceroj
	
	lazy var lupeoButono = {
		let butono = UIBarButtonItem.init(
			image: UIImage(named: "lupeo"),
			style: .plain,
			target: self,
			action: #selector(Self.premisLupeon)
		)
		butono.tintColor = stilo.surkoloraTeksto
		return butono
	}()
	
	private lazy var titolejo: ArtikolTitoloView = {
		let etikedo = ArtikolTitoloView(
			artikolo: artikolo,
			konservis: konservis,
			salti: premisSalti,
			stilo: stilo
		)
		return etikedo
	}()
	
	private lazy var tabelo: UITableView = {
		let tabelo = UITableView()
		tabelo.delegate = self
		tabelo.dataSource = self
		tabelo.rowHeight = UITableView.automaticDimension
		tabelo.estimatedRowHeight = 100
		tabelo.register(
			DerivajhTitoloChelo.self,
			forCellReuseIdentifier: Konstantoj.derivajhTitoloIdentigilo
		)
		tabelo.register(
			SubartikoloTitoloChelo.self,
			forCellReuseIdentifier: Konstantoj.dividiloIdentigilo
		)
		tabelo.register(
			TekstoChelo.self,
			forCellReuseIdentifier: Konstantoj.tekstoIdentigilo
		)
		tabelo.register(
			TekstoChelo.self,
			forCellReuseIdentifier: Konstantoj.ekzemplaroIdentigilo
		)
		tabelo.register(
			TradukaroChelo.self,
			forCellReuseIdentifier: Konstantoj.tradukaroIdentigilo
		)
		
		return tabelo
	}()
	
	// MARK: Stato
	
	private var tradukLingvoj: [Lingvo] {
		didSet {
			tabelo.reloadData()
		}
	}
	
	// MARK: Agordoj
	
	private let artikolo: Artikolo
	
	private let komencaMarko: String?
	
	private let aperis: (() -> ())?
	
	private let konservis: (Bool) -> ()
	
	private let kunordigilo: Kunordigilo
	
	private let stilo: InterfacStilo
	
	//
	
	init(
		artikolo: Artikolo,
		marko: String? = nil,
		konservita: Bool,
		tradukLingvoj: [Lingvo] = [],
		aperis: (() -> ())?,
		konservis: @escaping (Bool) -> (),
		kunordigilo: Kunordigilo = .komuna,
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.artikolo = artikolo
		self.komencaMarko = marko
		self.tradukLingvoj = tradukLingvoj
		self.aperis = aperis
		self.konservis = konservis
		self.kunordigilo = kunordigilo
		self.stilo = stilo
		
		super.init(nibName: nil, bundle: nil)
		
		titolejo.agordi(konservita: konservita)
	}
	
	convenience init(
		artikolo: Artikolo,
		marko: String? = nil,
		aperis: (() -> ())?,
		konservis: @escaping (Bool) -> (),
		uzantDatumaro: UzantDatumaro = .komuna,
		kunordigilo: Kunordigilo = .komuna,
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.init(
			artikolo: artikolo,
			marko: marko,
			konservita: uzantDatumaro.chuKonservita(artikolo: artikolo),
			tradukLingvoj: uzantDatumaro.lingvoj,
			aperis: aperis,
			konservis: konservis
		)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	override func viewDidLoad() {
		view.backgroundColor = stilo.senkoloraFono
		
		view.addSubview(titolejo)
		titolejo.snp.makeConstraints { make in
			make.top.left.right.equalToSuperview()
		}
		
		view.addSubview(tabelo)
		tabelo.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview()
			make.top.equalTo(titolejo.snp.bottom)
		}
		
		navigationItem.rightBarButtonItem = lupeoButono
		
		let butono = UIButton(type: .system)
		butono.addTarget(self, action: #selector(premisHejmon), for: .touchUpInside)
		butono.setImage(UIImage(named: "libro")!, for: .normal)
		butono.tintColor = stilo.senkoloraFono
		navigationItem.titleView = butono
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(lingvojShanghighis(_:)),
			name: Avizoj.uzantajLingvojShanghighis,
			object: nil
		)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if let marko = komencaMarko {
			saltiAlMarko(marko, animacii: false)
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		aperis?()
	}
	
	// MARK: Uzantaj agoj
	
	@objc private func premisLupeon() {
		guard let navigaciilo = navigationController else {
			return
		}
		
		kunordigilo.prezentiSerchPaghon(prezentilo: navigaciilo)
	}
	
	@objc private func premisHejmon() {
		navigationController?.popToRootViewController(animated: true)
	}
	
	// MARK: Avizoj
	
	@objc private func lingvojShanghighis(_ avizo: Notification) {
		guard let lingvoj = avizo.object as? [Lingvo] else { return }
		tradukLingvoj = lingvoj
	}
	
	// MARK: Agoj
	
	private func premisSalti() {
		let eroj: [ShovMenuoViewController.Menuero] = artikolo.blokoj.compactMap {
			switch $0 {
			case .dividila:
				return ShovMenuoViewController.Menuero(teksto: "---") {}
			case .derivajhTitola(let teksto, _, let marko):
				return ShovMenuoViewController.Menuero(teksto: teksto) { [weak self] in
					guard let self,
						  let marko else {
						return
					}
					
					saltiAlMarko(marko, animacii: true)
				}
			default:
				return nil
			}
		}
		
		let menuo = ShovMenuoViewController(
			eroj: eroj,
			navigaciilaAlto: navigationController?.navigationBar.bounds.height ?? 0.0,
			forigi: { [weak self] in
				self?.dismiss(animated: false)
			}
		)
		
		menuo.modalPresentationStyle = .overFullScreen
		navigationController?.present(menuo, animated: false)
	}
	
	/// Haste rulumi al la celata marko
	private func saltiAlMarko(_ marko: String, animacii: Bool) {
		for (i, bloko) in artikolo.blokoj.enumerated() {
			switch bloko {
			case .derivajhTitola(_, _, let blokMarko):
				if blokMarko == marko {
					tabelo.scrollToRow(at: IndexPath(row: i, section: 0), at: .top, animated: animacii)
				}
			default:
				break
			}
		}
	}
	
	// MARK: - Helpiloj
	
	func chelIdentigilo(por bloko: ArtikolBloko) -> String {
		switch bloko {
		case .derivajhTitola:
			Konstantoj.derivajhTitoloIdentigilo
		case .dividila:
			Konstantoj.dividiloIdentigilo
		case .teksta:
			Konstantoj.tekstoIdentigilo
		case .traduka:
			Konstantoj.tradukaroIdentigilo
		}
	}
}

extension ArtikoloViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return nil
	}
}

extension ArtikoloViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return artikolo.blokoj.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let bloko = artikolo.blokoj[indexPath.row]
		guard let chelo = tabelo.dequeueReusableCell(withIdentifier: chelIdentigilo(por: bloko)) else {
			fatalError("Malsukcesis krei ĉelon")
		}
		
		switch bloko {
		case .dividila(teksto: let teksto):
			(chelo as? SubartikoloTitoloChelo)?.agordi(teksto: teksto, stilo: stilo)
		case .derivajhTitola(teksto: let teksto, _, _):
			(chelo as? DerivajhTitoloChelo)?.agordi(teksto: teksto, stilo: stilo)
		case .teksta(let teksto):
			(chelo as? TekstoChelo)?.agordi(teksto: teksto, liganto: self, stilo: stilo)
		case .traduka(let tradukoj):
			// TODO: Ŝanĝu post kiam lingvo estos denove struct
			let tradukKodoj = tradukLingvoj.map { $0.kodo }
			let montrotaj = tradukoj
				.filter { tradukKodoj.contains($0.lingvo.kodo) }
			(chelo as? TradukaroChelo)?.agordi(tradukoj: montrotaj, liganto: self, stilo: stilo)
		}
		chelo.selectionStyle = .none
		
		return chelo
	}
}

extension ArtikoloViewController: TTTAttributedLabelDelegate {
	// NOTU: Eblas aldoni ĉi tiun saman kapablon per UITextView anstataŭ TTTAttributedLabel.
	// Vidu https://www.kodeco.com/2587-easily-overlooked-new-features-in-ios-7?page=4#toc-anchor-025
	// TAMEN, mi ankoraŭ uzas TTT ĉar la ligado per tio estas multe pli rapida
	// Ankaŭ esplorinda: https://stackoverflow.com/questions/22379595/uitextview-link-tap-recognition-is-delayed
	func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
		let marko = url.absoluteString
		let markeroj = marko.components(separatedBy: ".")
		
		guard markeroj.count > 1 else {
			return
		}
		
		if markeroj[0] == artikolo.indekso
			&& markeroj.count >= 2 {
			saltiAlMarko(markeroj[0] + "." + markeroj[1], animacii: true)
		} else {
			if let artikolo = VortaroDatumbazo.komuna.artikolo(indekso: markeroj[0]),
				let navigaciilo = navigationController {
				kunordigilo.prezentiArtikoloPaghon(el: artikolo, prezentilo: navigaciilo)
				// TODO: Salti ene de artikolo?
			}
		}
	}
}
