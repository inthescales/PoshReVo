enum NodTipo {
	case radiko
	case vortaro
	case art(mrk: String)
	case kap
	case rad
	case drv(mrk: String)
	case tld
	case snc
	case uzo(tip: String)
	case dif
	case ekz
	case fnt
	case bib
	case lok
	case vrk
	case klr(tip: String?)
	case ref(tip: String, cel: String)
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
		case "kap":
			return .kap
		case "rad":
			return .rad
		case "drv":
			return .drv(mrk: ecoj["mrk"]!)
		case "tld":
			return .tld
		case "snc":
			return .snc
		case "uzo":
			return .uzo(tip: ecoj["tip"]!)
		case "dif":
			return .dif
		case "ekz":
			return .ekz
		case "fnt":
			return .fnt
		case "bib":
			return .bib
		case "lok":
			return .lok
		case "vrk":
			return .vrk
		case "klr":
			return .klr(tip: ecoj["tip"])
		case "ref":
			return .ref(tip: ecoj["tip"]!, cel: ecoj["cel"]!)
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
