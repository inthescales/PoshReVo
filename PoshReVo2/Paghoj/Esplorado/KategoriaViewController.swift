import UIKit

import ReVoDatumbazo

/// Efektivigas navigaciajn menuojn rilate al esplorado de vorto-kategorioj
final class KategoriaViewController: UIViewController {
	struct Listero {
		let teksto: String
		let celPagho: () -> (UIViewController)
	}
	
	struct Sekcio {
		let titolo: String?
		let eroj: [Listero]
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
	
	private let sekcioj: [Sekcio]
	
	// MARK: Agordoj
	
	private let titolo: String?
	
	private let tabelStilo: UITableView.Style
	
	private let stilo: InterfacStilo
	
	//
	
	init(
		titolo: String?,
		tabelStilo: UITableView.Style = .plain,
		sekcioj: [Sekcio],
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.titolo = titolo
		self.tabelStilo = tabelStilo
		self.sekcioj = sekcioj
		self.stilo = stilo
		super.init(nibName: nil, bundle: nil)
	}
	
	convenience init(
		titolo: String?,
		tabelStilo: UITableView.Style = .plain,
		listeroj: [Listero],
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.init(
			titolo: titolo,
			tabelStilo: tabelStilo,
			sekcioj:[Sekcio(titolo: nil, eroj: listeroj)],
			stilo: stilo
		)
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
		
		let novaPagho = sekcioj[indexPath.section].eroj[indexPath.row].celPagho()
		navigaciilo.pushViewController(novaPagho, animated: true)
		
		tabelo.deselectRow(at: indexPath, animated: true)
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard section < sekcioj.count else {
			return nil
		}
		
		return sekcioj[section].titolo
	}
	
	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		if let titolo = view as? UITableViewHeaderFooterView {
			titolo.textLabel?.textColor = stilo.navigaciaTeksto
		}
	}
}

extension KategoriaViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		sekcioj.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		sekcioj[section].eroj.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard indexPath.section < sekcioj.count
				&& indexPath.row < sekcioj[indexPath.section].eroj.count else {
			fatalError("Listero ne ekzistas")
		}
		
		let listero = sekcioj[indexPath.section].eroj[indexPath.row]
		
		let novaChelo = UITableViewCell(style: .value1, reuseIdentifier: "Kategoria")
		novaChelo.textLabel?.text = listero.teksto
		
		return novaChelo
	}
	
	
}
