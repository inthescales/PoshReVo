import UIKit

import ReVoDatumbazo

final class LingvaroRedaktiloViewController: UIViewController {
	// MARK: Interfacaĵoj
	
	lazy var tabelo: UITableView = {
		let tabelo = UITableView(frame: .zero, style: .insetGrouped)
		tabelo.delegate = self
		tabelo.dataSource = self
		return tabelo
	}()
	
	// MARK: Stato
	
	let lingvaro: [Lingvo]
	
	// MARK: Agordoj
	
	var stilo: InterfacStilo
	
	init(lingvaro: [Lingvo], stilo: InterfacStilo = .nuna) {
		self.lingvaro = lingvaro
		self.stilo = stilo
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		let redaktButono = UIBarButtonItem.init(
			title: Tekstoj.redakti,
			style: .plain,
			target: self,
			action: #selector(Self.premisRedakti(sender:))
		)
		redaktButono.tintColor = stilo.navigaciilaTeksto
		navigationItem.rightBarButtonItem = redaktButono
		
		view.addEdgeMatchedSubview(tabelo)
	}
		
	// MARK: Uzanto-agoj
		
	@objc private func premisRedakti(sender: Any) {
		
	}
}

extension LingvaroRedaktiloViewController: UITableViewDelegate {
//	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//		if indexPath.section == 1 {
//			return indexPath
//		}
//		
//		return nil
//	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath == IndexPath(row: 0, section: 1) {
			let elektiloVC = LingvoElektiloViewController(
				kromEsperanto: false,
				elektisLingvon: { lingvo in
				}
			)
			let navigaciilo = UINavigationController(rootViewController: elektiloVC)
			navigaciilo.navigationBar.isTranslucent = false
			navigaciilo.navigationBar.backgroundColor = stilo.koloraFono // TODO: movi
			navigaciilo.modalPresentationStyle = .fullScreen
			
			present(navigaciilo, animated: true)
			
			tabelo.deselectRow(at: indexPath, animated: true)
		}
	}
}

extension LingvaroRedaktiloViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return Tekstoj.lingvoj
		default:
			return nil
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return lingvaro.count
		case 1:
			return 1
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let chelo = UITableViewCell(style: .default, reuseIdentifier: "lingvoRedaktiloChelo")
		
		if indexPath.section == 0 {
			let lingvo = lingvaro[indexPath.row]
			chelo.textLabel?.text = lingvo.nomo
			chelo.accessoryType = .none
			chelo.selectionStyle = .none
		} else if indexPath.section == 1 {
			chelo.textLabel?.text = Tekstoj.aldoniLingvon
			chelo.accessoryType = .disclosureIndicator
			chelo.selectionStyle = .default
		}
		
		return chelo
	}
}
