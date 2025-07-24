import UIKit

import ReVoDatumbazo

/// Efektivigas navigaciajn menuojn rilate al esplorado de vorto-kategorioj
final class KategoriaViewController: UIViewController {
	struct Listero {
		let teksto: String
		let celPagho: () -> (UIViewController)
	}
	
	lazy var tabelo: UITableView = {
		let tabelo = UITableView(frame: .zero, style: tabelStilo)
		tabelo.delegate = self
		tabelo.dataSource = self
		
		if tabelStilo == .insetGrouped {
			tabelo.backgroundColor = stilo.navigaciaFono
		}
		
		return tabelo
	}()
	
	// MARK: Stato
	
	private let listeroj: [Listero]
	
	// MARK: Agordoj
	
	private let titolo: String?
	
	private let tabelStilo: UITableView.Style
	
	private let stilo: InterfacStilo
	
	//
	
	init(
		titolo: String?,
		tabelStilo: UITableView.Style = .plain,
		listeroj: [Listero],
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.titolo = titolo
		self.tabelStilo = tabelStilo
		self.listeroj = listeroj
		self.stilo = stilo
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		title = titolo
		
		view.addEdgeMatchedSubview(tabelo)
	}
}

extension KategoriaViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let navigaciilo = navigationController else { return }
		
		let novaPagho = listeroj[indexPath.row].celPagho()
		navigaciilo.pushViewController(novaPagho, animated: true)
		
		tabelo.deselectRow(at: indexPath, animated: true)
	}
}

extension KategoriaViewController: UITableViewDataSource {
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
		
		let novaChelo = UITableViewCell(style: .value1, reuseIdentifier: "Kategoria")
		novaChelo.textLabel?.text = listero.teksto
		
		return novaChelo
	}
	
	
}
