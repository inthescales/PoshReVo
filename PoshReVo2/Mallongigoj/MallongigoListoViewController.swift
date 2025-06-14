import UIKit

/// Pagho montranta liston da mallongigoj
final class MallongigoListoViewController: UIViewController {
	private enum Konstantoj {
		static let identigilo = "mallongigoIdentigilo"
	}
	
	typealias Ero = (mallongigo: String, signifo: String)
	
	// MARK: - Interfaceroj
	
	private lazy var serchilo: SerchiloView = {
		let serchilo = SerchiloView(
			lokokupaTeksto: Tekstoj.serchiMallongigojn,
			iksumi: true,
			tekstoShanghighis: filtri(teksto:)
		)
		return serchilo
	}()
	
	private lazy var tabelo: UITableView = {
		let tabelo = UITableView()
		tabelo.delegate = self
		tabelo.dataSource = self
		tabelo.register(MallongigoChelo.self, forCellReuseIdentifier: Konstantoj.identigilo)
		return tabelo
	}()
	
	// MARK: - Stato
	
	private var videblajEroj: [Ero]
	
	// MARK: - Agordoj
	
	private let eroj: [Ero]
	
	private let stilo: InterfacStilo
	
	init(eroj: [Ero], stilo: InterfacStilo = UzantDatumaro.komuna.stilo) {
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
		
		view.backgroundColor = stilo.koloraFono
		
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
	
	private func filtri(teksto: String) {
		guard !teksto.isEmpty else {
			videblajEroj = eroj
			tabelo.reloadData()
			return
		}
		
		videblajEroj = eroj.filter { ero in
			ero.mallongigo.contains(teksto) || ero.signifo.contains(teksto)
		}
		
		tabelo.reloadData()
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
		guard let chelo = tableView.dequeueReusableCell(withIdentifier: Konstantoj.identigilo, for: indexPath) as? MallongigoChelo else {
			fatalError("Ricevis malĝustan ĉelspecon")
		}
		
		chelo.agordi(mallongigo: ero.mallongigo, signifo: ero.signifo, stilo: stilo)
		return chelo
	}
}

final class MallongigoChelo: UITableViewCell {
	private lazy var mallongigoEtikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.font = .systemFont(ofSize: 20, weight: .bold)
		return etikedo
	}()

	private lazy var signifoEtikedo: UILabel = {
		let etikedo = UILabel()
		return etikedo
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		addSubview(mallongigoEtikedo)
		mallongigoEtikedo.snp.makeConstraints { make in
			make.left.top.bottom.equalToSuperview()
		}
		
		addSubview(signifoEtikedo)
		signifoEtikedo.snp.makeConstraints { make in
			make.top.right.bottom.equalToSuperview()
			make.left.equalTo(mallongigoEtikedo.snp.right)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	func agordi(mallongigo: String, signifo: String, stilo: InterfacStilo) {
		mallongigoEtikedo.text = mallongigo
		mallongigoEtikedo.textColor = stilo.teksto
		
		signifoEtikedo.text = signifo
		signifoEtikedo.textColor = stilo.teksto
	}
}
