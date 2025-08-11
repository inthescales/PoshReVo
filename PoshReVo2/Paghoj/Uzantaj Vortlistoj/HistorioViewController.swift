import UIKit

/// Montras la historion de artikoloj kiujn la uzanto jam legis
final class HistorioViewController: UIViewController {
	// MARK: - Interfaceroj
	
	/// Butono por nuligi la historion
	private lazy var nuligiButono = {
		let butono = UIBarButtonItem.init(
			title: Tekstoj.nuligi,
			style: .plain,
			target: self,
			action: #selector(forigi)
		)
		butono.tintColor = DinamikaStilo.navigaciaButono
		return butono
	}()
	
	private lazy var tabelo: VortoListoViewController<Uzantlistero> = {
		let tabelo = VortoListoViewController(
			nulTeksto: Tekstoj.historioNulTeksto,
			elektis: elektis
		)
		return tabelo
	}()
	
	// MARK: - Agordoj
	
	/// Fermo por elekto de artikoloj
	private let elektis: (Uzantlistero) -> ()
	
	private let datumRegilo: UzantDatumoRegilo
	
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
		
		title = Tekstoj.historio
		navigationItem.rightBarButtonItem = nuligiButono
		
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
		nuligiButono.isEnabled = !historio.isEmpty
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
	
	/// Reagas al ŝanĝigoj en la historio
	@objc private func historioShanghighis(_ avizo: Notification) {
		guard let novlastaj = avizo.object as? [Konservitajho] else {
			return
		}
		
		montri(novlastaj)
	}
}
