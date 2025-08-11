enum BibliografioNodTipo {
	case a
	case ald
	case arbo
	case aut
	case bibliografio
	case dat
	case eld
	case isbn
	case lok
	case n
	case nom
	case nro
	case teksto(String)
	case tit
	case trd
	case vrk(mll: String, tip: String?)
	case url
	
	static func el(nomo: String, ecoj: [String: String]) -> BibliografioNodTipo? {
		switch nomo {
		case "a":
			return .a
		case "ald":
			return .ald
		case "aut":
			return .aut
		case "bibliografio":
			return .bibliografio
		case "dat":
			return .dat
		case "eld":
			return .eld
		case "isbn":
			return .isbn
		case "lok":
			return .lok
		case "n":
			return .n
		case "nom":
			return .nom
		case "nro":
			return .nro
		case "tit":
			return .tit
		case "trd":
			return .trd
		case "vrk":
			return .vrk(mll: ecoj["mll"]!, tip: ecoj["tip"])
		case "url":
			return .url
		default:
			assert(false, "neatendita bibliografia nodo")
		}
	}
}
