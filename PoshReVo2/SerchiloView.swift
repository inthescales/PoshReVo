import UIKit

final class SerchiloView: UIView {
	private let lokokupaTeksto: String
	
	private lazy var staplo: UIStackView = {
		let staplo = UIStackView(arrangedSubviews: [serchilo])
		staplo.axis = .vertical
		return staplo
	}()
	
	private lazy var serchilo: UISearchBar = {
		let serchilo = UISearchBar()
		serchilo.placeholder = lokokupaTeksto
		serchilo.searchTextField.backgroundColor = InterfacStilo.nuna.senkoloraFono
		
		// Ŝajne, ĉio ĉi frenezaĵo necesas por nevidebligi la fonon malantaŭ la tekstejo
		serchilo.backgroundColor = .clear
		serchilo.barTintColor = .clear
		serchilo.backgroundImage = UIImage(named: "falsaNomo")
		for subview in serchilo.subviews {
			if let fonoClass: AnyClass = NSClassFromString("UISearchBarBackground") {
				for fonoView in subview.subviews where fonoView.isKind(of: fonoClass) {
					fonoView.backgroundColor = .clear
					fonoView.isHidden = true
					fonoView.alpha = 0
				}
			}
		}
		
		serchilo.searchTextField.isAccessibilityElement = true
		serchilo.searchTextField.accessibilityIdentifier = "serchTabulaTekstejo"
		
		return serchilo
	}()
	
	init(lokokupaTeksto: String) {
		self.lokokupaTeksto = lokokupaTeksto
		super.init(frame: .zero)
		
		addSubview(staplo)
		staplo.snp.makeConstraints { make in
			make.edges.equalTo(self)
		}
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) ne realas") }
}
