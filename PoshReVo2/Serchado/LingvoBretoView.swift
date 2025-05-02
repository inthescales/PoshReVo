import UIKit

import ReVoDatumbazo

final class LingvoBretoView: UIView {
	private enum Konstantoj {
		/// Spaco dekstre kaj maldekstre de ĉiuj butonoj
		static let butonoBufro: CGFloat = 16.0
		
		/// Alteco de la substrek sub la elektita lingvo
		static let strekAlteco: CGFloat = 2.0
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

		return ejo
	}()
	
	lazy var pliButono: UIButton = {
		let butono = UIButton()
		butono.setTitle(Tekstoj.pli, for: .normal)
		butono.setTitleColor(stilo.surkoloraTeksto, for: .normal)
		return butono
	}()
	
	// MARK: Stato
	
	var elektita: Lingvo?
	
	var lingvoj: [Lingvo]
	
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
		substreki(indekson: 1, animacii: false)
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
	
	private func ghisdatigi(lingvojn lingvoj: [Lingvo], elektita: Lingvo?) {
		for view in lingvoStaplo.arrangedSubviews {
			lingvoStaplo.removeArrangedSubview(view)
		}
		
		for i in 0..<lingvoj.count {
			let lingvo = lingvoj[i]
			
			let etikedo = UIButton()
			etikedo.setTitle(lingvo.nomo, for: .normal)
			etikedo.tintColor = stilo.surkoloraTeksto
			etikedo.addTarget(self, action: #selector(elektisLingvon(sender:)), for: .touchUpInside)
			etikedo.tag = i
			etikedo.translatesAutoresizingMaskIntoConstraints = false
			
			lingvoStaplo.addArrangedSubview(etikedo)
		}
	}
	
	@objc private func elektisLingvon(sender: UIButton) {
		substreki(indekson: sender.tag, animacii: true)
	}
	
	private func substreki(indekson indekso: Int, animacii: Bool) {
		guard indekso < lingvoj.count else {
			fatalError("Butona indekso estas tro granda")
		}
		
		let etikedo = lingvoStaplo.arrangedSubviews[indekso]
		
		substreko.snp.remakeConstraints { make in
			make.left.right.equalTo(etikedo).inset(-4)
			make.bottom.equalToSuperview()
			make.height.equalTo(Konstantoj.strekAlteco)
		}
		UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut) { [weak self] in
			self?.layoutIfNeeded()
		}
	}
}
