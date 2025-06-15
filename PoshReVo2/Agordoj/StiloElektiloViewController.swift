import UIKit

final class StiloElektiloViewController: UIViewController {
	private enum Konstantoj {
		static let chelidentigilo = "stiloElektilo"
	}

	lazy var tabelo = {
		let tabelo = UITableView(frame: .zero, style: .insetGrouped)
		tabelo.delegate = self
		tabelo.dataSource = self
		return tabelo
	}()
	
	// MARK: Agordoj
	
	private let kompleti: (InterfacStilo?) -> ()
		
	private let kunordigilo: Kunordigilo
	
	private let uzantDatumaro: UzantDatumaro
	
	private let stilo: InterfacStilo
	
	//
	
	init(
		kompleti: @escaping (InterfacStilo?) -> (),
		kunordigilo: Kunordigilo = .komuna,
		uzantDatumaro: UzantDatumaro = .komuna,
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.kompleti = kompleti
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
		navigationItem.leftBarButtonItem = NavigaciiloHelpiloj.iksoButono(
			por: self,
			ago: #selector(premisIkson),
			stilo: stilo
		)
		
		view.addEdgeMatchedSubview(tabelo)
	}
	
	// MARK: - Uzant-agoj
	
	@objc private func premisIkson() {
		kompleti(nil)
	}
	
	private func elektis(stilon stilo: InterfacStilo) {
		kompleti(stilo)
	}
}

extension StiloElektiloViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		elektis(stilon: InterfacStilo.chiuj[indexPath.row])
	}
}

extension StiloElektiloViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		InterfacStilo.chiuj.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .value1, reuseIdentifier: Konstantoj.chelidentigilo)
		cell.textLabel?.text = InterfacStilo.chiuj[indexPath.row].nomo
		return cell
	}
}
