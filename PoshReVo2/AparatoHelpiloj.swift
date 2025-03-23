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

/// Helpiloj je la uzata aparato
enum Aparato {
	/// Klaso de la uzata aparato
	static var aparatKlaso: AparatKlaso {
		switch UIDevice.current.userInterfaceIdiom {
		case .phone:
			return .iFono
		case .pad:
			return .iPado
		default:
			// Ĉi tio espereble neniam okazos
			assert(false, "Nokonata aparat-klaso")
			return .iFono
		}
	}
	
	/// Nuna orientiĝo de la ekrano
	static var orientigho: Orientigho {
		switch UIDevice.current.orientation {
		case .portrait, .portraitUpsideDown:
			return .vertikala
		case .landscapeLeft, .landscapeRight:
			return .horizontala
		default:
			// Ĉi tio espereble neniam okazos
			assert(false, "Nokonata aparat-klaso")
			return .vertikala
		}
	}
	
	/// Porcio de la tuta larĝo de la ekrano kiu estu uzata
	static var larghoPorcio: Double {
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
}
