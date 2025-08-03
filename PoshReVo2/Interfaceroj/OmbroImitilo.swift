import UIKit

/// Vido kiu imitas la maldikegan ombrostrekon sube de la iOSa navigactabulo en ĝia defaŭlta konduto
final class OmbroImitilo: UIView {
	// MARK: - Interfaceroj
	
	/// Streko sube de la serĉilo, imitanta la ombro de UINavigationController
	private lazy var ombroStreko: UIView = {
		let ombro = UIView()
		ombro.backgroundColor = stilo.ombro
		return ombro
	}()
	
	// MARK: - Kalkulita Stato
	
	/// La alto de ĉi elemento kiu prave imitus la ombron sube de UINavigationController
	lazy var preferataAlto: CGFloat = 1 / aparatInformo.skalo
	
	// MARK: - Agordoj
	
	private let stilo: InterfacStilo
	
	private let aparatInformo: AparatInformo
	
	// MARK: - Valorizado
	
	init(
		koloro: UIColor? = nil,
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo,
		aparatInformo: AparatInformo = NunaAparato()
	) {
		self.stilo = stilo
		self.aparatInformo = aparatInformo
		
		super.init(frame: .zero)
		
		backgroundColor = koloro ?? stilo.dokumentaFono
		addEdgeMatchedSubview(ombroStreko)
		
		snp.makeConstraints { make in
			make.height.equalTo(preferataAlto)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
}
