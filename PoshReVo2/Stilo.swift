import UIKit

struct InterfacStilo {
	var hela: Koloraro
	var malhela: Koloraro
	
	lazy var senkoloraFono: UIColor = UIColor(hela: hela.senkoloraFono, malhela: malhela.senkoloraFono)
	lazy var koloraFono: UIColor = UIColor(hela: hela.koloraFono, malhela: malhela.koloraFono)
	lazy var teksto: UIColor = UIColor(hela: hela.teksto, malhela: malhela.teksto)
	
	static let karamela = InterfacStilo(
		hela: Koloraro(senkoloraFono: .white, koloraFono: .orange, teksto: .black),
		malhela: Koloraro(senkoloraFono: .black, koloraFono: .brown, teksto: .white)
	)
	
	static var nuna: InterfacStilo = .karamela
}

struct Koloraro {
	var senkoloraFono: UIColor
	var koloraFono: UIColor
	var teksto: UIColor
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
