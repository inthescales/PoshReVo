import UIKit

import ReVoDatumbazo

final class LingvoElektiloViewController: UIViewController {
	lazy var serchilo = SerchiloView(
		lokokupaTeksto: Tekstoj.serchiLingvon,
		iksumi: true,
		tekstoShanghighis: { [weak self] teksto in
			self?.filtriRezultojn(per: teksto)
		}
	)
	
	lazy var lingvoListoVC = {
		return LingvoListoViewController(
			lingvoj: montrotajLingvoj,
			jamElektitaj: jamElektitaj,
			elektisLingvon: { [weak self] lingvo in
				self?.dismiss(animated: true)
				self?.elektisLingvon(lingvo)
			}
		)
	}()
	
	// MARK: Stato

	var montrotajLingvoj: [Lingvo] {
		didSet {
			if oldValue != montrotajLingvoj {
				lingvoListoVC.montri(lingvojn: montrotajLingvoj)
			}
		}
	}
	
	// MARK: Agordoj

	/// La tuto de elekteblaj lingvoj
	let lingvaro: [Lingvo]
	
	/// Lingvoj kiuj estas jam elektitaj, kaj estu neelekteblaj ĉi tie
	let jamElektitaj: [Lingvo]
	
	/// Vokota kiam uzanto elektos lingvon
	let elektisLingvon: (Lingvo) -> ()
	
	private let stilo: InterfacStilo
	
	//
	
	init(
		kromEsperanto: Bool = false,
		jamElektitaj: [Lingvo],
		elektisLingvon: @escaping (Lingvo) -> (),
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		lingvaro = kromEsperanto
			? VortaroDatumbazo.komuna.neesperantajLingvoj
			: VortaroDatumbazo.komuna.chiujLingvoj
		montrotajLingvoj = lingvaro
		
		self.jamElektitaj = jamElektitaj
		self.elektisLingvon = elektisLingvon
		self.stilo = stilo
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		view.backgroundColor = stilo.koloraFono
		navigationItem.leftBarButtonItem = NavigaciiloHelpiloj.iksoButono(
			por: self,
			ago: #selector(Self.malaperi),
			stilo: stilo
		)
		
		view.addSubview(serchilo)
		serchilo.snp.makeConstraints { make in
			make.top.left.right.equalToSuperview()
		}
		
		addChild(lingvoListoVC)
		view.addSubview(lingvoListoVC.view)
		lingvoListoVC.view.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview()
			make.top.equalTo(serchilo.snp.bottom)
		}
	}
	
	@objc private func malaperi() {
		dismiss(animated: true)
	}
	
	// MARK: Serĉa Filtrado
	
	private func filtriRezultojn(per serchTeksto: String) {
		guard !serchTeksto.isEmpty else {
			montrotajLingvoj = lingvaro
			return
		}
		
		montrotajLingvoj = lingvaro.filter { lingvo in
			lingvo.nomo.lowercased().hasPrefix(serchTeksto.lowercased())
		}
	}
}
