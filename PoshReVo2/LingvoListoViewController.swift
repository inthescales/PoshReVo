import UIKit

import ReVoDatumbazo

/// Reprezentas iun ajn ekranon kiu prezentas liston da vortoj. Ekz. serĉrezultoj, fakvortoj, ktp.
final class LingvoListoViewController: UIViewController {
	private lazy var tabelo: UITableView = {
		let tabelo = UITableView()
		tabelo.delegate = self
		tabelo.dataSource = self
		return tabelo
	}()
	
	// MARK: Stato
	
	private var lingvoj: [Lingvo]
	
	// MARK: Agordoj
	
	private let elektisLingvon: (Lingvo) -> ()
	
	//
	
	init(lingvoj: [Lingvo], elektisLingvon: @escaping (Lingvo) -> ()) {
		self.lingvoj = lingvoj
		self.elektisLingvon = elektisLingvon
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		view.addEdgeMatchedSubview(tabelo)
	}
	
	// MARK: Agordado
	
	func montri(lingvojn lingvoj: [Lingvo]) {
		self.lingvoj = lingvoj
		tabelo.reloadData()
	}
}

extension LingvoListoViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let lingvo = lingvoj[indexPath.row]
		elektisLingvon(lingvo)
	}
}

extension LingvoListoViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		lingvoj.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard indexPath.row < lingvoj.count else {
			fatalError("Lingvo ne ekzistas")
		}
		
		let lingvo = lingvoj[indexPath.row]
		
		let novaChelo = UITableViewCell(style: .value1, reuseIdentifier: "vortoListo")
		novaChelo.textLabel?.text = lingvo.nomo
		return novaChelo
	}
}
