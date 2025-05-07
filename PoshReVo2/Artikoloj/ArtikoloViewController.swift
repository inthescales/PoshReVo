import UIKit

import ReVoDatumbazo

import TTTAttributedLabel

final class ArtikoloViewController: UIViewController {
	private enum Konstantoj {
		static let subartikoloChelIdentigilo = "subartikoloChelo"
		
		static let derivajhoChelIdentigilo = "derivajhoChelo"
		
		static let tradukoChelIdentigilo = "tradukoChelo"
	}
	
	private enum CheloDatumo {
		case subartikolo(Subartikolo)
		case derivajho(Vorto)
		case traduko(Traduko)
		
		var identigilo: String {
			switch self {
			case .subartikolo:
				return Konstantoj.subartikoloChelIdentigilo
			case .derivajho:
				return Konstantoj.derivajhoChelIdentigilo
			case .traduko:
				return Konstantoj.tradukoChelIdentigilo
			}
		}
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
	
	private lazy var titoloEtikedo: ArtikolTitoloView = {
		let etikedo = ArtikolTitoloView(
			artikolo: artikolo,
			stilo: stilo
		)
		return etikedo
	}()
	
	private lazy var tabelo: UITableView = {
		let tabelo = UITableView()
		tabelo.delegate = self
		tabelo.dataSource = self
		tabelo.register(
			ArtikolTekstoChelo.self,
			forCellReuseIdentifier: Konstantoj.subartikoloChelIdentigilo
		)
		tabelo.register(
			DerivajhoChelo.self,
			forCellReuseIdentifier: Konstantoj.derivajhoChelIdentigilo
		)
		tabelo.register(
			TradukoChelo.self,
			forCellReuseIdentifier: Konstantoj.tradukoChelIdentigilo
		)
		return tabelo
	}()
	
	// MARK: Stato
	
	private var cheloDatumoj: [CheloDatumo]
	
	private var tradukoj: [Traduko] {
		tradukLingvoj.compactMap { lingvo in
			artikolo.tradukoj.first(where: { $0.lingvo == lingvo })
		}
	}
	
	private var tradukLingvoj: [Lingvo] {
		didSet {
			tabelo.reloadData()
		}
	}
	
	// MARK: Agordoj
	
	private let artikolo: Artikolo
	
	private let aperis: (() -> ())?
	
	private let kunordigilo: Kunordigilo
	
	private var stilo: InterfacStilo
	
	//
	
	init(
		artikolo: Artikolo,
		tradukLingvoj: [Lingvo] = [],
		aperis: (() -> ())?,
		kunordigilo: Kunordigilo = .komuna,
		stilo: InterfacStilo = .nuna
	) {
		self.artikolo = artikolo
		self.tradukLingvoj = tradukLingvoj
		self.aperis = aperis
		self.kunordigilo = kunordigilo
		self.stilo = stilo
		
		self.cheloDatumoj = Self.cheloDatumoj(el: artikolo)
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		view.backgroundColor = stilo.senkoloraFono
		
		view.addSubview(titoloEtikedo)
		titoloEtikedo.snp.makeConstraints { make in
			make.top.left.right.equalToSuperview()
		}
		
		view.addSubview(tabelo)
		tabelo.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview()
			make.top.equalTo(titoloEtikedo.snp.bottom)
		}
		
		navigationItem.rightBarButtonItem = lupeoButono
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
	
	// MARK: Agoj
	
	/// Haste rulumi al la celata marko
	private func saltiAlMarko(_ marko: String, animacii: Bool) {
		for (i, datumo) in cheloDatumoj.enumerated() {
			switch datumo {
			case .derivajho(let vorto):
				if vorto.marko == marko {
					tabelo.scrollToRow(at: IndexPath(row: i, section: 0), at: .top, animated: animacii)
				}
			default:
				break
			}
		}
	}
	
	// MARK: Helpiloj
	
	/// Kreas datumojn pri prezentotaj ĉeloj laŭ la artikolo
	private static func cheloDatumoj(el artikolo: Artikolo) -> [CheloDatumo] {
		var datumoj: [CheloDatumo] = []
		
		for subartikolo in artikolo.subartikoloj {
			if !subartikolo.teksto.isEmpty {
				datumoj.append(.subartikolo(subartikolo))
			}
			
			for vorto in subartikolo.vortoj {
				datumoj.append(.derivajho(vorto))
			}
		}
		
		return datumoj
	}
}

extension ArtikoloViewController: UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return nil
	}
}

extension ArtikoloViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return cheloDatumoj.count
		case 1:
			return tradukoj.count
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 1 {
			return UITableView.automaticDimension
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let datumero: CheloDatumo
		switch indexPath.section {
		case 0:
			datumero = cheloDatumoj[indexPath.row]
		case 1:
			datumero = .traduko(tradukoj[indexPath.row])
		default:
			fatalError("Malsukcesis identigi chelodatumojn")
		}
		
		guard let chelo = tabelo.dequeueReusableCell(withIdentifier: datumero.identigilo) else {
			fatalError("Malsukcesis krei ĉelon")
		}
		
		switch datumero {
		case .derivajho(let vorto):
			(chelo as? DerivajhoChelo)?.agordi(vorto: vorto, liganto: self, stilo: stilo)
		case .subartikolo(let subartikolo):
			(chelo as? ArtikolTekstoChelo)?.agordi(teksto: subartikolo.teksto, stilo: stilo)
		case .traduko(let traduko):
			(chelo as? TradukoChelo)?.agordi(traduko: traduko, liganto: self, stilo: stilo)
		}
		
		chelo.selectionStyle = .none
		
		return chelo
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == 1 {
			return TradukojKapoView()
		} else {
			return nil
		}
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		if section == 1 {
			return TradukojPiedoView(
				ago: { [weak self] in
					guard let self,
						  let navigaciilo = navigationController else {
						return
					}
					
					kunordigilo.prezentiLingvoElektilon(
						prezentilo: navigaciilo,
						kompleti: { [weak self] lingvoj in
							self?.tradukLingvoj = lingvoj
						})
				}
				,stilo: stilo
			)
		} else {
			return nil
		}
	}
}

extension ArtikoloViewController : TTTAttributedLabelDelegate {
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
