import UIKit

import ReVoDatumbazo

/// Montras breton de la uzantaj lingvoj, kaj ebligas elekton inter ili
final class LingvoBretoView: UIView {
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
		return butono
	}()
	
	lazy var malaktivaSubstreko: UIView = {
		let strek = UIView()
		strek.backgroundColor = stilo.surkoloraMalaktiva
		return strek
	}()
	
	// MARK: Stato
	
	var elektita: Lingvo?
	
	var lingvoj: [Lingvo]
	
	/// La indekso de la nune elektita lingvo
	var elektitaIndekso: Int? {
		elektita.flatMap { lingvoj.firstIndex(of: $0) }
	}
	
	// MARK: Agordoj
	
	let elektisLingvon: (Lingvo) -> ()
	
	let redaktisLingvojn: ([Lingvo]) -> ()
	
	var stilo: InterfacStilo
	
	//
	
	init(
		lingvoj: [Lingvo],
		elektisLingvon: @escaping  (Lingvo) -> (),
		redaktisLingvojn: @escaping ([Lingvo]) -> (),
		stilo: InterfacStilo = .nuna
	) {
		self.elektita = lingvoj.first
		self.lingvoj = lingvoj
		self.elektisLingvon = elektisLingvon
		self.redaktisLingvojn = redaktisLingvojn
		self.stilo = stilo
		super.init(frame: .zero)
		
		backgroundColor = self.stilo.koloraFono
		translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(malaktivaSubstreko)
		malaktivaSubstreko.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview()
			make.height.equalTo(1)
		}
		
		addSubview(rulumejo)
		rulumejo.snp.makeConstraints { make in
			make.top.left.bottom.equalToSuperview()
		}
		
		addSubview(pliButono)
		pliButono.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview()
			make.right.equalToSuperview().offset(-Konstantoj.butonoBufro)
			make.left.equalTo(rulumejo.snp.right).offset(Konstantoj.butonoBufro)
		}
		
		ghisdatigi(lingvojn: lingvoj, elektita: elektita)
		substreki(indekson: 0, animacii: false)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		rulumejo.layoutSubviews() // Necesas por ke lingvoStaplu havu sian grandecon
		rulumejo.contentSize = CGSize(
			width: lingvoStaplo.bounds.width + Konstantoj.butonoBufro,
			height: lingvoStaplo.bounds.height
		)
	}
	
	// MARK: Ĝisdatigado
	
	/// Ĝisdatigas la liston da lingvoj
	private func ghisdatigi(lingvojn lingvoj: [Lingvo], elektita: Lingvo?) {
		for view in lingvoStaplo.arrangedSubviews {
			lingvoStaplo.removeArrangedSubview(view)
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
			self?.layoutIfNeeded()
		}
	}
	
	// MARK: Helpiloj
	
	private func butono(por indekso: Int) -> UIButton? {
		guard indekso < lingvoStaplo.arrangedSubviews.count else {
			return nil
		}
		
		return lingvoStaplo.arrangedSubviews[indekso] as? UIButton
	}
}
