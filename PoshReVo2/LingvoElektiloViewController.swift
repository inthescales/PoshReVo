import UIKit

import ReVoDatumbazo

final class LingvoElektiloViewController: UIViewController {
	let serchilo = SerchiloView(
		lokokupaTeksto: Tekstoj.serchiLingvon,
		iksumi: true,
		tekstoShanghighis: { teksto in }
	)
	
	lazy var lingvoListoVC = {
		let lingvoj = kromEsperanto
			? VortaroDatumbazo.komuna.neesperantajLingvoj
			: VortaroDatumbazo.komuna.chiujLingvoj

		return LingvoListoViewController(
			lingvoj: lingvoj,
			elektisLingvon: { [weak self] lingvo in
				self?.dismiss(animated: true)
				self?.elektisLingvon(lingvo)
			}
		)
	}()
	
	// Agordoj

	let kromEsperanto: Bool
	
	let elektisLingvon: (Lingvo) -> ()
	
	//
	
	init(kromEsperanto: Bool = false, elektisLingvon: @escaping (Lingvo) -> ()) {
		self.kromEsperanto = kromEsperanto
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
}
