import UIKit

import ReVoDatumbazo

/// Montras breton de la uzantaj lingvoj, kaj ebligas elekton inter ili
final class LingvoBretoViewController: UIViewController {
	private enum Konstantoj {
		/// Tiparo por butonoj
		static let butonoTiparo: UIFont = UIFont.systemFont(ofSize: 18.0) // TODO: Tiparo
		
		/// Spaco dekstre kaj maldekstre de ĉiuj butonoj
		static let butonoBufro: CGFloat = 16.0
		
		/// Diko de la substreko sub la elektita lingvo
		static let strekAlto: CGFloat = 1.0
		
		/// Daŭro de la elekta animacio
		static let animaciaDauro: CGFloat = 0.2
	}
	
	// MARK: Interfaceroj
	
	lazy var lingvoStaplo: UIStackView = {
		let staplo = UIStackView()
		staplo.axis = .horizontal
		staplo.spacing = Konstantoj.butonoBufro
		staplo.translatesAutoresizingMaskIntoConstraints = false
		return staplo
	}()
	
	lazy var substreko: UIView = {
		let strek = UIView()
		
		strek.snp.makeConstraints { make in
			make.height.equalTo(Konstantoj.strekAlto)
		}
		
		return strek
	}()
	
	lazy var rulumejo: UIScrollView = {
		let ejo = UIScrollView()
		ejo.showsHorizontalScrollIndicator = false
		
		ejo.addSubview(lingvoStaplo)
		ejo.snp.makeConstraints { make in
			make.top.bottom.height.equalTo(lingvoStaplo)
			make.left.equalTo(lingvoStaplo).offset(-Konstantoj.butonoBufro)
		}
		ejo.addSubview(substreko)
		ejo.delaysContentTouches = true

		return ejo
	}()
	
	lazy var pliButono: UIButton = {
		let butono = UIButton()
		butono.metiDinamikanTitolon(Tekstoj.pli, tiparo: Konstantoj.butonoTiparo)
		butono.addTarget(self, action: #selector(premisPli), for: .touchUpInside)
		return butono
	}()
	
	lazy var malaktivaSubstreko = OmbroImitilo()
	
	// MARK: Stato
	
	private(set) var elektita: Lingvo
	
	private(set) var lingvoj: [Lingvo]
	
	// MARK: Kalkulitaj stataĵoj
	
	/// La indekso de la nune elektita lingvo
	private var elektitaIndekso: Int? {
		lingvoj.firstIndex(of: elektita)
	}
	
	/// Koloro de la nune elektita lingvo kaj ĝia substreko
	private var aktivaKoloro: UIColor {
		stilo.dokumentLigilo
	}
	
	/// Koloro de la neelektitaj lingvoj kaj iliaj substrekoj
	private var malaktivaKoloro: UIColor {
		stilo.navigaciaButonoMalaktiva
	}
	
	// MARK: Agordoj
	
	private let elektisLingvon: (Lingvo) -> ()
	
	private let redaktisLingvojn: ([Lingvo]) -> ()
	
	private let kunordigilo: Kunordigilo
	
	private var stilo: InterfacStilo
	
	//
	
	init(
		elektitaLingvo: Lingvo,
		lingvoj: [Lingvo],
		elektisLingvon: @escaping  (Lingvo) -> (),
		redaktisLingvojn: @escaping ([Lingvo]) -> (),
		kunordigilo: Kunordigilo,
		stilo: InterfacStilo
	) {
		self.elektita = elektitaLingvo
		self.lingvoj = lingvoj
		self.elektisLingvon = elektisLingvon
		self.redaktisLingvojn = redaktisLingvojn
		self.kunordigilo = kunordigilo
		self.stilo = stilo
		
		super.init(nibName: nil, bundle: nil)
		
		meti(stilon: stilo)
	}
	
	convenience init(
		elektisLingvon: @escaping  (Lingvo) -> (),
		redaktisLingvojn: @escaping ([Lingvo]) -> (),
		uzantDatumaro: UzantDatumaro = .komuna,
		kunordigilo: Kunordigilo = .komuna,
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.init(
			elektitaLingvo: uzantDatumaro.elektitaLingvo,
			lingvoj: uzantDatumaro.lingvoj,
			elektisLingvon: elektisLingvon,
			redaktisLingvojn: redaktisLingvojn,
			kunordigilo: kunordigilo,
			stilo: stilo
		)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		view.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(malaktivaSubstreko)
		malaktivaSubstreko.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview()
		}
		
		view.addSubview(rulumejo)
		rulumejo.snp.makeConstraints { make in
			make.top.left.bottom.equalToSuperview()
		}
		
		view.addSubview(pliButono)
		pliButono.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview()
			make.right.equalToSuperview().offset(-Konstantoj.butonoBufro)
			make.left.equalTo(rulumejo.snp.right).offset(Konstantoj.butonoBufro)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Vokita ĉi tie por ke grandecoj estu jam fiksitaj
		renovigiInterfacon()
	}
	
	func meti(stilon stilo: InterfacStilo) {
		self.stilo = stilo
		
		view.backgroundColor = stilo.navigaciaFono
		substreko.backgroundColor = aktivaKoloro
		pliButono.setTitleColor(stilo.navigaciaButono, for: .normal)
		renovigiInterfacon()
	}
	
	// MARK: Uzantaj agoj
	
	/// Vokota kiam la uzanto elektas lingvon
	@objc private func premisLingvon(sender: UIButton) {
		let indekso = sender.tag
		let malnovaIndekso = elektitaIndekso
		
		elektita = lingvoj[indekso]
		montriElekton(de: malnovaIndekso, al: indekso)
		
		elektisLingvon(elektita)
		NotificationCenter.default.post(name: Avizoj.elektitaLingvoShanghighis, object: elektita)
	}
	
	private func shanghis(lingvaron lingvaro: [Lingvo]) {
		lingvoj = lingvaro
		if !lingvaro.contains(elektita) {
			elektita = lingvaro.first!
		}
		
		renovigiInterfacon()
	}
	
	// MARK: Ekstera regado - ekz. en kazo de ĝisdatigo pro avizo
	
	func ghisdatigi(elektitan novelektita: Lingvo) {
		guard let indekso = lingvoj.firstIndex(of: novelektita) else { return }
		let malnovaIndekso = elektitaIndekso
		elektita = lingvoj[indekso]
		montriElekton(de: malnovaIndekso, al: indekso)
	}
	
	func ghisdatigi(lingvaron lingvaro: [Lingvo]) {
		shanghis(lingvaron: lingvaro)
	}
	
	// MARK: Ĝisdatigado
	
	/// Ĝisdatigas la liston da lingvoj
	func renovigiInterfacon() {
		// Renovigi butonojn
		for view in lingvoStaplo.arrangedSubviews {
			lingvoStaplo.removeArrangedSubview(view)
			view.removeFromSuperview()
		}
		
		for i in 0..<lingvoj.count {
			let lingvo = lingvoj[i]
			
			let butono = UIButton()
			butono.metiDinamikanTitolon(lingvo.nomo, tiparo: Konstantoj.butonoTiparo)
			let koloro = (elektita.kodo == lingvo.kodo) ? aktivaKoloro : malaktivaKoloro // TODO: Lingva egaleco
			butono.setTitleColor(koloro, for: .normal)
			butono.addTarget(self, action: #selector(premisLingvon(sender:)), for: .touchUpInside)
			butono.tag = i
			butono.translatesAutoresizingMaskIntoConstraints = false
			
			lingvoStaplo.addArrangedSubview(butono)
		}
		
		// Doni larĝon al la rulumejo
		lingvoStaplo.layoutSubviews()
		rulumejo.layoutSubviews() // Necesas por ke lingvoStaplu havu sian grandecon
		rulumejo.contentSize = CGSize(
			width: lingvoStaplo.bounds.width + Konstantoj.butonoBufro * 2,
			height: lingvoStaplo.bounds.height
		)
		
		// Ĝisdatigi elekto-staton
		if let elektitaIndekso {
			substreki(indekson: elektitaIndekso, animacii: false)
			rulumi(al: elektitaIndekso, animacii: false)
		}
	}
	
	private func montriElekton(de malnovaIndekso: Int?, al indekso: Int) {
		guard let malnovaIndekso,
			  indekso != malnovaIndekso else {
			return
		}
		
		rekolorigi(aktiva: indekso, malaktiva: malnovaIndekso, animacii: true)
		rulumi(al: indekso, animacii: true)
		substreki(indekson: indekso, animacii: false)
	}
	
	
	/// Ŝanĝas kolorojn de la aktiva kaj nove-malaktiva butonoj
	private func rekolorigi(aktiva: Int, malaktiva: Int, animacii: Bool) {
		guard let aktivaButono = butono(por: aktiva),
			  let malaktivaButono = butono(por: malaktiva) else {
			return
		}
		
		let dauro = animacii ? Konstantoj.animaciaDauro : 0.0
		UIView.animate(
			withDuration: dauro,
			delay: 0.0,
			options: .curveEaseOut
		) { [weak self] in
			aktivaButono.setTitleColor(self?.aktivaKoloro, for: .normal)
			malaktivaButono.setTitleColor(self?.malaktivaKoloro, for: .normal)
		}
	}
	
	/// Rulumas la rulumejon tiel ke la nove elektita lingvo estu tute legebla
	private func rulumi(al indekso: Int, animacii: Bool) {
		let dauro = animacii ? Konstantoj.animaciaDauro : 0.0
		UIView.animate(
			withDuration: dauro,
			delay: 0.0,
			options: .curveEaseOut
		) { [weak self] in
			guard let self,
				  let butono = butono(por: indekso) else {
				return
			}
			
			let troMaldekstra = butono.frame.minX < rulumejo.contentOffset.x
			let troDekstra = butono.frame.maxX > rulumejo.contentOffset.x + rulumejo.bounds.width
			if troMaldekstra {
				rulumejo.contentOffset.x = butono.frame.minX
			} else if troDekstra {
				rulumejo.contentOffset.x = butono.frame.maxX - rulumejo.bounds.width + Konstantoj.butonoBufro * 2
			}
		}
	}
	
	/// Movas substrekon por ke ĝi restu sub la nun-elektita lingvo
	private func substreki(indekson indekso: Int, animacii: Bool) {
		guard let butono = butono(por: indekso) else {
			fatalError("Butono ne ekzistas")
		}
		
		substreko.snp.remakeConstraints { make in
			make.left.right.equalTo(butono).inset(-4)
			make.bottom.equalToSuperview()
			make.height.equalTo(Konstantoj.strekAlto)
		}
		
		let dauro = animacii ? Konstantoj.animaciaDauro : 0.0
		UIView.animate(
			withDuration: dauro,
			delay: 0.0,
			options: .curveEaseOut
		) { [weak self] in
			self?.view.layoutIfNeeded()
		}
	}
	
	// MARK: Helpiloj
	
	private func butono(por indekso: Int) -> UIButton? {
		guard indekso < lingvoStaplo.arrangedSubviews.count else {
			return nil
		}
		
		return lingvoStaplo.arrangedSubviews[indekso] as? UIButton
	}
	
	@objc private func premisPli() {
		guard let navigaciilo = navigationController else {
			return
		}
		
		kunordigilo.prezentiLingvoRedaktilon(prezentilo: navigaciilo) { [weak self] novajLingvoj in
			guard let self else { return }
			shanghis(lingvaron: novajLingvoj)
			redaktisLingvojn(novajLingvoj)
		}
	}
}
