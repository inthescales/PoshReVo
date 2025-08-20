import UIKit

/// Ekrano montranta liston da mallongigoj
final class MallongigoListoViewController: UIViewController {
	private enum Konstantoj {
		/// Flankaj marĝeno ĉirkaŭ tekstoj
		static let margheno: CGFloat = 8.0
		
		static let chelIdentigilo = "mallongigoIdentigilo"
	}
	
	/// Mallongigo kaj ĝia signifo, kiel ĝi aperu en listo
	typealias Ero = (mallongigo: String, signifo: String)
	
	// MARK: - Interfaceroj
	
	/// Serĉilo por filtri mallongigojn
	private lazy var serchilo: SerchiloView = {
		let serchilo = SerchiloView(
			lokokupaTeksto: Tekstoj.serchiMallongigojn,
			iksumi: true,
			tekstoShanghighis: filtri(teksto:)
		)
		return serchilo
	}()
	
	/// Tabelo montranta mallongigojn
	private lazy var tabelo: UITableView = {
		let tabelo = UITableView()
		tabelo.delegate = self
		tabelo.dataSource = self
		tabelo.allowsSelection = false
		tabelo.backgroundColor = stilo.dokumentaFono
		
		tabelo.register(MallongigoListoChelo.self, forCellReuseIdentifier: Konstantoj.chelIdentigilo)
		
		return tabelo
	}()
	
	// MARK: - Stato
	
	/// Listeroj kiuj estu videblaj
	private var videblajEroj: [Ero] {
		didSet {
			tabelo.reloadData()
		}
	}
	
	// MARK: - Agordoj
	
	/// Titolo kiu aperos ekransupre
	private let titolo: String?
	
	/// Mallongigoj kiujn la listo montru
	private let eroj: [Ero]
	
	private let stilo: InterfacStilo
	
	// MARK: - Valorizado
	
	init(titolo: String?, eroj: [Ero], stilo: InterfacStilo = UzantDatumaro.komuna.stilo) {
		self.titolo = titolo
		self.eroj = eroj
		self.videblajEroj = eroj
		self.stilo = stilo
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = titolo
		
		view.backgroundColor = stilo.navigaciaFono
		
		view.addSubview(serchilo)
		serchilo.snp.makeConstraints { make in
			make.top.left.right.equalToSuperview()
		}
		
		view.addSubview(tabelo)
		tabelo.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview()
			make.top.equalTo(serchilo.snp.bottom)
		}
	}
	
	/// Filtri la videblajn mallongigojn laŭ tiu serĉteksto
	private func filtri(teksto: String) {
		guard !teksto.isEmpty else {
			videblajEroj = eroj
			return
		}
		
		let minusklaTeksto = teksto.lowercased()
		videblajEroj = eroj.filter { ero in
			ero.mallongigo.lowercased().contains(minusklaTeksto)
			|| ero.signifo.lowercased().contains(minusklaTeksto)
		}
	}
}

extension MallongigoListoViewController: UITableViewDelegate {}

extension MallongigoListoViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		videblajEroj.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let ero = videblajEroj[indexPath.row]
		guard let chelo = tableView.dequeueReusableCell(withIdentifier: Konstantoj.chelIdentigilo, for: indexPath) as? MallongigoListoChelo else {
			print("ERARO: Ricevis malĝustan ĉelspecon")
			return UITableViewCell()
		}
		
		chelo.agordi(mallongigo: ero.mallongigo, signifo: ero.signifo, stilo: stilo)
		return chelo
	}
}
