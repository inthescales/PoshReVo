import UIKit

// MARK: - AparatInformo

/// Klaso de aparato
enum AparatKlaso {
	case iFono
	case iPado
}

/// Orientiĝo de la ekrano
enum Orientigho {
	case vertikala
	case horizontala
}

enum Heleco {
	case hela
	case malhela
	
	static func el(trajtaro: UITraitCollection) -> Heleco {
		switch trajtaro.userInterfaceStyle {
		case .light:
			return .hela
		case .dark:
			return .malhela
		case .unspecified:
			return .hela
		default:
			// Programtradukilo avertas ke pluajn valorojn povos aldoniĝi estontece
			// kaj rekomendas ke estu defaŭlta kazo
			return .hela
		}
	}
}

/// Havigas informojn pri la aparato, ekrano, ktp
protocol AparatInformo {
	/// La klaso de la aparato
	var aparatKlaso: AparatKlaso { get }
	
	/// La orientiĝo de la aparata ekrano
	var orientigho: Orientigho { get }
	
	/// La heleco de la interfaco
	var heleco: Heleco { get }
	
	/// Rilato inter logikaj bilderoj kaj aparataj. Vd. UIScreen.scale
	var skalo: CGFloat { get }
}

// MARK: - NunaAparato

/// AparatInformo kiu provizas informojn pri la nuna aparato
class NunaAparato: AparatInformo {
	/// Klaso de la uzata aparato
	var aparatKlaso: AparatKlaso {
		switch UIDevice.current.userInterfaceIdiom {
		case .phone:
			return .iFono
		case .pad:
			return .iPado
		default:
			return .iFono
		}
	}
	
	/// Nuna orientiĝo de la ekrano
	var orientigho: Orientigho {
		switch UIDevice.current.orientation {
		case .portrait, .portraitUpsideDown:
			return .vertikala
		case .landscapeLeft, .landscapeRight:
			return .horizontala
		default:
			return .vertikala
		}
	}
	
	/// Nuna heleco de la aparata interfaco
	var heleco: Heleco {
		Heleco.el(trajtaro: UITraitCollection.current)
	}
	
	/// Bildero-skalo de la aparato
	var skalo: CGFloat = UIScreen.main.scale
}
