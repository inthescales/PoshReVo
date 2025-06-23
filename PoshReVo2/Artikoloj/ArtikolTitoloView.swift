import UIKit

import ReVoDatumbazo

final class ArtikolTitoloView: UIView {
	private enum Konstantoj {
		static let flankaMargheno: CGFloat = 16
		static let vertikalaMargheno: CGFloat = 8
		static let internaMargheno: CGFloat = 8
		static let angulRadiuso: CGFloat = 18
	}
	
	// MARK: - Interfaceroj
	
	private lazy var fonoView: UIView = {
		let fono = UIView()
		fono.layer.cornerRadius = Konstantoj.angulRadiuso
		fono.layer.shadowOffset = CGSize(width: 0, height: 2)
		fono.layer.shadowRadius = 1
		fono.layer.shadowColor = UIColor.black.cgColor
		fono.layer.shadowOpacity = 0.2
		fono.backgroundColor = stilo.navigaciaFono
		return fono
	}()
	
	private lazy var gradientejo = FadGradientoView(stilo: stilo)
	
	private lazy var etikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.text = artikolo.titolo
		etikedo.font = .systemFont(ofSize: 30, weight: .bold) // TODO: Tiparo
		etikedo.textColor = stilo.navigaciaTeksto
		return etikedo
	}()
	
	private lazy var dividilo: UIView = {
		let ilo = UIView()
		ilo.snp.makeConstraints { make in
			make.width.equalTo(1)
		}
		ilo.backgroundColor = stilo.navigaciaButonoMalaktiva
		return ilo
	}()
	
	private lazy var konserviButono: UIButton = {
		let butono = UIButton()
		butono.setImage(
			UIImage(named: "malplenaStelo")?.withRenderingMode(.alwaysTemplate),
			for: .normal
		)
		butono.setImage(
			UIImage(named: "plenaStelo")?.withRenderingMode(.alwaysTemplate),
			for: .selected
		)
		butono.tintColor = stilo.navigaciaTeksto
		butono.addTarget(self, action: #selector(premisKonservi), for: .touchUpInside)
		return butono
	}()
	
	private lazy var saltiButono: UIButton = {
		let butono = UIButton()
		butono.setImage(
			UIImage(named: "saltosago")?.withRenderingMode(.alwaysTemplate),
			for: .normal
		)
		butono.tintColor = stilo.navigaciaTeksto
		butono.addTarget(self, action: #selector(premisSalti), for: .touchUpInside)
		return butono
	}()
	
	private lazy var butonoStaplo: UIStackView = {
		let staplo = UIStackView()
		staplo.axis = .horizontal
		staplo.spacing = Konstantoj.internaMargheno
		
		[konserviButono, saltiButono].forEach { butono in
			staplo.addArrangedSubview(butono)
		}
		
		return staplo
	}()
	
	// MARK: Agordoj
	
	private let artikolo: Artikolo
	
	private let konservis: (Bool) -> Void
	
	private let salti: () -> Void
	
	private let stilo: InterfacStilo
	
	//
	
	init(
		artikolo: Artikolo,
		konservis: @escaping (Bool) -> Void,
		salti: @escaping () -> Void,
		margheno: CGFloat,
		stilo: InterfacStilo
	) {
		self.artikolo = artikolo
		self.konservis = konservis
		self.salti = salti
		self.stilo = stilo
		super.init(frame: .zero)
		
		backgroundColor = .clear
		
		addSubview(fonoView)
		fonoView.snp.makeConstraints { make in
			make.edges.equalToSuperview().inset(margheno)
		}
		
		addSubview(gradientejo)
		gradientejo.snp.makeConstraints { make in
			make.left.right.bottom.equalToSuperview()
			make.height.equalTo(margheno + Konstantoj.angulRadiuso)
		}
		sendSubviewToBack(gradientejo)
		
		addSubview(etikedo)
		etikedo.snp.makeConstraints { make in
			make.left.equalTo(fonoView).inset(Konstantoj.flankaMargheno)
			make.top.bottom.equalTo(fonoView).inset(Konstantoj.vertikalaMargheno)
		}
		
		addSubview(dividilo)
		dividilo.snp.makeConstraints { make in
			make.left.greaterThanOrEqualTo(etikedo.snp.right).offset(Konstantoj.internaMargheno * 2)
			make.top.bottom.equalTo(fonoView).inset(Konstantoj.vertikalaMargheno)
		}
		
		addSubview(butonoStaplo)
		butonoStaplo.snp.makeConstraints { make in
			make.left.equalTo(dividilo.snp.right).offset(Konstantoj.internaMargheno * 2)
			make.right.equalTo(fonoView).inset(Konstantoj.flankaMargheno)
			make.top.bottom.equalTo(fonoView).inset(Konstantoj.vertikalaMargheno)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	func agordi(konservita: Bool) {
		konserviButono.isSelected = konservita
	}
	
	// MARK: Uzantaj Agoj
	
	@objc private func premisKonservi() {
		konserviButono.isSelected = !konserviButono.isSelected
		konservis(konserviButono.isSelected)
	}
	
	@objc private func premisSalti() {
		salti()
	}
}
