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
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		addChild(tabelo)
		view.addEdgeMatchedSubview(tabelo.view)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(konservitajShanghighis(_:)),
			name: Avizoj.konservitajShanghighis,
			object: nil
		)
	}
	
	// MARK: - Reagoj
	
	@objc private func konservitajShanghighis(_ avizo: Notification) {
		guard let novkonservitaj = avizo.object as? [Konservitajho] else {
			return
		}
		
		tabelo.montri(listerojn: novkonservitaj.map { Uzantlistero(el: $0) })
	}
}
