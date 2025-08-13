import UIKit

import ReVoDatumbazo

/// Reprezentas iun ajn ekranon kiu prezentas liston da lingvoj. Uzata en lingvoelektado
final class LingvoListoViewController: UIViewController {
	/// Tabelo montrota lingvojn
	private lazy var tabelo: UITableView = {
		let tabelo = UITableView()
		tabelo.delegate = self
		tabelo.dataSource = self
		tabelo.backgroundColor = stilo.dokumentaFono
		
		return tabelo
	}()
	
	// MARK: - Stato

	/// La lingvoj kiuj estu montrataj
	private var lingvoj: [Lingvo]
	
	/// Lingvoj kiuj estas jam elektita, kaj kiuj do estu markitaj
	private let jamElektitaj: [Lingvo]
	
	// MARK: Agordoj
	
	/// Fermo vokata kiam la uzanto elektas lingvon
	private let elektisLingvon: (Lingvo) -> ()
	
	private let stilo: InterfacStilo
	
	// MARK: - Valorizado
	
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
	
	/// Montras tiujn lingvojn en la tabelo
	func montri(lingvojn lingvoj: [Lingvo]) {
		self.lingvoj = lingvoj
		tabelo.reloadData()
	}
}

extension LingvoListoViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let lingvo = lingvoj[indexPath.row]
		elektisLingvon(lingvo)
		
		tableView.deselectRow(at: indexPath, animated: true)
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
		novaChelo.accessoryType = jamElektitaj.contains(where: { $0.kodo == lingvo.kodo }) ? .checkmark : .none // TODO: Ŝanĝi kiam Lingvoj estos denove strukt-ojn
		novaChelo.tintColor = stilo.dokumentaTeksto.withAlphaComponent(0.5)
		novaChelo.meti(stilon: stilo)
		
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
