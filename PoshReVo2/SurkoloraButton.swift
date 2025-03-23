import UIKit

final class SurkoloraButton: UIButton {
	var stilo: InterfacStilo
	
	init(teksto: String, stilo: InterfacStilo = .nuna) {
		self.stilo = stilo
		super.init(frame: .zero)
	
		setTitle(teksto, for: .normal)
		setTitleColor(self.stilo.teksto, for: .normal)
		backgroundColor = self.stilo.surkoloraButono
		
		layer.cornerRadius = 24
		snp.makeConstraints { make in
			make.height.equalTo(60)
			make.width.equalTo(240)
		}
		
		layer.masksToBounds = false
		layer.shadowOffset = CGSize(width: 0, height: 3)
		layer.shadowRadius = 4
		layer.shadowOpacity = 0.4
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) ne realas") }
}
