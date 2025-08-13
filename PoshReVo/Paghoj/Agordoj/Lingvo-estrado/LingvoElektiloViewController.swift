import UIKit

import ReVoDatumbazo

/// Ekrano montranta liston da lingvoj, kiujn la uzanto povas aldoni al la uzantaj lingvoj
final class LingvoElektiloViewController: UIViewController {
	/// Tekstserĉilo
	private lazy var serchilo = SerchiloView(
		lokokupaTeksto: Tekstoj.serchiLingvon,
		iksumi: true,
		tekstoShanghighis: { [weak self] teksto in
			self?.filtriRezultojn(per: teksto)
		}
	)
	
	/// Lingvolisto
	private lazy var lingvoListoVC = {
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

	/// Lingvoj kiuj estu montrataj en la listo (ekz., filtrita sub-aro de la tuta lingvaro)
	private var montrotajLingvoj: [Lingvo] {
		didSet {
			if oldValue != montrotajLingvoj {
				lingvoListoVC.montri(lingvojn: montrotajLingvoj)
			}
		}
	}
	
	// MARK: Agordoj

	/// La tuto de elekteblaj lingvoj
	private let lingvaro: [Lingvo]
	
	/// Lingvoj kiuj estas jam elektitaj, kaj do estu neelekteblaj ĉi tie
	private let jamElektitaj: [Lingvo]
	
	/// Vokota kiam uzanto elektos lingvon
	private let elektisLingvon: (Lingvo) -> ()
	
	private let stilo: InterfacStilo
	
	// MARK: - Valorizado
	
	init(
		kromEsperanto: Bool = false,
		jamElektitaj: [Lingvo],
		elektisLingvon: @escaping (Lingvo) -> (),
		datumbazo: VortaroDatumbazo = .komuna,
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		lingvaro = (kromEsperanto)
			? datumbazo.neesperantajLingvoj
			: datumbazo.chiujLingvoj
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
		title = Tekstoj.aldoniLingvon
		navigationItem.leftBarButtonItem = NavigaciiloHelpiloj.rezigniButono(
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
	
	// MARK: - Serĉa Filtrado
	
	/// Efektivigas serĉon kaj filtras la liston da montrotaj lingvoj
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
