import UIKit

/// Serĉilo, uzebla por ĉio ajn, kun speciala stilo
final class SerchiloView: UIView {
	// MARK: - Interfaceroj
	
	/// Fono aperonta malantaŭ la tekstejo
	private lazy var fono = UIView()
	
	/// La serĉilo mem
	private lazy var serchilo: UISearchBar = {
		let serchilo = UISearchBar()
		serchilo.delegate = self
		serchilo.placeholder = lokokupaTeksto
		
		serchilo.searchTextField.autocapitalizationType = .none
		serchilo.searchBarStyle = .prominent
		
		// Nevidebligi la UISearchBarBackground-on
		serchilo.backgroundColor = .clear
		serchilo.barTintColor = .clear
		serchilo.backgroundImage = UIImage()
		
		serchilo.searchTextField.isAccessibilityElement = true
		serchilo.searchTextField.accessibilityIdentifier = "serchTabulaTekstejo"
		
		return serchilo
	}()
	
	/// Streko imitanta navigactabula ombro
	private lazy var imitoStreko = OmbroImitilo()
	
	// MARK: - Publika Stato
	
	var teksto: String? {
		serchilo.text
	}
	
	/// Ĉu aldono de liter 'x' aldonu ĉapelon aŭ hokon
	var iksumi: Bool
	
	// MARK: - Agordoj
	
	/// Lokokupa teksto kiu aperos en la serĉtabulo se uzanto jam ne tajpis
	private let lokokupaTeksto: String
	
	/// Vokotas kiam teksto ŝanĝiĝos
	private let tekstoShanghighis: (String) -> ()
	
	private let stilo: InterfacStilo
	
	private let aparatInformo: AparatInformo
	
	// MARK: - Valorizado
	
	init(
		lokokupaTeksto: String,
		iksumi: Bool,
		montriOmbron: Bool = true,
		tekstoShanghighis: @escaping (String) -> (),
		stilo: InterfacStilo = UzantDatumaro.komuna.stilo,
		aparatInformo: AparatInformo = NunaAparato()
	) {
		self.lokokupaTeksto = lokokupaTeksto
		self.iksumi = iksumi
		self.tekstoShanghighis = tekstoShanghighis
		self.stilo = stilo
		self.aparatInformo = aparatInformo
		super.init(frame: .zero)
		
		addEdgeMatchedSubview(fono)

		addSubview(serchilo)
		serchilo.snp.makeConstraints { make in
			make.top.right.left.equalToSuperview()
		}
		
		if !montriOmbron {
			serchilo.snp.makeConstraints { make in
				make.bottom.equalToSuperview()
			}
		} else {
			addSubview(imitoStreko)
			imitoStreko.snp.makeConstraints { make in
				make.left.right.bottom.equalToSuperview()
			}
			serchilo.snp.makeConstraints { make in
				make.bottom.equalTo(imitoStreko.snp.top)
			}
		}
		
		meti(stilon: stilo)
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) ne realas") }
	
	// MARK: - Publikaj agoj
	
	/// Nuligi la tekston en la tekstejo
	func nuligiTekston() {
		serchilo.text = ""
	}
	
	/// Meti novan stilon al la ekrano
	func meti(stilon stilo: InterfacStilo) {
		fono.backgroundColor = stilo.navigaciaFono
		
		serchilo.searchTextField.attributedPlaceholder = NSAttributedString(
			string: lokokupaTeksto,
			attributes: [NSAttributedString.Key.foregroundColor :stilo.dokumentaTeksto.withAlphaComponent(0.5)]
		)
		serchilo.searchTextField.backgroundColor = stilo.navigaciaSerchilo
		serchilo.searchTextField.textColor = stilo.dokumentaTeksto
		serchilo.tintColor = stilo.dokumentaTeksto
	}
}

// MARK: - UISearchBarDelegate

extension SerchiloView: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		guard let teksto = searchBar.text else {
			return true
		}
		
		// Aldoni ĉapelojn kaj hokojn
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
		tekstoShanghighis(searchText)
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
}
