import UIKit

/// Ekrano por agordi agordojn
final class AgordojViewController: UIViewController {
	private enum Konstantoj {
		static let chelidentigiloBaza = "agordojBaza"
		static let chelidentigiloEtikeda = "agordojEtikedhava"
	}
	
	/// Tabelo de agord-agoj
	lazy var tabelo = {
		let tabelo = UITableView(frame: .zero, style: .insetGrouped)
		tabelo.delegate = self
		tabelo.dataSource = self
		tabelo.backgroundColor = stilo.menuoFono
		return tabelo
	}()
	
	// MARK: - Agordoj
	
	private let kunordigilo: Kunordigilo
	
	private let datumRegilo: UzantDatumoRegilo
	
	private var stilo: InterfacStilo
	
	// MARK: - Valorizado
	
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
	
	private func premisNuligiHistorion() {
		// TODO: valorizi prezentilo.sourceView kaj prezentilo.sourceRect, por iPad?
		// TODO: (por ke ŝpruca konfirmilo aperu ĝustloke?)
		
		AgoHelpiloj.prezentiKonfirmilon(
			teksto: Tekstoj.nuligiHistorionDemand,
			prezentilo: self,
		) { [weak self] in
			self?.datumRegilo.nuligiHistorion()
		}
	}
	
	private func premisNuligiKonservitajn() {
		// TODO: valorizi prezentilo.sourceView kaj prezentilo.sourceRect, por iPad?
		
		AgoHelpiloj.prezentiKonfirmilon(
			teksto: Tekstoj.nuligiHistorionDemand,
			prezentilo: self
		) { [weak self] in
			self?.datumRegilo.nuligiKonservitajn()
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
			premisNuligiHistorion()
		case (1, 1):
			premisNuligiKonservitajn()
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
			chelo.textLabel?.text = Tekstoj.viajLingvoj
			chelo.detailTextLabel?.text = String(datumRegilo.datumaro.lingvoj.count) + Tekstoj._lingvoj
		case (1, 0):
			chelo = UITableViewCell(style: .default, reuseIdentifier: Konstantoj.chelidentigiloBaza)
			chelo.textLabel?.text = Tekstoj.nuligiHistorion
			chelo.accessoryType = .none
		case (1, 1):
			chelo = UITableViewCell(style: .default, reuseIdentifier: Konstantoj.chelidentigiloBaza)
			chelo.textLabel?.text = Tekstoj.nuligiKonservitajn
			chelo.accessoryType = .none
		case (2, 0):
			chelo = UITableViewCell(style: .value1, reuseIdentifier: Konstantoj.chelidentigiloEtikeda)
			chelo.textLabel?.text = Tekstoj.shanghiStilon
			chelo.detailTextLabel?.text = stilo.nomo
		default:
			chelo = UITableViewCell(style: .default, reuseIdentifier: Konstantoj.chelidentigiloBaza)
			break
		}
		
		chelo.meti(stilon: stilo, grupa: true)
		
		return chelo
	}
}
