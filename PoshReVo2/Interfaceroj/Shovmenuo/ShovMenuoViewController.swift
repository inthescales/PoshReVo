import UIKit
import SnapKit

final class ShovMenuoViewController: UIViewController {
	struct Agordoj {
		let titolo: String?
		let navigaciaKoloro: UIColor
		let navigaciaTekstKoloro: UIColor
		let navigaciaDividiloKoloro: UIColor
		let menuaKoloro: UIColor
		let malplenaKoloro: UIColor
		let tekstKoloro: UIColor
		let dividiloKoloro: UIColor
	}
	
	private enum Konstantoj {
		/// Minimuma larĝo de la menuejo
		static let minimumaLarghoPorcio: CGFloat = 0.5
		
		/// Maksimuma larĝo de la menuejo
		static let maksimumaLarghoPorcio: CGFloat = 0.66
		
		/// Kiom longe animacioj daŭru
		static let animaciaDauro: TimeInterval = 0.2
		
		/// Kiel forte la ombro sur la patra 'view' estu
		static let ombroMalhelo: CGFloat = 0.5
		
		/// Marĝeno flanke de menueraj titoloj
		static let flankaMargheno: CGFloat = 32.0
		
		/// Marĝeno supre kaj sube de menueraj titoloj
		static let vertikalaMargheno: CGFloat = 12.0
	}
	
	struct Menuero {
		let bildo: UIImage?
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
	
	private lazy var navigaciejo: UIView = {
		let ejo = UIView()
		ejo.backgroundColor = agordoj.navigaciaKoloro
		
		let dividilo = UIView()
		dividilo.backgroundColor = agordoj.navigaciaDividiloKoloro
		ejo.addSubview(dividilo)
		dividilo.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview()
			make.height.equalTo(1)
		}
		
		return ejo
	}()
	
	private lazy var titolEtikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.text = agordoj.titolo
		etikedo.textColor = agordoj.navigaciaTekstKoloro
		etikedo.textAlignment = .center
		etikedo.font = .boldSystemFont(ofSize: 18) // TODO: Tiparo
		return etikedo
	}()
	
	private lazy var menuejo: UIView = {
		let view = UIView()
		view.backgroundColor = agordoj.menuaKoloro

		let rekonilo = UIPanGestureRecognizer(target: self, action: #selector(shovis))
		let rekonilego = UISwipeGestureRecognizer(target: self, action: #selector(shovegis))
		[rekonilo, rekonilego].forEach { view.addGestureRecognizer($0) }
		
		return view
	}()
	
	private lazy var rulumejo: UIScrollView = {
		let ejo = UIScrollView()
		ejo.isScrollEnabled = true
		ejo.showsHorizontalScrollIndicator = false
		ejo.backgroundColor = agordoj.menuaKoloro
		return ejo
	}()
	
	private lazy var elektoStaplo: UIStackView = {
		let staplo = UIStackView()
		staplo.backgroundColor = agordoj.menuaKoloro
		staplo.axis = .vertical
		staplo.alignment = .fill
		for ero in self.eroj {
			staplo.addArrangedSubview(fariEroVidon(el: ero))
		}
		return staplo
	}()
	
	private var dekstraLigo: Constraint?
	
	// MARK: - Kalkulita Stato
	
	lazy var havasBildojn = eroj.contains(where: { $0.bildo != nil })
	
	// MARK: - Agordoj
	
	let eroj: [Menuero]
	
	let agordoj: Agordoj
	
	let navigaciilaAlto: CGFloat
	
	let foriri: () -> Void
	
	// MARK: -
	
	init(
		eroj: [Menuero],
		agordoj: Agordoj,
		navigaciilaAlto: CGFloat,
		forigi foriri: @escaping () -> Void
	) {
		self.eroj = eroj
		self.agordoj = agordoj
		self.navigaciilaAlto = navigaciilaAlto
		self.foriri = foriri
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
			make.width.lessThanOrEqualToSuperview().multipliedBy(Konstantoj.maksimumaLarghoPorcio)
			make.width.greaterThanOrEqualToSuperview().multipliedBy(Konstantoj.minimumaLarghoPorcio)
			dekstraLigo = make.left.equalTo(view.snp.right).constraint
		}
		
		menuejo.addSubview(navigaciejo)
		navigaciejo.snp.makeConstraints { make in
			make.top.left.right.equalToSuperview()
			make.height.equalTo(navigaciilaAlto)
		}
		
		navigaciejo.addSubview(titolEtikedo)
		titolEtikedo.snp.makeConstraints { make in
			make.left.right.equalToSuperview()
			make.bottom.equalToSuperview().offset(-8)
		}
		
		menuejo.addSubview(rulumejo)
		rulumejo.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview()
			make.top.equalTo(navigaciejo.snp.bottom)
		}
		
		rulumejo.addEdgeMatchedSubview(elektoStaplo)
		rulumejo.snp.makeConstraints { make in
			make.width.equalTo(elektoStaplo.snp.width)
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		malfermi()
		
		rulumejo.contentSize = elektoStaplo.bounds.size
	}
	
	// MARK: - InterfacHelpiloj
	
	private func fariEroVidon(el ero: Menuero) -> ShovMenueroView {
		ShovMenueroView(
			bildo: ero.bildo,
			teksto: ero.teksto,
			elektis: { [weak self] in self?.elektis(eron: ero) },
			lasiBildoSpacon: havasBildojn,
			menuAgordoj: agordoj
		)
	}
	
	// MARK: - Agoj
	
	@objc private func premisOmbron() {
		malaperi()
	}
	
	private func elektis(eron ero: Menuero) {
		ero.ago()
		malaperi()
	}
	
	@objc private func shovis(_ rekonilo: UIPanGestureRecognizer) {
		let movo = rekonilo.translation(in: menuejo)
		
		switch rekonilo.state {
		case .began, .changed:
			let menuLargho = menuejo.bounds.width
			dekstraLigo?.update(offset: max(-menuLargho, -menuLargho + movo.x))
		case .ended, .cancelled:
			if menuejo.frame.minX < view.bounds.width - (menuejo.bounds.width / 2) {
				malfermi()
			} else {
				malaperi()
			}
		default:
			break
		}
	}
	
	@objc private func shovegis(_ rekonilo: UISwipeGestureRecognizer) {
		malaperi()
	}
	
	// MARK: -
	
	private func malfermi() {
		UIView.animate(withDuration: Konstantoj.animaciaDauro) { [weak self] in
			self?.dekstraLigo?.update(offset: -self!.menuejo.bounds.width)
			self?.view.layoutIfNeeded()
			self?.ombroView.alpha = Konstantoj.ombroMalhelo
		}
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
