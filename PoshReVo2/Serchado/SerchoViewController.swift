import UIKit

import ReVoDatumbazo

final class SerchoViewController: UIViewController {
	// MARK: Interfaceroj
	lazy var serchilo = SerchiloView(
		lokokupaTeksto: Tekstoj.serchiVortonAuFrazon,
		iksumi: true, // TODO: Nur se neesperanta lingvo uziĝas
		tekstoShanghighis: { teksto in }
	)
	
	lazy var lingvoBreto: LingvoBretoView = {
		LingvoBretoView(
			lingvoj: komencajLingvoj,
			elektisLingvon: { lingvo in },
			redaktisLingvojn: { lingvoj in }
		)
	}()
	
	lazy var rezultoTabelo = VortoListoViewController()
	
	// MARK: Agordoj
		
	let komencajLingvoj: [Lingvo] // TODO: Injekcii datumaron
	
	//
	
	init(serchLingvoj: [Lingvo]) {
		self.komencajLingvoj = serchLingvoj
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
		
		view.addSubview(lingvoBreto)
		lingvoBreto.snp.makeConstraints { make in
			make.left.right.equalToSuperview()
			make.top.equalTo(serchilo.snp.bottom)
		}
		
		addChild(rezultoTabelo)
		view.addSubview(rezultoTabelo.view)
		rezultoTabelo.view.snp.makeConstraints { make in
			make.top.equalTo(lingvoBreto.snp.bottom)
			make.left.right.bottom.equalToSuperview()
		}
	}
}
