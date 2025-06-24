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
		for (indekso, ero) in self.eroj.enumerated() {
			let butono = fariButonon(el: ero, indekso: indekso)
			staplo.addArrangedSubview(butono)
		}
		return staplo
	}()
	
	private var dekstraLigo: Constraint?
	
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
	
	private func fariButonon(el ero: Menuero, indekso: Int) -> UIView {
		let butono = UIButton()
		butono.setTitle(ero.teksto, for: .normal)
		butono.setTitleColor(agordoj.tekstKoloro, for: .normal)
		butono.setTitleColor(agordoj.menuaKoloro, for: .highlighted)
		butono.backgroundColor = agordoj.menuaKoloro
		butono.titleLabel?.font = .systemFont(ofSize: 18) // TODO: tiparo
		butono.contentEdgeInsets = UIEdgeInsets(
			top: Konstantoj.vertikalaMargheno,
			left: Konstantoj.flankaMargheno,
			bottom: Konstantoj.vertikalaMargheno,
			right: Konstantoj.flankaMargheno
		)
		butono.tag = indekso
		butono.addTarget(self, action: #selector(ekpremis(butonon:)), for: .touchDown)
		butono.addTarget(self, action: #selector(finpremis(butonon:)), for: .touchUpInside)
		butono.addTarget(self, action: #selector(ekstereFinpremis(butonon:)), for: .touchUpOutside)
		butono.titleLabel?.lineBreakMode = .byTruncatingTail
		
		let dividilo = UIView()
		dividilo.backgroundColor = agordoj.dividiloKoloro
		dividilo.isUserInteractionEnabled = false
		
		let ujo = UIView()
		ujo.addEdgeMatchedSubview(butono)
		ujo.addSubview(dividilo)
		dividilo.snp.makeConstraints { make in
			make.right.bottom.equalToSuperview()
			make.left.equalToSuperview().offset(16)
			make.height.equalTo(1)
		}

		return ujo
	}
	
	// MARK: - Agoj
	
	@objc private func premisOmbron() {
		malaperi()
	}
	
	@objc private func ekpremis(butonon butono: UIButton) {
		butono.backgroundColor = agordoj.tekstKoloro
	}
	
	@objc private func finpremis(butonon butono: UIButton) {
		butono.backgroundColor = agordoj.menuaKoloro
		
		if butono.tag < eroj.count {
			eroj[butono.tag].ago()
		}
		
		malaperi()
	}
	
	@objc private func ekstereFinpremis(butonon butono: UIButton) {
		butono.backgroundColor = agordoj.menuaKoloro
	}
	
	@objc private func shovis(_ rekonilo: UIPanGestureRecognizer) {
		let movo = rekonilo.translation(in: menuejo)
		
		switch rekonilo.state {
		case .began, .changed:
			dekstraLigo?.update(offset: -menuejo.bounds.width + movo.x)
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
