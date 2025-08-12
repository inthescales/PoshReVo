import UIKit

/// Klariga vido prezentebla kiam vortolisto havas neniujn vortojn
final class VortListoNulStatoView: UIView {
	private enum Konstantoj {
		/// Kie en la vertikala spaco de la patra vido ĉi tiu estu, kiel porcio de ĝia alto
		static let vertikalaCentroPorcio: CGFloat = 0.5
		
		/// Kiom de la horizontala larĝo de la patra vido ĉi tiu povu okupi
		static let larghoPorcio: CGFloat = 0.8
	}
	
	// MARK: - Interfaceroj
	
	/// Etikedo montranta nulstatan mesaĝon
	private lazy var etikedo: UILabel = {
		let eti = UILabel()
		eti.numberOfLines = 0
		eti.text = teksto
		eti.font = Tiparo.nulstato
		
		return eti
	}()
	
	// MARK: - Agordoj
	
	/// Teksto montrota
	private let teksto: String
	
	// MARK: - Valorizado
	
	init(teksto: String, stilo: InterfacStilo = UzantDatumaro.komuna.stilo) {
		self.teksto = teksto
		
		super.init(frame: .zero)
		
		backgroundColor = .clear
		
		addSubview(etikedo)
		etikedo.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.centerY.equalTo(self.snp.bottom).multipliedBy(Konstantoj.vertikalaCentroPorcio)
			make.width.lessThanOrEqualToSuperview().multipliedBy(Konstantoj.larghoPorcio)
		}
		
		meti(stilon: stilo)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	func meti(stilon stilo: InterfacStilo) {
		etikedo.textColor = stilo.dokumentaMalfortaTeksto
	}
}
