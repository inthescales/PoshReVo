import UIKit

/// Falsa vortlisto montrata en vortlista nulstato
final class FalsaVortListoViewController: UIViewController {
	// MARK: - Interfaceroj
	
	private lazy var tabelo: UITableView = {
		let tabelo = UITableView(frame: .zero, style: .plain)
		tabelo.delegate = self
		tabelo.dataSource = self
		tabelo.isScrollEnabled = false
		tabelo.allowsSelection = false
		return tabelo
	}()
	
	// MARK: - Agordoj
	
	private var stilo: InterfacStilo
	
	// MARK: - Valorizado
	
	init(stilo: InterfacStilo = UzantDatumaro.komuna.stilo) {
		self.stilo = stilo
		super.init(nibName: nil, bundle: nil)
		
		view.addEdgeMatchedSubview(tabelo)
		meti(stilon: stilo)
		
		tabelo.reloadData()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	func meti(stilon stilo: InterfacStilo) {
		self.stilo = stilo
		view.backgroundColor = stilo.dokumentaFono
		tabelo.backgroundColor = stilo.dokumentaFono
	}
}

extension FalsaVortListoViewController: UITableViewDelegate {}

extension FalsaVortListoViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 30
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let chelo = UITableViewCell(style: .default, reuseIdentifier: "falsaVortListaChelo")
		chelo.backgroundColor = .clear
		return chelo
	}
}
