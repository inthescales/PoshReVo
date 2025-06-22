import UIKit
import SnapKit

final class ShovMenuoViewController: UIViewController {
	private enum Konstantoj {
		static let animaciaDauro: TimeInterval = 0.2
		
		static let ombroMalhelo: CGFloat = 0.5
	}
	
	struct Menuero {
		let teksto: String
		let ago: () -> ()
	}
	
	// MARK: - Interfaceroj
	
	private lazy var ombroView: UIView = {
		let view = UIView()
		view.backgroundColor = .black
		view.alpha = 0
		view.addGestureRecognizer(
			UITapGestureRecognizer(target: self, action: #selector(premisOmbron))
		)
		return view
	}()
	
	private lazy var menuejo: UIView = {
		let view = UIView()
		view.backgroundColor = stilo.dokumentaFono
		return view
	}()
	
	private lazy var rulumejo: UIScrollView = {
		let ejo = UIScrollView()
		ejo.isScrollEnabled = true
		ejo.showsHorizontalScrollIndicator = false
		ejo.contentInset = UIEdgeInsets(top: navigaciilaAlto, left: 0, bottom: 0, right: 0)
		return ejo
	}()
	
	private lazy var elektoStaplo: UIStackView = {
		let staplo = UIStackView()
		staplo.backgroundColor = stilo.dokumentaFono
		staplo.axis = .vertical
		for (indekso, ero) in self.eroj.enumerated() {
			let butono = fariButonon(el: ero, indekso: indekso)
			staplo.addArrangedSubview(butono)
		}
		return staplo
	}()
	
	private var dekstraLigo: Constraint?
	
	// MARK: - Agordoj
	
	let eroj: [Menuero]
	
	let navigaciilaAlto: CGFloat
	
	let foriri: () -> Void
	
	private let stilo: InterfacStilo
	
	init(
		eroj: [Menuero],
		navigaciilaAlto: CGFloat,
		forigi foriri: @escaping () -> Void,
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.eroj = eroj
		self.navigaciilaAlto = navigaciilaAlto
		self.foriri = foriri
		self.stilo = stilo
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addEdgeMatchedSubview(ombroView)
		
		view.addSubview(menuejo)
		menuejo.snp.makeConstraints { make in
			make.height.top.bottom.equalToSuperview()
			dekstraLigo = make.left.equalTo(view.snp.right).constraint
		}
		
		menuejo.addEdgeMatchedSubview(rulumejo)
		rulumejo.addEdgeMatchedSubview(elektoStaplo)
		rulumejo.snp.makeConstraints { make in
			make.width.equalTo(elektoStaplo.snp.width)
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		UIView.animate(withDuration: Konstantoj.animaciaDauro) { [weak self] in
			self?.dekstraLigo?.update(offset: -self!.menuejo.bounds.width)
			self?.view.layoutIfNeeded()
			self?.ombroView.alpha = Konstantoj.ombroMalhelo
		}
		
		rulumejo.contentSize = elektoStaplo.bounds.size
	}
	
	// MARK: - InterfacHelpiloj
	
	private func fariButonon(el ero: Menuero, indekso: Int) -> UIButton {
		let butono = UIButton()
		butono.setTitle(ero.teksto, for: .normal)
		butono.setTitleColor(stilo.dokumentLigilo, for: .normal)
		butono.setTitleColor(stilo.navigaciaTeksto, for: .highlighted)
		butono.tag = indekso
		butono.addTarget(self, action: #selector(ekpremis(butonon:)), for: .touchDown)
		butono.addTarget(self, action: #selector(finpremis(butonon:)), for: .touchUpInside)
		butono.addTarget(self, action: #selector(ekstereFinpremis(butonon:)), for: .touchUpOutside)
		return butono
	}
	
	// MARK: - Agoj
	
	@objc private func ekpremis(butonon butono: UIButton) {
		butono.backgroundColor = stilo.navigaciaFono
	}
	
	@objc private func finpremis(butonon butono: UIButton) {
		butono.backgroundColor = stilo.dokumentaFono
		
		if butono.tag < eroj.count {
			eroj[butono.tag].ago()
		}
		
		malaperi()
	}
	
	@objc private func ekstereFinpremis(butonon butono: UIButton) {
		butono.backgroundColor = stilo.dokumentaFono
	}
	
	@objc private func premisOmbron() {
		malaperi()
	}
	
	private func malaperi() {
		UIView.animate(
			withDuration: Konstantoj.animaciaDauro,
			animations:{ [weak self] in
				self?.dekstraLigo?.update(offset: 0)
				self?.view.layoutIfNeeded()
				self?.ombroView.alpha = 0
			},
			completion: { [weak self] _ in
				self?.foriri()
			}
		)
	}
}
