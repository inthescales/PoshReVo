import UIKit

import ReVoDatumbazo

import TTTAttributedLabel

final class ArtikoloViewController: UIViewController {
	private enum Konstantoj {
		static let subartikoloChelIdentigilo = "subartikoloChelo"
		
		static let derivajhoChelIdentigilo = "derivajhoChelo"
	}
	
	private enum CheloDatumo {
		case subartikolo(Subartikolo)
		case derivajho(Vorto)
		
		var identigilo: String {
			switch self {
			case .subartikolo:
				return Konstantoj.subartikoloChelIdentigilo
			case .derivajho:
				return Konstantoj.derivajhoChelIdentigilo
			}
		}
	}
	
	// MARK: Interfaceroj
	
	private lazy var titoloEtikedo: ArtikolTitoloView = {
		let etikedo = ArtikolTitoloView(
			artikolo: artikolo,
			stilo: stilo
		)
		return etikedo
	}()
	
	private lazy var tabelo: UITableView = {
		let tabelo = UITableView()
		tabelo.dataSource = self
		tabelo.register(
			ArtikolTekstoChelo.self,
			forCellReuseIdentifier: Konstantoj.subartikoloChelIdentigilo
		)
		tabelo.register(
			DerivajhoChelo.self,
			forCellReuseIdentifier: Konstantoj.derivajhoChelIdentigilo
		)
		return tabelo
	}()
	
	// MARK: Stato
	
	private var cheloDatumoj: [CheloDatumo]
	
	// MARK: Agordoj
	
	private let artikolo: Artikolo
	
	private var stilo: InterfacStilo
	
	//
	
	init(
		artikolo: Artikolo,
		stilo: InterfacStilo = .nuna
	) {
		self.artikolo = artikolo
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
	}
	
	// MARK: Helpiloj
	
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

extension ArtikoloViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		cheloDatumoj.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let datumero = cheloDatumoj[indexPath.row]
		guard let chelo = tabelo.dequeueReusableCell(withIdentifier: datumero.identigilo) else {
			fatalError("Malsukcesis krei ĉelon")
		}
		
		switch datumero {
		case .derivajho(let vorto):
			(chelo as? DerivajhoChelo)?.agordi(vorto: vorto, stilo: stilo)
		case .subartikolo(let subartikolo):
			(chelo as? ArtikolTekstoChelo)?.agordi(teksto: subartikolo.teksto, stilo: stilo)
		}
		
		return chelo
	}
}

extension ArtikoloViewController: TTTAttributedLabelDelegate {
	
	// Uzanto premis ligilon - iri al la dezirata sekcio de la artikolo, au montri novan artikolon
	func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL?) {
		
//		let marko = url?.absoluteString ?? ""
//		let partoj = marko.components(separatedBy: ".")
//		
//		if partoj.count == 0 {
//			return
//		}
//		
//		if partoj[0] == artikolo?.indekso {
//			if partoj.count >= 2 {
//				saltiAlMarko(partoj[0] + "." + partoj[1], animacii: true)
//			}
//		} else {
//			if let artikolo =  VortaroDatumbazo.komuna.artikolo(indekso: partoj[0]) {
//				navigationItem.backBarButtonItem = UIBarButtonItem(title: self.artikolo?.titolo, style: .plain, target: nil, action: nil)
//				(self.navigationController as? ChefaNavigationController)?.montriArtikolon(artikolo, marko: marko)
//			}
//		}
	}
}
