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
		
		montri(lastaj)
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
	
	// MARK: - Agordado
	
	private func montri(_ historio: [Konservitajho]) {
		tabelo.montri(listerojn: historio.reversed().map { Uzantlistero(el: $0) })
	}
	
	// MARK: - Reagoj
	
	@objc private func historioShanghighis(_ avizo: Notification) {
		guard let novlastaj = avizo.object as? [Konservitajho] else {
			return
		}
		
		montri(novlastaj)
	}
}
