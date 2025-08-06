import UIKit

final class AgordojViewController: UIViewController {
	private enum Konstantoj {
		static let chelidentigiloBaza = "agordojBaza"
		static let chelidentigiloEtikeda = "agordojEtikedhava"
	}
	
	lazy var tabelo = {
		let tabelo = UITableView(frame: .zero, style: .insetGrouped)
		tabelo.delegate = self
		tabelo.dataSource = self
		tabelo.backgroundColor = stilo.menuoFono
		return tabelo
	}()
	
	// MARK: Agordoj
	
	private let kunordigilo: Kunordigilo
	
	private let datumRegilo: UzantDatumoRegilo
	
	private var stilo: InterfacStilo
	
	//
	
	init(
		kunordigilo: Kunordigilo = .komuna,
		datumRegilo: UzantDatumoRegilo = .komuna,
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.kunordigilo = kunordigilo
		self.datumRegilo = datumRegilo
		self.stilo = stilo
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		title = Tekstoj.agordoj
		
		view.addEdgeMatchedSubview(tabelo)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(stiloShanghighis),
			name: Avizoj.stiloShanghighis,
			object: nil
		)
	}
	
	// MARK: - Uzant-agoj
	
	private func premisForigiHistorion() {
		// TODO: Elekti ĝustan ĉelon
		// if let prezentilo = konfirmilo.popoverPresentationController,
		// 	   let chelo = tabelo.cellForRow(at: IndexPath(item: 0, section: 0)) {
		// 	   prezentilo.sourceView = chelo;
		// 	   prezentilo.sourceRect = chelo.bounds;
		// }
		
		AgoHelpiloj.prezentiKonfirmilon(
			teksto: Tekstoj.forigiHistorionDemand,
			prezentilo: self,
		) { [weak self] in
			self?.datumRegilo.forigiHistorion()
		}
	}
	
	private func premisforigiKonservitajn() {
		// TODO: Elekti ĝustan ĉelon, kiel supre
		
		AgoHelpiloj.prezentiKonfirmilon(
			teksto: Tekstoj.forigiHistorionDemand,
			prezentilo: self
		) { [weak self] in
			self?.datumRegilo.forigiKonservitajn()
		}
	}
	
	// MARK: - Avizreagoj
	
	@objc private func stiloShanghighis() {
		let novaStilo = UzantDatumaro.komuna.stilo
		stilo = novaStilo
		
		tabelo.backgroundColor = stilo.menuoFono
		tabelo.reloadData()
	}
}

extension AgordojViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch (indexPath.section, indexPath.row) {
		case (0, 0):
			guard let navigaciilo = navigationController else {
				break
			}
			
			kunordigilo.pushiLingvoRedaktilon(
				prezentilo: navigaciilo,
				elektis: { [weak self] _ in
					self?.tabelo.reloadData()
				}
			)
		case (1, 0):
			premisForigiHistorion()
		case (1, 1):
			premisforigiKonservitajn()
		case (2, 0):
			guard let navigaciilo = navigationController else {
				break
			}
			
			kunordigilo.prezentiStiloelektilon(
				prezentilo: navigaciilo,
				elektis: { [weak self] novaStilo in
					self?.stilo = novaStilo
					self?.tabelo.reloadData()
				}
			)
		default:
			break
		}
		
		tabelo.deselectRow(at: indexPath, animated: true)
	}
}

extension AgordojViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		case 1:
			return 2
		case 2:
			return 1
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let chelo: UITableViewCell
			
		switch (indexPath.section, indexPath.row) {
		case (0, 0):
			chelo = UITableViewCell(style: .value1, reuseIdentifier: Konstantoj.chelidentigiloEtikeda)
			chelo.textLabel?.text = "Viaj Lingvoj"
			chelo.detailTextLabel?.text = String(datumRegilo.datumaro.lingvoj.count) + Tekstoj._lingvoj
		case (1, 0):
			chelo = UITableViewCell(style: .default, reuseIdentifier: Konstantoj.chelidentigiloBaza)
			chelo.textLabel?.text = "Forigi Historion"
			chelo.accessoryType = .none
		case (1, 1):
			chelo = UITableViewCell(style: .default, reuseIdentifier: Konstantoj.chelidentigiloBaza)
			chelo.textLabel?.text = "Forigi Konservitajn"
			chelo.accessoryType = .none
		case (2, 0):
			chelo = UITableViewCell(style: .value1, reuseIdentifier: Konstantoj.chelidentigiloEtikeda)
			chelo.textLabel?.text = "Ŝanĝi Stilon"
			chelo.detailTextLabel?.text = stilo.nomo
		default:
			chelo = UITableViewCell(style: .default, reuseIdentifier: Konstantoj.chelidentigiloBaza)
			break
		}
		
		chelo.meti(stilon: stilo)
		
		return chelo
	}
}
