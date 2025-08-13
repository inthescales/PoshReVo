import UIKit
import SnapKit

/// Menuo kiu aperas paĝflanke en navigaciado kaj artikolsaltado
final class ShovMenuoViewController: UIViewController {
	private enum Konstantoj {
		/// Minimuma larĝo de la menuejo sur iPhone
		static let minimumaLarghoiPhone: CGFloat = 200
		
		/// Minimuma larĝo de la menuejo sur iPad
		static let minimumaLarghoiPad: CGFloat = 250
		
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
	
	/// Agordoj por provizi menuan interfacon
	struct Agordoj {
		let titolo: String?
		let navigaciaKoloro: UIColor
		let navigaciaTekstKoloro: UIColor
		let menuaKoloro: UIColor
		let malplenaKoloro: UIColor
		let tekstKoloro: UIColor
		let dividiloKoloro: UIColor
		
		static func el(stilo: InterfacStilo, titolo: String?) -> Agordoj {
			Agordoj(
				titolo: titolo,
				navigaciaKoloro: stilo.shovmenuaFono,
				navigaciaTekstKoloro: stilo.dokumentaTeksto,
				menuaKoloro: stilo.shovmenuaFono,
				malplenaKoloro: stilo.shovmenuaFono,
				tekstKoloro: stilo.dokumentaTeksto,
				dividiloKoloro: stilo.dokumentaTeksto.withAlphaComponent(0.3)
			)
		}
	}
	
	struct Menuero {
		let bildo: UIImage?
		let teksto: String
		let ago: () -> ()
	}
	
	// MARK: - Interfaceroj
	
	/// Ombra vido kiu estos surmetita sur la baza VC, por indiki ke ĝi estas fora
	private lazy var ombroView: UIView = {
		let view = UIView()
		view.backgroundColor = .black
		view.alpha = 0
		view.addGestureRecognizer(
			UITapGestureRecognizer(target: self, action: #selector(premisOmbron))
		)
		
		view.isAccessibilityElement = true
		view.accessibilityLabel = AlirebloTekstoj.fermiMenuon
		// Certigas ke la premo tuŝu la ombron mem, nek menueron nek statustabulon
		view.accessibilityActivationPoint = CGPoint(x: 1.0, y: navigaciilaAlto + 5)
		
		return view
	}()
	
	/// Supra regiono de la menuo, imitanta ordinaran supran navigaciejon
	private lazy var navigaciejo: UIView = {
		let ejo = UIView()
		ejo.backgroundColor = agordoj.navigaciaKoloro
		
		let dividilo = OmbroImitilo(koloro: agordoj.navigaciaKoloro)
		ejo.addSubview(dividilo)
		dividilo.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview()
		}
		
		return ejo
	}()
	
	/// Titoletikedo aperanta en la navigaciejo
	private lazy var titolEtikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.text = agordoj.titolo
		etikedo.textColor = agordoj.navigaciaTekstKoloro
		etikedo.textAlignment = .center
		etikedo.font = Tiparo.shovMenuoTitolo
		return etikedo
	}()
	
	/// La tuta areo kiun okupos la menuo. Partoj eble estos malplenaj
	private lazy var menuejo: UIView = {
		let view = UIView()
		view.backgroundColor = agordoj.menuaKoloro

		let rekonilo = UIPanGestureRecognizer(target: self, action: #selector(shovis))
		let rekonilego = UISwipeGestureRecognizer(target: self, action: #selector(shovegis))
		[rekonilo, rekonilego].forEach { view.addGestureRecognizer($0) }
		
		return view
	}()
	
	/// Rulumejo por rulumado de menuenhavoj
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
	
	/// Vidoligo (view constraint) kiu regas la pozicion de la menuo
	private var dekstraLigo: Constraint?
	
	// MARK: - Kalkulita Stato
	
	/// Ĉu estas almenaŭ unu bildo inter la menueroj
	private lazy var havasBildojn = eroj.contains(where: { $0.bildo != nil })
	
	/// La minimuma larĝo de la menuo. Dependas de la aparatklaso.
	private lazy var minimumaLargho: CGFloat = {
		switch aparatInformo.aparatKlaso {
		case .iFono:
			Konstantoj.minimumaLarghoiPhone
		case .iPado:
			Konstantoj.minimumaLarghoiPad
		}
	}()
	
	// MARK: - Agordoj
	
	/// Menueroj
	private let eroj: [Menuero]
	
	/// Stilagordoj de la menuo
	private let agordoj: Agordoj
	
	/// La alto de la navigaciejo. Devas esti egala al la aparata navigaciej-alto
	private let navigaciilaAlto: CGFloat
	
	/// Fermo kiu malaperigas la menuon
	private let foriri: () -> Void
	
	private let aparatInformo: AparatInformo
	
	// MARK: - Valorizado
	
	init(
		eroj: [Menuero],
		agordoj: Agordoj,
		navigaciilaAlto: CGFloat,
		forigi foriri: @escaping () -> Void,
		aparatInformo: AparatInformo = NunaAparato()
	) {
		self.eroj = eroj
		self.agordoj = agordoj
		self.navigaciilaAlto = navigaciilaAlto
		self.foriri = foriri
		self.aparatInformo = aparatInformo
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
			make.width.greaterThanOrEqualTo(minimumaLargho)
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
	
	/// Faras kaj liveras vidon representantan tiun menueron
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
	
	/// Uzanto premis la ombron
	@objc private func premisOmbron() {
		malaperi()
	}
	
	/// Uzanto elektis tiun eron
	private func elektis(eron ero: Menuero) {
		ero.ago()
		malaperi()
	}
	
	/// Uzanto ŝovis la menuon flanken ajnadirekten
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
	
	/// La uzanto rapide ŝovegis (swiped) la menuon dekstren
	@objc private func shovegis(_ rekonilo: UISwipeGestureRecognizer) {
		malaperi()
	}
	
	// MARK: - Aperado kaj Malaperado
	
	/// Aperigas la menuon, aŭ igas ke ĝi okupu sian plenan larĝon. Ombrigas la ombron.
	private func malfermi() {
		UIView.animate(withDuration: Konstantoj.animaciaDauro) { [weak self] in
			self?.dekstraLigo?.update(offset: -self!.menuejo.bounds.width)
			self?.view.layoutIfNeeded()
			self?.ombroView.alpha = Konstantoj.ombroMalhelo
		}
	}
	
	/// Malaperigas la menuon kaj la ombron
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
