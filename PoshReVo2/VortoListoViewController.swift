import UIKit

import ReVoDatumbazo

/// Reprezentas iun ajn ekranon kiu prezentas liston da vortoj. Ekz. serĉrezultoj, fakvortoj, ktp.
final class VortoListoViewController: UIViewController {
	struct Listero {
		let teksto: String
		let subteksto: String?
		let destinoj: [Destino]
	}
	
	lazy var tabelo: UITableView = {
		let tabelo = UITableView()
		tabelo.delegate = self
		tabelo.dataSource = self
		return tabelo
	}()
	
	// MARK: Stato
	
	private var listeroj: [Listero] = []
	
	// MARK: Agordoj
	
	private let elektis: (Listero) -> ()
	
	//
	
	init(elektis: @escaping (Listero) -> ()) {
		self.elektis = elektis
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		view.addEdgeMatchedSubview(tabelo)
	}
	
	func montri(listerojn listeroj: [Listero]) {
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
		return novaChelo
	}
	
	
}
