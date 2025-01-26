/// Tipo de XML-nodo
/// Vidu priskribon de dokument-strukturo: https://revuloj.github.io/temoj/rnc
enum NodTipo {
	case adm
	case arbo
	case art(mrk: String)
	case aut
	case baz
	case bib
	case bld
	case ctl
	case dif
	case drv(mrk: String)
	case esc
	case ekz
	case em
	case fnt
	case frm
	case gra
	case ind
	case k
	case kap
	case ke
	case klr(tip: String?)
	case lok
	case mlg
	case nac
	case nom
	case ofc
	case pr
	case rad(vari: String?)
	case ref(tip: String?, cel: String)
	case refgrp(tip: String)
	case rim
	case snc(mrk: String?)
	case sncref(ref: String?)
	case sub
	case subart
	case subsnc(mrk: String?)
	case sup
	case teksto(String)
	case tezrad
	case tld(lit: String?, vari: String?)
	case trd(lng: String?)
	case trdgrp(lng: String)
	case url(ref: String)
	case uzo(tip: String)
	case vari
	case vortaro
	case vrk
	case vspec
	
	static func el(nomo: String, ecoj: [String: String]) -> NodTipo? {
		switch nomo {
		case "adm":
			return .adm
		case "art":
			return .art(mrk: ecoj["mrk"]!)
		case "aut":
			return .aut
		case "baz":
			return .baz
		case "bib":
			return .bib
		case "bld":
			return .bld
		case "ctl":
			return .ctl
		case "dif":
			return .dif
		case "drv":
			return .drv(mrk: ecoj["mrk"]!)
		case "esc":
			return .esc
		case "ekz":
			return .ekz
		case "em":
			return .em
		case "fnt":
			return .fnt
		case "frm":
			return .frm
		case "gra":
			return .gra
		case "ind":
			return .ind
		case "k":
			return .k
		case "kap":
			return .kap
		case "ke":
			return .ke
		case "klr":
			return .klr(tip: ecoj["tip"])
		case "lok":
			return .lok
		case "mlg":
			return .mlg
		case "nac":
			return .nac
		case "nom":
			return .nom
		case "ofc":
			return .ofc
		case "pr":
			return .pr
		case "rad":
			return .rad(vari: ecoj["var"])
		case "ref":
			return .ref(tip: ecoj["tip"] ?? nil, cel: ecoj["cel"]!)
		case "refgrp":
			return .refgrp(tip: ecoj["tip"]!)
		case "rim":
			return .rim
		case "snc":
			return .snc(mrk: ecoj["mrk"])
		case "sncref":
			return .sncref(ref: ecoj["ref"])
		case "sub":
			return .sub
		case "subsnc":
			return .subsnc(mrk: ecoj["mrk"])
		case "subart":
			return .subart
		case "sup":
			return .sup
		case "teksto":
			return .teksto(ecoj["teksto"]!)
		case "tezrad":
			return .tezrad
		case "tld":
			return .tld(lit: ecoj["lit"], vari: ecoj["var"])
		case "trd":
			return .trd(lng: ecoj["lng"])
		case "trdgrp":
			return .trdgrp(lng: ecoj["lng"]!)
		case "url":
			return .url(ref: ecoj["ref"]!)
		case "uzo":
			return .uzo(tip: ecoj["tip"]!)
		case "var":
			return .vari
		case "vortaro":
			return .vortaro
		case "vrk":
			return .vrk
		case "vspec":
			return .vspec
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
