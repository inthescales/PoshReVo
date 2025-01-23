/// Tipo de XML-nodo
/// Vidu priskribon de dokument-strukturo: https://revuloj.github.io/temoj/rnc
enum NodTipo {
	case radiko
	case vortaro
	case art(mrk: String)
	case subart
	case kap
	case mlg
	case vari
	case rad
	case ofc
	case drv(mrk: String)
	case tld(lit: String?)
	case gra
	case vspec
	case snc(mrk: String?)
	case subsnc
	case uzo(tip: String)
	case dif
	case ekz
	case rim
	case em
	case fnt
	case aut
	case bib
	case lok
	case vrk
	case nom
	case klr(tip: String?)
	case ref(tip: String?, cel: String)
	case refgrp(tip: String)
	case sncref(ref: String?)
	case trd(lng: String?)
	case trdgrp(lng: String)
	case pr
	case ind
	case url(ref: String)
	case teksto(String)
	
	static func el(nomo: String, ecoj: [String: String]) -> NodTipo? {
		switch nomo {
		case "vortaro":
			return .vortaro
		case "art":
			return .art(mrk: ecoj["mrk"]!)
		case "subart":
			return .subart
		case "kap":
			return .kap
		case "mlg":
			return .mlg
		case "var":
			return .vari
		case "rad":
			return .rad
		case "ofc":
			return .ofc
		case "drv":
			return .drv(mrk: ecoj["mrk"]!)
		case "tld":
			return .tld(lit: ecoj["lit"])
		case "gra":
			return .gra
		case "vspec":
			return .vspec
		case "snc":
			return .snc(mrk: ecoj["mrk"])
		case "subsnc":
			return .subsnc
		case "uzo":
			return .uzo(tip: ecoj["tip"]!)
		case "dif":
			return .dif
		case "ekz":
			return .ekz
		case "rim":
			return .rim
		case "em":
			return .em
		case "fnt":
			return .fnt
		case "aut":
			return .aut
		case "bib":
			return .bib
		case "lok":
			return .lok
		case "vrk":
			return .vrk
		case "nom":
			return .nom
		case "klr":
			return .klr(tip: ecoj["tip"])
		case "ref":
			return .ref(tip: ecoj["tip"] ?? nil, cel: ecoj["cel"]!)
		case "refgrp":
			return .refgrp(tip: ecoj["tip"]!)
		case "sncref":
			return .sncref(ref: ecoj["ref"])
		case "trd":
			return .trd(lng: ecoj["lng"])
		case "trdgrp":
			return .trdgrp(lng: ecoj["lng"]!)
		case "pr":
			return .pr
		case "ind":
			return .ind
		case "url":
			return .url(ref: ecoj["ref"]!)
		case "teksto":
			return .teksto(ecoj["teksto"]!)
		default:
			return nil
		}
	}
}

class ArtikolNodo {
	let tipo: NodTipo
	var filoj: [ArtikolNodo]
	
	init?(nomo: String, ecoj: [String: String] = [:]) {
		guard let tipo = NodTipo.el(nomo: nomo, ecoj: ecoj) else {
			return nil
		}
		
		self.tipo = tipo
		self.filoj = []
	}
	
	init(tipo: NodTipo) {
		self.tipo = tipo
		self.filoj = []
	}
}
