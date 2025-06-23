import UIKit

final class FadGradientoView: UIView {
	private let gradientTavolo = CAGradientLayer()
	init(stilo: InterfacStilo) {
		super.init(frame: .zero)
		
		backgroundColor = .clear
		
		layer.shadowColor = nil
		gradientTavolo.colors = [
			stilo.dokumentaFono.cgColor,
			stilo.dokumentaFono.withAlphaComponent(0).cgColor
		]
		gradientTavolo.locations = [0.45, 1.0] // Ĉi-valoroj taŭgas la artikolo-kapo
		layer.addSublayer(gradientTavolo)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) ne realas")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		gradientTavolo.frame = bounds
	}
}
