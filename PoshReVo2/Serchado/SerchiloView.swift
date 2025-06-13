import UIKit

final class SerchiloView: UIView {
	private lazy var staplo: UIStackView = {
		let staplo = UIStackView(arrangedSubviews: [serchilo])
		staplo.axis = .vertical
		return staplo
	}()
	
	private lazy var serchilo: UISearchBar = {
		let serchilo = UISearchBar()
		serchilo.delegate = self
		serchilo.placeholder = lokokupaTeksto
		serchilo.searchTextField.backgroundColor = stilo.senkoloraFono
		serchilo.searchTextField.autocapitalizationType = .none
		
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
	
	// MARK: Stato
	
	var teksto: String? {
		serchilo.text
	}
	
	/// Ĉu 'x'-klako aldonu ĉapelon aŭ hokon
	var iksumi: Bool
	
	// MARK: Agordoj
	
	/// Lokokupa teksto kiu aperos en la serĉtabulo se uzanto jam ne tajpis
	private let lokokupaTeksto: String
	
	/// Vokotas kiam teksto ŝanĝiĝos
	private let tekstoShanghighis: (String) -> ()
	
	private let stilo: InterfacStilo
	
	init(
		lokokupaTeksto: String,
		iksumi: Bool,
		tekstoShanghighis: @escaping (String) -> (),
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo
	) {
		self.lokokupaTeksto = lokokupaTeksto
		self.iksumi = iksumi
		self.tekstoShanghighis = tekstoShanghighis
		self.stilo = stilo
		super.init(frame: .zero)
		
		addSubview(staplo)
		staplo.snp.makeConstraints { make in
			make.edges.equalTo(self)
		}
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) ne realas") }
}

extension SerchiloView: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		guard let teksto = searchBar.text else {
			return true
		}
		
		// Aldoni ĉapelojn
		if iksumi
			&& text == "x"
			&& teksto.count > 0 {
			if let iksumita = TekstHelpiloj.iksumiFinan(teksto) {
				searchBar.text = iksumita
				self.searchBar(searchBar, textDidChange: iksumita)
				return false
			}
		}
		
		return true
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		searchBar.text = searchText
		
		// TODO: Provu japanajn tekstojn, ĉar io speciala necesis en v1
		
		tekstoShanghighis(searchText)
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
}
