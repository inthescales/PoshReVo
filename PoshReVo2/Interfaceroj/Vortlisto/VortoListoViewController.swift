import UIKit

import ReVoDatumbazo

//MARK: - Konstantoj

// Ĉi tie ekster la klaso por ke "generic" klaso ne povas enhavi ĝin
fileprivate enum Konstantoj {
	/// Kiam ĉi-kvanto da listeroj restas, sciigu ke la uzanto alvenas la finon de la listo
	static let finaRegiono = 5
}

/// Reprezentas iun ajn ekranon kiu prezentas liston da vortoj. Ekz. serĉrezultoj, fakvortoj, ktp.
final class VortoListoViewController<L: Vortlistero>: UIViewController, UITableViewDelegate, UITableViewDataSource {
	// MARK: - Interfaceroj
	
	lazy var tabelo: UITableView = {
		let tabelo = UITableView()
		tabelo.delegate = self
		tabelo.dataSource = self
		tabelo.backgroundColor = stilo.dokumentaFono
		
		return tabelo
	}()
	
	lazy var nulStatoView: VortListoNulStatoView = {
		return VortListoNulStatoView(teksto: nulTeksto ?? "")
	}()
	
	// MARK: - Stato
	
	private var listeroj: [L] = []
	
	// MARK: - Agordoj
	
	private let titolo: String?
	
	private let nulTeksto: String?
	
	private let elektis: (L) -> ()
	
	private let alvenasFinon: (() -> ())?
	
	private let stilo: InterfacStilo
	
	// MARK: - Pravalorizado
	
	init(
		titolo: String? = nil,
		nulTeksto: String? = nil,
		elektis: @escaping (L) -> (),
		alvenasFinon: (() -> ())? = nil,
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.titolo = titolo
		self.nulTeksto = nulTeksto
		self.elektis = elektis
		self.alvenasFinon = alvenasFinon
		self.stilo = stilo
		
		super.init(nibName: nil, bundle: nil)
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
	
	func montri(listerojn listeroj: [L]) {
		self.listeroj = listeroj
		tabelo.reloadData()
		
		nulStatoView.isHidden = (listeroj.count > 0)
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
		
		if indexPath.row > tableView.numberOfRows(inSection: indexPath.section) - Konstantoj.finaRegiono {
			alvenasFinon?()
		}
		
		return novaChelo
	}
}
