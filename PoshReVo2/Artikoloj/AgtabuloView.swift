import UIKit

import SnapKit

final class AgtabuloView: UIView {
	private enum Konstantoj {
		static let vertikalaMargheno: CGFloat = 8.0
	}
	
	// MARK: - Interfaceroj
	
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
	
	private lazy var butonoj = [
		konserviButono,
		saltiButono
	]
	
	// MARK: - Agordoj
	
	private let konservis: (Bool) -> Void
	
	private let salti: () -> Void
	
	private let stilo: InterfacStilo
	
	init(
		konservis: @escaping (Bool) -> Void,
		salti: @escaping () -> Void,
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.konservis = konservis
		self.salti = salti
		self.stilo = stilo
		
		super.init(frame: .zero)
		
		backgroundColor = stilo.navigaciaFono
		starigiButonojn()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	// MARK: - Starigado
	
	private func starigiButonojn() {
		let staplo = UIStackView()
		staplo.axis = .horizontal
		staplo.distribution = .equalCentering

		let eroj = [UIView(), konserviButono, UIView(), saltiButono, UIView()]
		for ero in eroj {
			staplo.addArrangedSubview(ero)
		}
		
		addSubview(staplo)
		staplo.snp.makeConstraints { make in
			make.left.right.equalToSuperview()
			make.top.bottom.equalToSuperview().inset(Konstantoj.vertikalaMargheno)
		}
	}
	
//	private func starigiButonojn() {
//		for (i, butono) in butonoj.enumerated() {
//			let lasta = (i > 0) ? butonoj[i-1] : nil
//			
//			addSubview(butono)
//			if i == 0 {
//				butono.snp.makeConstraints { make in
//					make.top.bottom.left.equalToSuperview()
//				}
//			}
//			
//			if i < butonoj.count - 1 {
//				let sekvaDividilo = fariDividilon()
//				addSubview(sekvaDividilo)
//				sekvaDividilo.snp.makeConstraints { make in
//					make.top.bottom.equalToSuperview()
//					make.left.equalTo(butono.snp.right)
//				}
//			}
//			
//			if let lasta {
//				butono.snp.makeConstraints { make in
//					make.top.bottom.equalToSuperview()
//					make.left.equalTo(lasta.snp.right)
//				}
//			}
//
//			if i == butonoj.count - 1 {
//				butono.snp.makeConstraints { make in
//					make.right.equalToSuperview()
//				}
//			}
//		}
//	}
	
	private func fariDividilon() -> UIView {
		let dividilo = UIView()
		dividilo.snp.makeConstraints { make in
			make.width.equalTo(1)
		}
		dividilo.backgroundColor = stilo.navigaciaButonoMalaktiva
		return dividilo
	}
	
	private func fariNulon() -> UIView {
		return UIView()
	}
	
	// MARK: - Agoj
	
	@objc private func premisKonservi() {
		konserviButono.isSelected = !konserviButono.isSelected
		konservis(konserviButono.isSelected)
	}
	
	@objc private func premisSalti() {
		salti()
	}
}
