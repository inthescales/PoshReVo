import UIKit

final class HejmaNavigaciButton: UIButton {
	enum Konstantoj {
		static let alteco: CGFloat = 48.0
		
		static let largheco: CGFloat = 325.0
		
		static let angulRadiuso: CGFloat = 16.0
	}
	
	private let stilo: InterfacStilo
	
	init(teksto: String, stilo: InterfacStilo = UzantDatumaro.komuna.stilo) {
		self.stilo = stilo
		super.init(frame: .zero)
	
		setTitle(teksto, for: .normal)
		setTitleColor(self.stilo.dokumentaTeksto, for: .normal)
		backgroundColor = self.stilo.navigaciaButono
		
		layer.cornerRadius = Konstantoj.angulRadiuso
		snp.makeConstraints { make in
			make.height.equalTo(Konstantoj.alteco)
			make.width.equalTo(Konstantoj.largheco)
		}
		
		layer.masksToBounds = false
		layer.shadowOffset = CGSize(width: 0, height: 3)
		layer.shadowRadius = 4
		layer.shadowOpacity = 0.4
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) ne realas") }
}
