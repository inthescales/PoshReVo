import UIKit

import ReVoDatumbazo

final class ArtikoloViewController: UIViewController {
	// MARK: Interfaceroj
	
	private lazy var titoloEtikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.text = artikolo.titolo
		etikedo.font = .systemFont(ofSize: 30)
		etikedo.textColor = stilo.teksto
		return etikedo
	}()
	
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
	}
}
