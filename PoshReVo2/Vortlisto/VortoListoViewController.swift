import UIKit

import ReVoDatumbazo

/// Reprezentas iun ajn ekranon kiu prezentas liston da vortoj. Ekz. serĉrezultoj, fakvortoj, ktp.
final class VortoListoViewController: UIViewController {
	private enum Konstantoj {
		/// Kiam ĉi-kvanto da listeroj restas, sciigu ke la uzanto alvenas la finon de la listo
		static let finaRegiono = 5
	}
	
	lazy var tabelo: UITableView = {
		let tabelo = UITableView()
		tabelo.delegate = self
		tabelo.dataSource = self
		return tabelo
	}()
	
	// MARK: Stato
	
	private var listeroj: [Vortlistero] = []
	
	// MARK: Agordoj
	
	private let elektis: (Vortlistero) -> ()
	
	private let alvenasFinon: (() -> ())?
	
	//
	
	init(
		elektis: @escaping (Vortlistero) -> (),
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
	
	func montri(listerojn listeroj: [Vortlistero]) {
		self.listeroj = listeroj
		tabelo.reloadData()
	}
}

extension VortoListoViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		elektis(listeroj[indexPath.row])
	}
}

extension VortoListoViewController: UITableViewDataSource {
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
