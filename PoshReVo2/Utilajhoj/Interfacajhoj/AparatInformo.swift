import UIKit

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

enum Stilo {
	case hela
	case malhela
	
	static func el(trajtaro: UITraitCollection) -> Stilo {
		switch trajtaro.userInterfaceStyle {
		case .light:
			return .hela
		case .dark:
			return .malhela
		default:
			// Ĉi tio espereble neniam okazos
			assert(false, "Nekonata stilo")
			return .hela
		}
	}
}

/// Havigas informojn pri la aparato, ekrano, ktp
protocol AparatInformo {
	var aparatKlaso: AparatKlaso { get }
	var orientigho: Orientigho { get }
	var stilo: Stilo { get }
	
	/// Rilato inter logikaj bilderoj kaj aparataj. Vd. UIScreen.scale
	var skalo: CGFloat { get }
}

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
			// Ĉi tio espereble neniam okazos
			assert(false, "Nekonata aparat-klaso")
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
			// Ĉi tio espereble neniam okazos
			assert(false, "Nekonata orientiĝo")
			return .vertikala
		}
	}
	
	// TODO: Uzu ĉi tio
	/// Porcio de la tuta larĝo de la ekrano kiu estu uzata
	var larghoPorcio: Double {
		switch aparatKlaso {
		case .iFono:
			return 1.0
		case .iPado:
			switch orientigho {
			case .vertikala:
				return 0.8
			case .horizontala:
				return 0.6
			}
		}
	}
	
	var stilo: Stilo {
		Stilo.el(trajtaro: UITraitCollection.current)
	}
	
	var skalo: CGFloat = UIScreen.main.scale
}
