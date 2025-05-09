import UIKit

final class HistorioViewController: UIViewController {
	// MARK: - Interfaceroj
	
	private lazy var tabelo: VortoListoViewController<Uzantlistero> = {
		let tabelo = VortoListoViewController(elektis: elektis)
		return tabelo
	}()
	
	// MARK: - Agordoj
	
	let elektis: (Uzantlistero) -> ()
	
	// MARK: - Pravalorizado
	
	init(lastaj: [Konservitajho], elektis: @escaping (Uzantlistero) -> ()) {
		self.elektis = elektis
		super.init(nibName: nil, bundle: nil)
		
		tabelo.montri(listerojn: lastaj.map { Uzantlistero(el: $0) })
	}
	
	convenience init(elektis: @escaping (Uzantlistero) -> (), uzantDatumaro: UzantDatumaro = .komuna) {
		self.init(lastaj: uzantDatumaro.historio, elektis: elektis)
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
			selector: #selector(historioShanghighis(_:)),
			name: Avizoj.historioShanghighis,
			object: nil
		)
	}
	
	// MARK: - Reagoj
	
	@objc private func historioShanghighis(_ avizo: Notification) {
		guard let novlastaj = avizo.object as? [Konservitajho] else {
			return
		}
		
		tabelo.montri(listerojn: novlastaj.map { Uzantlistero(el: $0) })
	}
}
