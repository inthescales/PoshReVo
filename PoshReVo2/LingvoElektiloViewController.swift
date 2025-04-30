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
	
	/// Vokota kiam uzanto elektos lingvon
	let elektisLingvon: (Lingvo) -> ()
	
	//
	
	init(kromEsperanto: Bool = false, elektisLingvon: @escaping (Lingvo) -> ()) {
		lingvaro = kromEsperanto
			? VortaroDatumbazo.komuna.neesperantajLingvoj
			: VortaroDatumbazo.komuna.chiujLingvoj
		montrotajLingvoj = lingvaro
		
		self.elektisLingvon = elektisLingvon
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
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
