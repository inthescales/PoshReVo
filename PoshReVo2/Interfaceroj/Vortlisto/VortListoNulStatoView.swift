import UIKit

final class VortListoNulStatoView: UIView {
	private enum Konstantoj {
		static let vertikalaCentroPorcio: CGFloat = 0.5
		
		static let larghoPorcio: CGFloat = 0.8
	}
	
	// MARK: - Interfaceroj
	
	private lazy var etikedo: UILabel = {
		let eti = UILabel()
		eti.numberOfLines = 0
		eti.text = teksto
		eti.font = .italicSystemFont(ofSize: 20).dinamika() // TODO: Tiparo
		eti.textColor = stilo.dokumentaTeksto.withAlphaComponent(0.5) // TODO: Aldoni malfortan koloron
		
		return eti
	}()
	
	// MARK: - Agordoj
	
	private let teksto: String
	
	private let stilo: InterfacStilo
	
	init(teksto: String, stilo: InterfacStilo = UzantDatumaro.komuna.stilo) {
		self.teksto = teksto
		self.stilo = stilo
		
		super.init(frame: .zero)
		
		backgroundColor = .clear
		
		addSubview(etikedo)
		etikedo.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.centerY.equalTo(self.snp.bottom).multipliedBy(Konstantoj.vertikalaCentroPorcio)
			make.width.lessThanOrEqualToSuperview().multipliedBy(Konstantoj.larghoPorcio)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
}
