import UIKit

final class KonservitajViewController: UIViewController {
	// MARK: - Interfaceroj
	
	private lazy var tabelo: VortoListoViewController<Uzantlistero> = {
		let tabelo = VortoListoViewController(elektis: elektis)
		return tabelo
	}()
	
	// MARK: - Agordoj
	
	let elektis: (Uzantlistero) -> ()
	
	// MARK: - Pravalorizado
	
	init(konservitaj: [Konservitajho], elektis: @escaping (Uzantlistero) -> ()) {
		self.elektis = elektis
		super.init(nibName: nil, bundle: nil)
		
		tabelo.montri(listerojn: konservitaj.map { Uzantlistero(el: $0) })
	}
	
	convenience init(elektis: @escaping (Uzantlistero) -> (), uzantDatumaro: UzantDatumaro = .komuna) {
		self.init(konservitaj: uzantDatumaro.konservitaj, elektis: elektis)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		addChild(tabelo)
		view.addEdgeMatchedSubview(tabelo.view)
	}
}
