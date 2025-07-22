import UIKit

final class HistorioViewController: UIViewController {
	// MARK: - Interfaceroj
	
	lazy var forigiButono = {
		let butono = UIBarButtonItem.init(
			title: Tekstoj.forigi,
			style: .plain,
			target: self,
			action: #selector(forigi)
		)
		butono.tintColor = DinamikaStilo.navigaciaTeksto
		return butono
	}()
	
	private lazy var tabelo: VortoListoViewController<Uzantlistero> = {
		let tabelo = VortoListoViewController(elektis: elektis)
		return tabelo
	}()
	
	// MARK: - Agordoj
	
	let elektis: (Uzantlistero) -> ()
	
	let datumRegilo: UzantDatumoRegilo
	
	// MARK: - Pravalorizado
	
	init(
		lastaj: [Konservitajho],
		datumRegilo: UzantDatumoRegilo = .komuna,
		elektis: @escaping (Uzantlistero) -> (),
	) {
		self.elektis = elektis
		self.datumRegilo = datumRegilo
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
		
		navigationItem.rightBarButtonItem = forigiButono
		
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
		forigiButono.isEnabled = !historio.isEmpty
		tabelo.montri(listerojn: historio.reversed().map { Uzantlistero(el: $0) })
	}
	
	// MARK: - Agoj
	
	@objc private func forigi() {
		AgoHelpiloj.prezentiKonfirmilon(
			teksto: Tekstoj.forigiHistorionDemand,
			prezentilo: self,
		) { [weak self] in
			self?.datumRegilo.forigiHistorion()
		}
	}
	
	// MARK: - Reagoj
	
	@objc private func historioShanghighis(_ avizo: Notification) {
		guard let novlastaj = avizo.object as? [Konservitajho] else {
			return
		}
		
		montri(novlastaj)
	}
}
