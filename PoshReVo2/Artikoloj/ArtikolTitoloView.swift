import UIKit

import ReVoDatumbazo

final class ArtikolTitoloView: UIView {
	private enum Konstantoj {
		static let margheno: CGFloat = 16
	}
	
	private lazy var etikedo: UILabel = {
		let etikedo = UILabel()
		etikedo.text = artikolo.titolo
		etikedo.font = .systemFont(ofSize: 30, weight: .bold)
		etikedo.textColor = stilo.teksto
		return etikedo
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
		butono.addTarget(self, action: #selector(premisKonservi), for: .touchUpInside)
		butono.tintColor = stilo.koloraFono
		return butono
	}()
	
	// MARK: Agordoj
	
	private let artikolo: Artikolo
	
	private let konservis: (Bool) -> ()
	
	private var stilo: InterfacStilo
	
	//
	
	init(
		artikolo: Artikolo,
		konservis: @escaping (Bool) -> (),
		stilo: InterfacStilo
	) {
		self.artikolo = artikolo
		self.konservis = konservis
		self.stilo = stilo
		super.init(frame: .zero)
		
		backgroundColor = self.stilo.senkoloraFono
		
		addSubview(etikedo)
		etikedo.snp.makeConstraints { make in
			make.top.bottom.left.equalToSuperview().inset(Konstantoj.margheno)
		}
		
		addSubview(konserviButono)
		konserviButono.snp.makeConstraints { make in
			make.top.bottom.right.equalToSuperview().inset(Konstantoj.margheno)
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
}
