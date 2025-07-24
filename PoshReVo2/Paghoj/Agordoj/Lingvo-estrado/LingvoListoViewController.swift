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
	
	private let jamElektitaj: [Lingvo]
	
	// MARK: Agordoj
	
	private let elektisLingvon: (Lingvo) -> ()
	
	private let stilo: InterfacStilo
	
	//
	
	init(
		lingvoj: [Lingvo],
		jamElektitaj: [Lingvo],
		elektisLingvon: @escaping (Lingvo) -> (),
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.lingvoj = lingvoj
		self.jamElektitaj = jamElektitaj
		self.elektisLingvon = elektisLingvon
		self.stilo = stilo
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
		novaChelo.accessoryType = jamElektitaj.contains(lingvo) ? .checkmark : .none
		novaChelo.tintColor = stilo.navigaciaFono
		
		return novaChelo
	}
	
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		// Lingvoj jam elektitaj ne estu elekteblaj
		if jamElektitaj.contains(lingvoj[indexPath.row]) {
			return nil
		}
		
		return indexPath
	}
}
