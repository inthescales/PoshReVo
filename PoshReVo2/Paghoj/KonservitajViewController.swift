import UIKit

final class KonservitajViewController: UIViewController {
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
		konservitaj: [Konservitajho],
		datumRegilo: UzantDatumoRegilo = .komuna,
		elektis: @escaping (Uzantlistero) -> ()
	) {
		self.elektis = elektis
		self.datumRegilo = datumRegilo
		super.init(nibName: nil, bundle: nil)
		
		montri(konservitaj)
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
		
		title = Tekstoj.konservitaj
		navigationItem.rightBarButtonItem = forigiButono
		
		addChild(tabelo)
		view.addEdgeMatchedSubview(tabelo.view)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(konservitajShanghighis(_:)),
			name: Avizoj.konservitajShanghighis,
			object: nil
		)
	}
	
	// MARK: - Agordado
	
	private func montri(_ konservitaj: [Konservitajho]) {
		forigiButono.isEnabled = !konservitaj.isEmpty
		tabelo.montri(listerojn: konservitaj.reversed().map { Uzantlistero(el: $0) })
	}
	
	// MARK: - Agoj
	
	@objc private func forigi() {
		AgoHelpiloj.prezentiKonfirmilon(
			teksto: Tekstoj.forigiKonservitajnDemand,
			prezentilo: self,
		) { [weak self] in
			self?.datumRegilo.forigiKonservitajn()
		}
	}
	
	// MARK: - Reagoj
	
	@objc private func konservitajShanghighis(_ avizo: Notification) {
		guard let novkonservitaj = avizo.object as? [Konservitajho] else {
			return
		}
		
		montri(novkonservitaj)
	}
}
