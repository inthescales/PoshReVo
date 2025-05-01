import UIKit

import ReVoDatumbazo

final class LingvoBretoView: UIView {
	private enum Konstantoj {
		/// Spaco dekstre kaj maldekstre de ĉiuj butonoj
		static let butonoBufro: CGFloat = 16.0
	}
	
	// MARK: Interfaceroj
	
	lazy var lingvoStaplo: UIStackView = {
		let staplo = UIStackView()
		staplo.axis = .horizontal
		staplo.spacing = Konstantoj.butonoBufro
		staplo.translatesAutoresizingMaskIntoConstraints = false
		return staplo
	}()
	
	lazy var rulumejo: UIScrollView = {
		let ejo = UIScrollView()
		ejo.addSubview(lingvoStaplo)
		ejo.snp.makeConstraints { make in
			make.top.bottom.height.equalTo(lingvoStaplo)
			make.left.equalTo(lingvoStaplo).offset(-Konstantoj.butonoBufro)
		}
		ejo.showsHorizontalScrollIndicator = false
		return ejo
	}()
	
	lazy var pliButono: UIButton = {
		let butono = UIButton()
		butono.setTitle(Tekstoj.pli, for: .normal)
		butono.setTitleColor(stilo.navigaciilaTeksto, for: .normal)
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
		
		ghisdatigi(lingvojn: lingvoj, elektita: elektita)
		
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
		
		lingvoj.forEach { lingvo in
			let etikedo = UILabel()
			etikedo.text = lingvo.nomo
			etikedo.textColor = stilo.navigaciilaTeksto
			lingvoStaplo.addArrangedSubview(etikedo)
		}
	}
}
