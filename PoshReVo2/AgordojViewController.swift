import UIKit

final class AgordojViewController: UIViewController {
	private enum Konstantoj {
		static let chelidentigilo = "agordoj"
	}
	
	lazy var tabelo = {
		let tabelo = UITableView(frame: .zero, style: .insetGrouped)
		tabelo.delegate = self
		tabelo.dataSource = self
		return tabelo
	}()
	
	// MARK: Agordoj
		
	let kunordigilo: Kunordigilo
	
	let uzantDatumaro: UzantDatumaro
	
	var stilo: InterfacStilo
	
	//
	
	init(
		kunordigilo: Kunordigilo = .komuna,
		uzantDatumaro: UzantDatumaro = .komuna,
		stilo: InterfacStilo = .nuna
	) {
		self.kunordigilo = kunordigilo
		self.uzantDatumaro = uzantDatumaro
		self.stilo = stilo
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		navigationController?.navigationBar.tintColor = stilo.surkoloraTeksto
		view.addEdgeMatchedSubview(tabelo)
	}
	
	// MARK: - Uzant-agoj
	
	private func premisforigiHistorion() {
		prezentiKonfirmilon(teksto: Tekstoj.forigiHistorionDemand) { [weak self] in
			self?.uzantDatumaro.forigiHistorion()
		}
	}
	
	private func premisforigiKonservitajn() {
		prezentiKonfirmilon(teksto: Tekstoj.forigiHistorionDemand) { [weak self] in
			self?.uzantDatumaro.forigiKonservitajn()
		}
	}
	
	// MARK: - Helpiloj
	
	private func prezentiKonfirmilon(teksto: String, efiko: @escaping () -> Void) {
		let konfirmilo: UIAlertController = UIAlertController(
			title: teksto,
			message: nil,
			preferredStyle:.actionSheet
		)
		
		let agoJes = UIAlertAction(
			title: Tekstoj.jes,
			style: .destructive,
			handler: { _ in
			   efiko()
			}
		)
		
		let agoNe = UIAlertAction(title: Tekstoj.ne, style: .cancel, handler: nil)

		for ago in [agoJes, agoNe] {
			konfirmilo.addAction(ago)
		}
		
		// TODO: Elekti ĝustan ĉelon
		if let prezentilo = konfirmilo.popoverPresentationController,
			let chelo = tabelo.cellForRow(at: IndexPath(item: 0, section: 0)) {
			prezentilo.sourceView = chelo;
			prezentilo.sourceRect = chelo.bounds;
		}
		
		present(konfirmilo, animated: true, completion: nil)
	}
}

extension AgordojViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch (indexPath.section, indexPath.row) {
		case (0, 0):
			guard let navigaciilo = navigationController else {
				break
			}
			
			kunordigilo.prezentiLingvoRedaktilon(
				prezentilo: navigaciilo,
				kompleti: { [weak self] _ in
					self?.tabelo.reloadData()
				}
			)
		case (1, 0):
			premisforigiHistorion()
		case (1, 1):
			premisforigiKonservitajn()
		case (2, 0):
			// TODO: Aldoni stilo-elektilon
			break
		default:
			break
		}
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
		let cell: UITableViewCell
		switch (indexPath.section, indexPath.row) {
		case (0, 0):
			cell = UITableViewCell(style: .value1, reuseIdentifier: Konstantoj.chelidentigilo)
			cell.textLabel?.text = "Viaj Lingvoj"
			cell.detailTextLabel?.text = String(uzantDatumaro.lingvoj.count) + Tekstoj._lingvoj
		case (1, 0):
			cell = UITableViewCell(style: .default, reuseIdentifier: Konstantoj.chelidentigilo)
			cell.textLabel?.text = "Forigi Historion"
			cell.accessoryType = .none
		case (1, 1):
			cell = UITableViewCell(style: .default, reuseIdentifier: Konstantoj.chelidentigilo)
			cell.textLabel?.text = "Forigi Konservitajn"
			cell.accessoryType = .none
		case (2, 0):
			cell = UITableViewCell(style: .default, reuseIdentifier: Konstantoj.chelidentigilo)
			cell.textLabel?.text = "Ŝanĝi Stilon"
			cell.accessoryType = .disclosureIndicator
		default:
			cell = UITableViewCell(style: .default, reuseIdentifier: Konstantoj.chelidentigilo)
			break
		}
		
		return cell
	}
}
