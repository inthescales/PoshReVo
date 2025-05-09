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
		return tabelo
	}()
	
	// MARK: - Stato
	
	private var listeroj: [L] = []
	
	// MARK: - Agordoj
	
	private let elektis: (L) -> ()
	
	private let alvenasFinon: (() -> ())?
	
	// MARK: - Pravalorizado
	
	init(
		elektis: @escaping (L) -> (),
		alvenasFinon: (() -> ())? = nil
	) {
		self.elektis = elektis
		self.alvenasFinon = alvenasFinon
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		view.addEdgeMatchedSubview(tabelo)
	}
	
	func montri(listerojn listeroj: [L]) {
		self.listeroj = listeroj
		tabelo.reloadData()
	}
	
	// MARK: - UITableViewDelegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		elektis(listeroj[indexPath.row])
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
		
		if indexPath.row > tableView.numberOfRows(inSection: indexPath.section) - Konstantoj.finaRegiono {
			alvenasFinon?()
		}
		
		return novaChelo
	}
}
