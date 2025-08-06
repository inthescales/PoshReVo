import UIKit

import ReVoDatumbazo

/// Agordopaĝo por elekti lingvojn aperontajn en tradukoj kaj sub la serĉilo
final class LingvaroRedaktiloViewController: UIViewController {
	private enum Konstantoj {
		/// La minimuma kvanto da lingvoj. Kiam ĉi-limo estas atingita, ne eblas forigi pliajn lingvojn
		static let lingvoMinimumo = 1
	}
	
	/// Kiel ĉi-VC estos prezentata. Certigas ke, se 'reen'-butono ne estas, estu foriga fermo kaj butono
	enum Prezentmaniero {
		case prezentita(forigi: () -> Void)
		case pushita
		
		/// Forigofermo, se estas
		func forigi() -> (() -> Void)? {
			switch self {
			case .prezentita(let forigi):
				return forigi
			case .pushita:
				return nil
			}
		}
	}
	
	// MARK: Interfacaĵoj
	
	/// Butono por redakti (forigi kaj reordigi) lingvojn
	lazy var redaktButono = {
		let butono = UIBarButtonItem.init(
			title: Tekstoj.redakti,
			style: .plain,
			target: self,
			action: #selector(Self.premisRedakti)
		)
		butono.tintColor = stilo.navigaciaButono
		return butono
	}()
	
	/// Tabelo kiu montros lingvojn kaj agojn
	lazy var tabelo: UITableView = {
		let tabelo = UITableView(frame: .zero, style: .insetGrouped)
		tabelo.delegate = self
		tabelo.dataSource = self
		tabelo.backgroundColor = stilo.menuoFono
		
		return tabelo
	}()
	
	// MARK: Stato
	
	/// La lingvaro kiu aperu en ĉi-paĝo
	var lingvaro: [Lingvo] {
		didSet {
			lingvaroShanghighis()
		}
	}
	
	// MARK: Agordoj
	
	/// Prezentmaniero por la VC
	let prezentManiero: Prezentmaniero
	
	/// Konfirmi elekton de nova lingvaro
	let elektis: ([Lingvo]) -> ()
	
	private let stilo: InterfacStilo
	
	init(
		lingvaro: [Lingvo],
		prezentManiero: Prezentmaniero,
		elektis: @escaping ([Lingvo]) -> (),
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.lingvaro = lingvaro
		self.prezentManiero = prezentManiero
		self.elektis = elektis
		self.stilo = stilo
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		title = Tekstoj.viajLingvoj
		navigationItem.rightBarButtonItem = redaktButono
		
		// Se aparta forigo-fermo necesas, ni uzu forigi-butonon
		if case .prezentita = prezentManiero {
			navigationItem.leftBarButtonItem = NavigaciiloHelpiloj.rezigniButono(
				por: self,
				ago: #selector(premisIkson),
				stilo: stilo
			)
		}
		
		view.addEdgeMatchedSubview(tabelo)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		elektis(lingvaro)
	}
	
	// MARK: - Navigaciaj agoj
	
	@objc private func premisIkson() {
		prezentManiero.forigi()?()
	}
	
	// MARK: Redaktado
	
	@objc private func premisRedakti() {
		if !tabelo.isEditing {
			komenciRedaktadon()
		} else {
			finiRedaktadon()
		}
	}
	
	private func komenciRedaktadon() {
		tabelo.setEditing(true, animated: true)
		redaktButono.title = Tekstoj.fini
		redaktButono.style = .done
	}
	
	private func finiRedaktadon() {
		tabelo.setEditing(false, animated: true)
		redaktButono.title = Tekstoj.redakti
		redaktButono.style = .plain
	}
	
	// MARK: Lingvaro-shanĝado
		
	private func forigis(je indekso: Int) {
		lingvaro.remove(at: indekso)
		if lingvaro.count <= Konstantoj.lingvoMinimumo {
			// Ĉi uzo de `DispatchQueue` evitas eraron en UITableView.setEditing(...)
			DispatchQueue.main.async { [weak self] in
				self?.finiRedaktadon()
			}
		}
	}
	
	private func aldonis(lingvon lingvo: Lingvo) {
		lingvaro.append(lingvo)
	}
	
	private func lingvaroShanghighis() {
		redaktButono.isEnabled = lingvaro.count > Konstantoj.lingvoMinimumo
		tabelo.reloadData()
	}
}

// MARK: - Tabelprezentado

extension LingvaroRedaktiloViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath == IndexPath(row: 0, section: 1) {
			let elektiloVC = LingvoElektiloViewController(
				kromEsperanto: false,
				jamElektitaj: lingvaro,
				elektisLingvon: { [weak self] lingvo in
					self?.aldonis(lingvon: lingvo)
				}
			)
			let navigaciilo = ChefaNavigationController(rootViewController: elektiloVC)
			navigaciilo.modalPresentationStyle = .fullScreen
			
			present(navigaciilo, animated: true)
			
			tabelo.deselectRow(at: indexPath, animated: true)
		}
	}
}

extension LingvaroRedaktiloViewController: UITableViewDataSource {
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
		
		chelo.meti(stilon: stilo)
		
		return chelo
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cell.showsReorderControl = self.tableView(tabelo, canMoveRowAt: indexPath) && tableView.isEditing
	}
	
	// MARK: - Tabeloredaktado
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return indexPath.section == 0
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			forigis(je: indexPath.row)
		}
	}
	
	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return indexPath.section == 0
	}
	
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		let lingvo = lingvaro[sourceIndexPath.row]
		lingvaro.remove(at: sourceIndexPath.row)
		lingvaro.insert(lingvo, at: destinationIndexPath.row)
	}
}
