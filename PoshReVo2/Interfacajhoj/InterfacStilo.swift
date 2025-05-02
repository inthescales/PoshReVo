import UIKit

struct InterfacStilo {
	private var hela: Koloraro
	private var malhela: Koloraro
	
	lazy var senkoloraFono = UIColor(hela: hela.senkoloraFono, malhela: malhela.senkoloraFono)
	lazy var koloraFono = UIColor(hela: hela.koloraFono, malhela: malhela.koloraFono)
	
	lazy var teksto = UIColor(hela: hela.teksto, malhela: malhela.teksto)
	lazy var surkoloraButono = UIColor(hela: hela.surkoloraButono, malhela: malhela.surkoloraButono)
	
	lazy var surkoloraTeksto = UIColor(hela: hela.surkoloraTeksto, malhela: malhela.surkoloraTeksto)
	
	static let karamela = InterfacStilo(
		hela: Koloraro(
			senkoloraFono: .white,
			koloraFono: .orange,
			teksto: .black,
			surkoloraButono: .white,
			surkoloraTeksto: .white
		),
		malhela: Koloraro(
			senkoloraFono: .black, 
			koloraFono: .brown,
			teksto: .white,
			surkoloraButono: .black,
			surkoloraTeksto: .white
		)
	)
	
	static var nuna: InterfacStilo = .karamela
}

struct Koloraro {
	var senkoloraFono: UIColor
	var koloraFono: UIColor
	var teksto: UIColor
	var surkoloraButono: UIColor
	var surkoloraTeksto: UIColor
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
