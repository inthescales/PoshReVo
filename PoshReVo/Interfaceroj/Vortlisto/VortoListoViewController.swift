import UIKit

import ReVoDatumbazo

// MARK: - Konstantoj

// Konstantoj estas ĉi tie ekster la klaso mem por ke "generic" klaso ne povas enhavi ĝin
fileprivate enum Konstantoj {
	/// Kiam ĉi-kvanto da listeroj restas, sciigu ke la uzanto alvenas la finon de la listo
	static let finaRegiono = 5
}

/// Reprezentas iun ajn ekranon kiu prezentas liston da vortoj. Ekz. serĉrezultoj, fakvortoj, ktp.
final class VortoListoViewController<L: Vortlistero>: UIViewController, UITableViewDelegate, UITableViewDataSource {
	// MARK: - Interfaceroj
	
	/// Vortotabelo
	private lazy var tabelo: UITableView = {
		let tabelo = UITableView()
		tabelo.delegate = self
		tabelo.dataSource = self
		
		return tabelo
	}()
	
	/// Mesaĝa vido aperanta kiam estas neniuj vortoj por montri
	private lazy var nulStatoView: VortListoNulStatoView = {
		return VortListoNulStatoView(teksto: nulaTeksto ?? "")
	}()
	
	// MARK: - Stato
	
	private var listeroj: [L] = []
	
	// MARK: - Agordoj
	
	/// Titolo kiu aperu ekransupre
	private let titolo: String?
	
	/// Mesaĝo kiu aperu kiam estas neniu vortoj por montri
	private let nulaTeksto: String?
	
	/// Fermo por kiam uzanto elektas vorton
	private let elektis: (L) -> ()
	
	/// Fermo por kiam uzanto rulumis ĝis la fino de la listo
	private let alvenasFinon: (() -> ())?
	
	private var stilo: InterfacStilo
	
	// MARK: - Valorizado
	
	init(
		titolo: String? = nil,
		nulTeksto: String? = nil,
		elektis: @escaping (L) -> (),
		alvenasFinon: (() -> ())? = nil,
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.titolo = titolo
		self.nulaTeksto = nulTeksto
		self.elektis = elektis
		self.alvenasFinon = alvenasFinon
		self.stilo = stilo
		
		super.init(nibName: nil, bundle: nil)
		
		meti(stilon: stilo)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		if let titolo {
			title = titolo
		}
		
		view.addEdgeMatchedSubview(tabelo)
		view.addEdgeMatchedSubview(nulStatoView)
	}
	
	/// Montri tiujn listerojn
	func montri(listerojn listeroj: [L]) {
		self.listeroj = listeroj
		tabelo.reloadData()
		
		nulStatoView.isHidden = (listeroj.count > 0)
	}
	
	func meti(stilon stilo: InterfacStilo) {
		self.stilo = stilo
		
		tabelo.backgroundColor = stilo.dokumentaFono
		tabelo.reloadData()
		nulStatoView.meti(stilon: stilo)
	}
	
	// MARK: - UITableViewDelegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		elektis(listeroj[indexPath.row])
		tableView.deselectRow(at: indexPath, animated: true)
	}

	// MARK: - UITableViewDataSource
	
	func numberOfSections(in tableView: UITableView) -> Int {
		1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		listeroj.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard indexPath.row < listeroj.count else {
			fatalError("Listero ne ekzistas")
		}
		
		let listero = listeroj[indexPath.row]
		
		let novaChelo = UITableViewCell(style: .value1, reuseIdentifier: "vortoListo")
		novaChelo.textLabel?.text = listero.teksto
		novaChelo.detailTextLabel?.text = listero.subteksto
		novaChelo.meti(stilon: stilo)
		
		let finlimo = tableView.numberOfRows(inSection: indexPath.section) - Konstantoj.finaRegiono
		if indexPath.row > finlimo {
			alvenasFinon?()
		}
		
		return novaChelo
	}
}
