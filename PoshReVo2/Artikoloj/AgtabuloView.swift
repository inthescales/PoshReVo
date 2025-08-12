import UIKit

import SnapKit

/// Tabulo kiu sidas ekransupre en artikoloj por prezenti butonojn por artikolaj agoj
final class AgtabuloView: UIView {
	private enum Konstantoj {
		static let vertikalaMargheno: CGFloat = 8.0
	}
	
	// MARK: - Interfaceroj
	
	/// Butono kiu konservas kaj malkonservas artikolojn
	private lazy var konserviButono: UIButton = {
		let butono = UIButton()
		butono.setImage(
			Bildetoj.malplenaStelo?.withRenderingMode(.alwaysTemplate),
			for: .normal
		)
		butono.setImage(
			Bildetoj.plenaStelo?.withRenderingMode(.alwaysTemplate),
			for: .selected
		)
		butono.tintColor = stilo.navigaciaButono
		butono.addTarget(self, action: #selector(premisKonservi), for: .touchUpInside)
		return butono
	}()
	
	/// Butono por salti ene de artikolon
	private lazy var saltiButono: UIButton = {
		let butono = UIButton()
		butono.setImage(
			Bildetoj.saltosago?.withRenderingMode(.alwaysTemplate),
			for: .normal
		)
		butono.tintColor = stilo.navigaciaButono
		butono.addTarget(self, action: #selector(premisSalti), for: .touchUpInside)
		butono.accessibilityLabel = AlirebloTekstoj.saltiAl
		
		return butono
	}()
	
	/// Ĉiuj butonoj montrotaj
	private lazy var butonoj = [
		konserviButono,
		saltiButono
	]
	
	/// Streko borderanta la supron de la tabulo
	private lazy var ombroStreko = OmbroImitilo()
	
	// MARK: - Agordoj
	
	/// Fermo por konservado kaj malkonservado de artikolo
	private let konservis: (Bool) -> Void
	
	/// Fermo por montri saltmenuon
	private let salti: () -> Void
	
	private let stilo: InterfacStilo
	
	// MARK: - Valorizado
	
	init(
		konservita: Bool,
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
		proviziKonservbutonon(konservita: konservita)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	// MARK: - Ĝisdatiĝado
	
	private func proviziKonservbutonon(konservita: Bool) {
		konserviButono.isSelected = konservita
		konserviButono.accessibilityLabel = konservita ? Tekstoj.malkonservi : Tekstoj.konservi
	}
	
	// MARK: - Starigado
	
	/// Aranĝas butonojn en la tabulo.
	/// Nur voku unufoje.
	private func starigiButonojn() {
		let staplo = UIStackView()
		staplo.axis = .horizontal
		staplo.distribution = .equalCentering

		let eroj = [UIView(), konserviButono, UIView(), saltiButono, UIView()]
		for ero in eroj {
			staplo.addArrangedSubview(ero)
		}
		
		addSubview(ombroStreko)
		ombroStreko.snp.makeConstraints { make in
			make.top.left.right.equalToSuperview()
		}
		
		addSubview(staplo)
		staplo.snp.makeConstraints { make in
			make.top.equalTo(ombroStreko.snp.bottom).offset(Konstantoj.vertikalaMargheno)
			make.left.right.equalToSuperview()
			make.bottom.equalToSuperview().inset(Konstantoj.vertikalaMargheno)
		}
	}
	
	/// Liveras malplenan vidon, uzeblan por doni spacon inter butonoj
	private func fariNulon() -> UIView {
		return UIView()
	}
	
	// MARK: - Agoj
	
	@objc private func premisKonservi() {
		proviziKonservbutonon(konservita: !konserviButono.isSelected)
		konservis(konserviButono.isSelected)
	}
	
	@objc private func premisSalti() {
		salti()
	}
}
