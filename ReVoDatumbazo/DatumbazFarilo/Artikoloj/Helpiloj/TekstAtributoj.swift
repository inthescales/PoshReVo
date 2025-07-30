public enum TekstAtributo: CaseIterable, Equatable {
	case ligo(celo: String)
	case kursiva
	case grasa
	case supera
	case suba
	case ekzemplo
	case rimarko
	case tradukNumero
	
	public static var allCases: [TekstAtributo] {
		[.ligo(celo: ""), .kursiva, .grasa, .supera, .suba, .ekzemplo, .rimarko, .tradukNumero]
	}
	
	public var kodo: String {
		switch self {
		case .ligo:
			"a"
		case .kursiva:
			"k"
		case .grasa:
			"g"
		case .supera:
			"sup"
		case .suba:
			"sub"
		case .ekzemplo:
			"ekzemplo"
		case .rimarko:
			"rimarko"
		case .tradukNumero:
			"traduknumero"
		}
	}
	
	public init?(kodo: String) {
		switch kodo {
		case "k":
			self = .kursiva
		case "g":
			self = .grasa
		case "sup":
			self = .supera
		case "sub":
			self = .suba
		case "ekzemplo":
			self = .ekzemplo
		case "rimarko":
			self = .rimarko
		case "traduknumero":
			self = .tradukNumero
		default:
			return nil
		}
	}
	
	public init?(kodo: String, eco: String) {
		switch kodo {
		case "a":
			self = .ligo(celo: eco)
		default:
			return nil
		}
	}
	
	var ecoj: [(String, String)] {
		switch self {
		case .ligo(let celo):
			return [("href", celo)]
		default:
			return []
		}
	}
	
	// MARK: - Etikedoj
	
	public var malfermaEtikedo: String {
		let ecocheno = ecoj.map { " \($0.0)=\"\($0.1)\"" }.reduce("", +)
		return "<" + kodo + ecocheno + ">"
	}
	
	public var fermaEtikedo: String {
		return "</" + kodo + ">"
	}
	
	public static func volvi(tekston teksto: String, per atributo: TekstAtributo) -> String {
		return atributo.malfermaEtikedo + teksto + atributo.fermaEtikedo
	}
	
	// MARK: - Aliaj helpiloj
	
	/// Regula esprimo uzata por trovi etikedojn en artikolaj tekstoj
	public static var regulEsprimo: String {
		let etikedoListo = allCases.map { $0.kodo }.joined(separator: "|")
		let ecoListo = allCases.map { $0.ecoj.map { $0.0 } }.reduce([], +).joined(separator: "|")
		return "<(/?(" + etikedoListo + "))( (" + ecoListo + ")=\"(.*?)\")?>"
	}
}
