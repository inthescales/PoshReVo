import UIKit

import ReVoDatumbazo

import TTTAttributedLabel

/// Ekrano montranta artikolon
final class ArtikoloViewController: UIViewController {
	private enum Konstantoj {
		static let derivajhTitoloIdentigilo = "derivajhTitolaIdentigilo"
		static let ekzemplaroIdentigilo = "ekzemplaIdentigilo"
		static let dividiloIdentigilo = "dividiloIdentigilo"
		static let tekstoIdentigilo = "tekstaIdentigilo"
		static let tradukaroIdentigilo = "tradukaIdentigilo"
		
		/// Marĝeno ĉe ambaŭ horizontalaj flankoj de la artikolaĵoj
		static let flankaMargheno: CGFloat = 8.0
		
		/// Marĝeno inter tekstbloko kaj paĝsupro, paĝmalsupro, kaj aliaj malagrablaj elementoj
		static let vertikalaTekstMargheno: CGFloat = 16.0
	}
	
	// MARK: - Interfaceroj
	
	/// Butono kiu kondukas reen al hejmpaĝo
	private lazy var lupeoButono = {
		let butono = UIBarButtonItem.init(
			image: Bildetoj.lupeo,
			style: .plain,
			target: self,
			action: #selector(Self.premisLupeon)
		)
		butono.tintColor = stilo.navigaciaButono
		butono.accessibilityLabel = AlirebloTekstoj.serchi
		
		return butono
	}()
	
	/// Tabelo enhavanta ĉiujn artikolenhavojn
	private lazy var tabelo: UITableView = {
		let tabelo = UITableView()
		tabelo.delegate = self
		tabelo.dataSource = self
		tabelo.rowHeight = UITableView.automaticDimension
		tabelo.estimatedRowHeight = 100
		tabelo.separatorStyle = .none
		tabelo.backgroundColor = .clear
		
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
	
	/// Suba tabulo enhavanta agbutonojn rilate al la tuta artikolo
	private lazy var agtabulo: AgtabuloView = {
		AgtabuloView(
			konservita: uzantDatumaro.konservitaj.contains(where: { $0.indekso == artikolo.indekso }),
			konservis: konservis,
			salti: { [weak self] in self?.premisSalti()
			}
		)
	}()
	
	/// Vido kiu pendas sub la agtabulo. Donas ĝustan fonkoloron al la plej malsupra regiono de la ekrano
	/// sur aparatoj kiuj havas kroman spacon sub la bordoj de la 'safe area'
	private lazy var subagtabulo: UIView = {
		let view = UIView()
		view.backgroundColor = stilo.navigaciaFono
		return view
	}()
	
	// MARK: - Stato
	
	/// Lingvoj en kiu tradukoj aperu
	private var tradukLingvoj: [Lingvo] {
		didSet {
			tabelo.reloadData()
		}
	}
	
	/// Ĉu la paĝo jam aperis. Regas saltadon.
	private var jamAperis = false
	
	// MARK: - Agordoj
	
	/// La artikolo prezentata
	private let artikolo: Artikolo
	
	/// Marko en la artikolo kiu estu vidata komence
	private let komencaMarko: String?
	
	/// Fermo vokota paĝ-apere
	private let aperis: (() -> ())?
	
	/// Fermo vokota kiam la uzanto konservas aŭ malkonservas la artikolon
	private let konservis: (Bool) -> ()
	
	private let kunordigilo: Kunordigilo
	
	private let uzantDatumaro: UzantDatumaro
	
	private let stilo: InterfacStilo
	
	// MARK: - Valorizado
	
	init(
		artikolo: Artikolo,
		marko: String? = nil,
		konservita: Bool,
		tradukLingvoj: [Lingvo] = [],
		aperis: (() -> ())?,
		konservis: @escaping (Bool) -> (),
		kunordigilo: Kunordigilo = .komuna,
		uzantDatumaro: UzantDatumaro = .komuna,
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.artikolo = artikolo
		self.komencaMarko = marko
		self.tradukLingvoj = tradukLingvoj
		self.aperis = aperis
		self.konservis = konservis
		self.kunordigilo = kunordigilo
		self.uzantDatumaro = uzantDatumaro
		self.stilo = stilo
		
		super.init(nibName: nil, bundle: nil)
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
		navigationItem.rightBarButtonItem = lupeoButono
		view.backgroundColor = stilo.dokumentaFono
		
		view.addSubview(tabelo)
		tabelo.snp.makeConstraints { make in
			make.top.left.right.equalToSuperview()
		}
		
		view.addSubview(agtabulo)
		agtabulo.snp.makeConstraints { make in
			make.top.equalTo(tabelo.snp.bottom)
			make.left.right.equalToSuperview()
			make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
		}
		
		view.addSubview(subagtabulo)
		subagtabulo.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
		}
		
		let indico = artikolo.ofc.flatMap { TekstHelpiloj.indico(por: $0) } ?? ""
		title = artikolo.titolo + indico
		
		navigationItem.titleView?.tintColor = stilo.navigaciaTeksto
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(lingvojShanghighis(_:)),
			name: Avizoj.uzantajLingvojShanghighis,
			object: nil
		)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Se ni havas komencan markon, kaj jam ne saltis al ĝi, saltu al ĝi
		if !jamAperis,
		   let marko = komencaMarko {
			saltiAl(marko: marko, animacii: true)
		}
		
		aperis?()
		jamAperis = true
	}
	
	// MARK: - Uzantaj agoj
	
	@objc private func premisLupeon() {
		guard let navigaciilo = navigationController else {
			return
		}
		
		kunordigilo.reveniHejmen(en: navigaciilo)
	}
	
	// MARK: - Avizoj
	
	@objc private func lingvojShanghighis(_ avizo: Notification) {
		guard let lingvoj = avizo.object as? [Lingvo] else { return }
		tradukLingvoj = lingvoj
	}
	
	// MARK: Agoj
	
	/// Uzanto premis saltbutonon
	/// Montri saltan menuon
	private func premisSalti() {
		// TODO: Eble alkroĉu indekson al la bloko mem
		var subartikolNumero = -1
		
		let eroj: [ShovMenuoViewController.Menuero] = artikolo.blokoj.compactMap {
			switch $0 {
			case .dividila(let teksto):
				subartikolNumero += 1
				return ShovMenuoViewController.Menuero(bildo: nil, teksto: teksto) { [subartikolNumero, weak self] in
					self?.saltiAl(subartikolo: subartikolNumero)
				}
			case .derivajhTitola(let teksto, _, let marko):
				return ShovMenuoViewController.Menuero(bildo: nil, teksto: teksto) { [weak self] in
					guard let self,
						  let marko else {
						return
					}
					
					saltiAl(marko: marko, animacii: true)
				}
			default:
				return nil
			}
		}
		
		let menuo = ShovMenuoViewController(
			eroj: eroj,
			agordoj: ShovMenuoViewController.Agordoj.el(stilo: stilo, titolo: Tekstoj.saltiAl),
			navigaciilaAlto: navigaciAlto,
			forigi: { [weak self] in
				self?.dismiss(animated: false)
			}
		)
		
		menuo.modalPresentationStyle = .overFullScreen
		navigationController?.present(menuo, animated: false)
	}
	
	/// Haste rulumi al la celata marko
	private func saltiAl(marko: String, animacii: Bool) {
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
	
	/// Haste rulumi al subartikol-titolo havanta tiun numeron
	private func saltiAl(subartikolo numero: Int) {
		var nombrilo = 0
		
		for (i, bloko) in artikolo.blokoj.enumerated() {
			switch bloko {
			case .dividila:
				if nombrilo == numero {
					tabelo.scrollToRow(at: IndexPath(row: i, section: 0), at: .top, animated: true)
				}
				nombrilo += 1
			default:
				break
			}
		}
	}
	
	// MARK: - Helpiloj
	
	private func chelIdentigilo(por bloko: ArtikolBloko) -> String {
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
			print("ERARO: malsukcesis krei ĉelon")
			return UITableViewCell()
		}
		
		switch bloko {
		case .dividila(teksto: let teksto):
			(chelo as? SubartikoloTitoloChelo)?.agordi(
				teksto: teksto,
				margheno: Konstantoj.flankaMargheno,
				stilo: stilo
			)
		case .derivajhTitola(teksto: let teksto, _, _):
			(chelo as? DerivajhTitoloChelo)?.agordi(
				teksto: teksto, 
				margheno: Konstantoj.flankaMargheno,
				stilo: stilo
			)
		case .teksta(let teksto):
			let spaciSupre = (indexPath.row == 0 || {
				switch artikolo.blokoj[indexPath.row - 1] {
				case .derivajhTitola:
					return false
				default:
					return true
				}
			}())
			let spaciMalsupre = (indexPath.row == tabelo.numberOfRows(inSection: indexPath.section) - 1)
			
			(chelo as? TekstoChelo)?.agordi(
				teksto: teksto,
				liganto: self,
				supraMargheno: (spaciSupre) ? Konstantoj.vertikalaTekstMargheno : 0,
				malsupraMargheno: (spaciMalsupre) ? Konstantoj.vertikalaTekstMargheno : 0,
				horizontalaMargheno: Konstantoj.flankaMargheno,
				stilo: stilo
			)
		case .traduka(let tradukoj):
			(chelo as? TradukaroChelo)?.agordi(
				tradukoj: tradukoj,
				tradukLingvoj: tradukLingvoj,
				margheno: Konstantoj.flankaMargheno,
				elekti: { [weak self] in
					guard let navigaciilo = self?.navigationController else { return }
					self?.kunordigilo.prezentiLingvoRedaktilon(
						prezentilo: navigaciilo,
						kompleti: { _ in }
					)
				},
				stilo: stilo
			)
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
		let urlTeksto = url.absoluteString
		
		// La URL indikas eksteran retejon - montri ĝin per retumilon
		if urlTeksto.prefix(4) == "http" {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
			return
		}
		
		// La URL indikas markon en ReVo-a artikolo
		let markeroj = urlTeksto.components(separatedBy: ".")
		
		// Markero indikanta artikolon
		let artikolMarko = markeroj[0]

		// Markoj en ligiloj foje havas pli ol 2 segmentojn, ekz. 'margxe.0ulo.MOD',
		// indikanta certan sencon aŭ rimarkon. Tamen, ĉiuj derivaĵeroj estas kunigitaj simple el
		// tekstoj, ne eblas salti rekte al tia elemento. Do ni uzu ĉi tie nur la unuaj du
		// markeroj, kiu indikos derivaĵon.
		// Notu ke foje, ĉi tiu traktado kaŭzas eraron. Ekz. en '-aĉ' estas ligilo al rimarko
		// 'fi.0.RIM', kiu fakte ne estas en derivaĵo 'fi.0' sed en 'fi.0_'.
		let derivajhMarko = (markeroj.count > 1) ?  [markeroj[0], markeroj[1]].joined(separator: ".") : nil
		
		// Salti ene de ĉi tiu artikolo
		if markeroj[0] == artikolo.indekso,
		   let derivajhMarko {
			saltiAl(marko: derivajhMarko, animacii: true)
			return
		}
		
		// Prezenti alian artikolon
		if let artikolo = VortaroDatumbazo.komuna.artikolo(indekso: artikolMarko),
				  let navigaciilo = navigationController {
			kunordigilo.prezentiArtikoloPaghon(
				el: artikolo,
				marko: derivajhMarko,
				prezentilo: navigaciilo
			)
			return
		}
	}
}
