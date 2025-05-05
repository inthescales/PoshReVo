import UIKit

import ReVoDatumbazo

/// Montras breton de la uzantaj lingvoj, kaj ebligas elekton inter ili
final class LingvoBretoViewController: UIViewController {
	private enum Konstantoj {
		/// Spaco dekstre kaj maldekstre de ĉiuj butonoj
		static let butonoBufro: CGFloat = 16.0
		
		/// Alteco de la substrek sub la elektita lingvo
		static let strekAlteco: CGFloat = 1.0
		
		/// Daŭro de la elekta animaciado
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
		
		strek.backgroundColor = stilo.surkoloraTeksto
		strek.snp.makeConstraints { make in
			make.height.equalTo(Konstantoj.strekAlteco)
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
		butono.setTitle(Tekstoj.pli, for: .normal)
		butono.setTitleColor(stilo.surkoloraTeksto, for: .normal)
		butono.addTarget(self, action: #selector(premisPli), for: .touchUpInside)
		return butono
	}()
	
	lazy var malaktivaSubstreko: UIView = {
		let strek = UIView()
		strek.backgroundColor = stilo.surkoloraMalaktiva
		return strek
	}()
	
	// MARK: Stato
	
	var elektita: Lingvo?
	
	private var lingvoj: [Lingvo]
	
	/// La indekso de la nune elektita lingvo
	private var elektitaIndekso: Int? {
		elektita.flatMap { lingvoj.firstIndex(of: $0) }
	}
	
	// MARK: Agordoj
	
	private let elektisLingvon: (Lingvo) -> ()
	
	private let redaktisLingvojn: ([Lingvo]) -> ()
	
	private let kunordigilo: Kunordigilo
	
	private var stilo: InterfacStilo
	
	//
	
	init(
		lingvoj: [Lingvo],
		elektisLingvon: @escaping  (Lingvo) -> (),
		redaktisLingvojn: @escaping ([Lingvo]) -> (),
		kunordigilo: Kunordigilo = .komuna,
		stilo: InterfacStilo = .nuna
	) {
		self.elektita = lingvoj.first
		self.lingvoj = lingvoj
		self.elektisLingvon = elektisLingvon
		self.redaktisLingvojn = redaktisLingvojn
		self.kunordigilo = kunordigilo
		self.stilo = stilo
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func viewDidLoad() {
		view.backgroundColor = self.stilo.koloraFono
		view.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(malaktivaSubstreko)
		malaktivaSubstreko.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview()
			make.height.equalTo(1)
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
		ghisdatigi(lingvojn: lingvoj) // Vokita ĉi tie por ke grandecoj estu jam fiksitaj
	}
	
	// MARK: Ĝisdatigado
	
	/// Ĝisdatigas la liston da lingvoj
	func ghisdatigi(lingvojn lingvoj: [Lingvo]) {
		self.lingvoj = lingvoj
		if elektita == nil || (elektita.flatMap { lingvoj.contains($0) } != true) {
			elektita = lingvoj.first
		}
		
		// Renovigi butonojn
		for view in lingvoStaplo.arrangedSubviews {
			lingvoStaplo.removeArrangedSubview(view)
			view.removeFromSuperview()
		}
		
		for i in 0..<lingvoj.count {
			let lingvo = lingvoj[i]
			
			let etikedo = UIButton()
			etikedo.setTitle(lingvo.nomo, for: .normal)
			let koloro = (elektita == lingvo) ? stilo.surkoloraTeksto : stilo.surkoloraMalaktiva
			etikedo.setTitleColor(koloro, for: .normal)
			etikedo.addTarget(self, action: #selector(elektisLingvon(sender:)), for: .touchUpInside)
			etikedo.tag = i
			etikedo.translatesAutoresizingMaskIntoConstraints = false
			
			lingvoStaplo.addArrangedSubview(etikedo)
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
		
		redaktisLingvojn(lingvoj)
	}
	
	/// Vokota kiam la uzanto elektas lingvon
	@objc private func elektisLingvon(sender: UIButton) {
		let indekso = sender.tag
		let malnovaIndekso = elektitaIndekso
		
		guard indekso != malnovaIndekso else {
			return
		}
		
		elektita = lingvoj[indekso]
		
		if let malnovaIndekso {
			rekolorigi(aktiva: indekso, malaktiva: malnovaIndekso, animacii: true)
		}
		rulumi(al: indekso, animacii: true)
		substreki(indekson: indekso, animacii: false)
		
		elektita.flatMap { elektisLingvon($0) }
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
			aktivaButono.setTitleColor(self?.stilo.surkoloraTeksto, for: .normal)
			malaktivaButono.setTitleColor(self?.stilo.surkoloraMalaktiva, for: .normal)
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
			make.height.equalTo(Konstantoj.strekAlteco)
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
		
		kunordigilo.prezentiLingvoElektilon(prezentilo: navigaciilo) { [weak self] novajLingvoj in
			self?.ghisdatigi(lingvojn: novajLingvoj)
		}
	}
}
