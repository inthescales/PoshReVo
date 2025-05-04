import UIKit

struct InterfacStilo {
	private var hela: Koloraro
	private var malhela: Koloraro
	
	lazy var senkoloraFono = UIColor(hela: hela.senkoloraFono, malhela: malhela.senkoloraFono)
	lazy var koloraFono = UIColor(hela: hela.koloraFono, malhela: malhela.koloraFono)
	
	lazy var teksto = UIColor(hela: hela.teksto, malhela: malhela.teksto)
	lazy var ligilo = UIColor(hela: hela.ligilo, malhela: malhela.ligilo)
	
	lazy var surkoloraButono = UIColor(hela: hela.surkoloraButono, malhela: malhela.surkoloraButono)
	lazy var surkoloraTeksto = UIColor(hela: hela.surkoloraTeksto, malhela: malhela.surkoloraTeksto)
	lazy var surkoloraMalaktiva = UIColor(hela: hela.surkoloraMalaktiva, malhela: malhela.surkoloraMalaktiva)
	
	static let karamela = InterfacStilo(
		hela: Koloraro(
			senkoloraFono: .white,
			koloraFono: .orange,
			teksto: .black,
			ligilo: .brown,
			surkoloraButono: .white,
			surkoloraTeksto: .white,
			surkoloraMalaktiva: .brown
		),
		malhela: Koloraro(
			senkoloraFono: .black, 
			koloraFono: .brown,
			teksto: .white,
			ligilo: .brown,
			surkoloraButono: .black,
			surkoloraTeksto: .white,
			surkoloraMalaktiva: .brown
		)
	)
	
	static var nuna: InterfacStilo = .karamela
}

struct Koloraro {
	var senkoloraFono: UIColor
	var koloraFono: UIColor
	var teksto: UIColor
	var ligilo: UIColor
	var surkoloraButono: UIColor
	var surkoloraTeksto: UIColor
	var surkoloraMalaktiva: UIColor
}

// Helpiloj

extension UIColor {
	convenience init(hela: UIColor, malhela: UIColor) {
		self.init(dynamicProvider: { trajtaro in
			switch Stilo.el(trajtaro: trajtaro) {
			case .hela:
				return hela
			case .malhela:
				return malhela
			}
		})
	}
}
