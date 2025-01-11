import ReVoModelojOSX

// MARK: - Modeloj

struct SubartikoloFabriko {
	var teksto = ""
	var vortoj: [Vorto] = []
	
	func fabriki() -> Subartikolo? {
		if !vortoj.isEmpty {
			return Subartikolo(
				teksto: teksto,
				vortoj: vortoj
			)
		}
		
		return nil
	}
}

struct VortoFabriko {
	var titolo: String?
	var teksto: String?
	var marko: String?
	var ofc: String?
	
	func fabriki() -> Vorto? {
		if let titolo = titolo,
		   let teksto = teksto {
			return Vorto(
				titolo: titolo,
				teksto: teksto,
				marko: marko,
				ofc: ofc
			)
		}
		
		return nil
	}
}

struct ArtikolFabriko {
	var titolo: String?
	var radiko: String?
	var indekso: String?
	var ofc: String?
	var subartikoloj: [Subartikolo] = []
	var tradukoj: [Traduko]?
	
	func fabriki() -> Artikolo? {
		if let titolo = titolo,
		   let radiko = radiko,
		   let indekso = indekso,
		   !subartikoloj.isEmpty {
			return Artikolo(
				titolo: titolo,
				radiko: radiko,
				indekso: indekso,
				ofc: ofc,
				subartikoloj: subartikoloj,
				tradukoj: tradukoj ?? []
			)
		} else {
			assert(false, "Ni vidu ĉu ĉi tio okazos")
		}
	}
}

class Stato {
	var artikolFabriko = ArtikolFabriko()
	var subartikoloFabriko: SubartikoloFabriko?
	var vortoFabriko: VortoFabriko?
	
	var bufro: String = ""
	var cheno: [NodTipo] = []
	
	func nuligiBufron() {
		bufro = ""
	}
	
	func konsumiBufron() {
		if vortoFabriko != nil {
			if vortoFabriko?.teksto == nil {
				vortoFabriko?.teksto = ""
			}
			vortoFabriko?.teksto? += bufro.kunpremi(" ")
		} else if subartikoloFabriko != nil {
			subartikoloFabriko?.teksto += bufro.kunpremi(" ")
		}
		
		nuligiBufron()
	}
	
	func spaciBufron() {
		let krampoj = ["(", "{", "[", "<"]
		let spacoj = [" "]
		if !bufro.isEmpty
			&& !krampoj.contains(String(bufro.last!))
			&& !spacoj.contains(String(bufro.last!)) {
			bufro += " "
		}
	}
}

// MARK: - Nod-traktado

func kreiArtikolon(el arbo: ArtikolNodo, indekso: String) -> Artikolo {
	let stato = Stato()
	stato.artikolFabriko.indekso = indekso
	
	traktiFilojn(de: arbo, stato: stato)
	
	return stato.artikolFabriko.fabriki()!
}

func trakti(nodon nodo: ArtikolNodo, stato: Stato) {
	switch nodo.tipo {
	case .radiko:
		break
	case .vortaro:
		trakti(vortaron: nodo, stato: stato)
	case .art:
		trakti(artikolon: nodo, stato: stato)
	case .kap:
		trakti(kapon: nodo, stato: stato)
	case .rad:
		trakti(radikon: nodo, stato: stato)
	case .drv(mrk: let mrk):
		trakti(derivajhon: nodo, stato: stato)
	case .tld:
		traktiTildon(stato: stato)
	case .snc:
		trakti(sencon: nodo, stato: stato)
	case .uzo(tip: let tip):
		trakti(uzon: nodo, stato: stato)
	case .dif:
		trakti(difinon: nodo, stato: stato)
	case .ekz:
		trakti(ekzemplon: nodo, stato: stato)
	case .fnt, .bib, .lok, .vrk:
		// Forigas spacojn ĉirkaŭ nevideblaj elementoj
		stato.bufro = stato.bufro.tondi()
		break
	case .klr(tip: let tip):
		break
	case .ref(tip: let tip, cel: let cel):
		trakti(referencon: nodo, tipo: tip, celo: cel, stato: stato)
	case .trd(lng: let lng):
		break
	case .trdgrp(lng: let lng):
		break
	case .pr:
		break
	case .ind:
		break
	case .url(ref: let ref):
		trakti(URLon: nodo, stato: stato)
	case .teksto(let teksto):
		let preparita = prepari(tekston: teksto)
		
		if !preparita.isEmpty {
			stato.bufro += preparita
		}
	}
}

func traktiFilojn(de nodo: ArtikolNodo, stato: Stato) {
	stato.cheno.append(nodo.tipo)
	
	for filo in nodo.filoj {
		trakti(nodon: filo, stato: stato)
	}
	
	_ = stato.cheno.popLast()
}

func trakti(vortaron vortaro: ArtikolNodo, stato: Stato) {
	traktiFilojn(de: vortaro, stato: stato)
}

func trakti(artikolon artikolo: ArtikolNodo, stato: Stato) {
	traktiFilojn(de: artikolo, stato: stato)
	
	if stato.subartikoloFabriko != nil {
		let novaSubartikolo = stato.subartikoloFabriko?.fabriki()
		stato.artikolFabriko.subartikoloj.append(novaSubartikolo!)
	}
}

func trakti(kapon kapo: ArtikolNodo, stato: Stato) {
	traktiFilojn(de: kapo, stato: stato)
	
	switch stato.cheno.last {
	case .art:
		stato.artikolFabriko.titolo = stato.bufro
	case .drv:
		stato.vortoFabriko?.titolo = stato.bufro
	default:
		break
	}
	
	stato.nuligiBufron()
}

func trakti(radikon radiko: ArtikolNodo, stato: Stato) {
	traktiFilojn(de: radiko, stato: stato)
	
	stato.artikolFabriko.radiko = stato.bufro.tondi()
}

func trakti(derivajhon derivajho: ArtikolNodo, stato: Stato) {
	stato.vortoFabriko = VortoFabriko()
	if case .drv(let marko) = derivajho.tipo {
		stato.vortoFabriko?.marko = marko
	}
	
	traktiFilojn(de: derivajho, stato: stato)
	
	if stato.subartikoloFabriko == nil {
		stato.subartikoloFabriko = SubartikoloFabriko()
	}
	
	let novaVorto = stato.vortoFabriko?.fabriki()
	stato.subartikoloFabriko?.vortoj.append(novaVorto!)
}

func trakti(sencon senco: ArtikolNodo, stato: Stato) {
	if !(stato.vortoFabriko?.teksto?.isEmpty ?? false) {
		stato.bufro = "\n\n" + stato.bufro
	}
	
	traktiFilojn(de: senco, stato: stato)

	stato.bufro = stato.bufro.tondi()
	stato.konsumiBufron()
}

func trakti(difinon difino: ArtikolNodo, stato: Stato) {
	traktiFilojn(de: difino, stato: stato)
}

func trakti(ekzemplon ekzemplo: ArtikolNodo, stato: Stato) {
	stato.spaciBufron()
	stato.bufro += "<i>"
	stato.konsumiBufron()
	
	traktiFilojn(de: ekzemplo, stato: stato)
	
	stato.bufro = stato.bufro.tondi()
	stato.bufro += "</i>"
}

func trakti(referencon referenco: ArtikolNodo, tipo: String, celo: String, stato: Stato) {
	// FARENDA: Aldoni simbolojn
	// TODO: Add symbols
	if case .dif = stato.cheno.last {} else { stato.bufro += "\n" }
	
	stato.bufro += "<a href=\"\(celo)\">"
	traktiFilojn(de: referenco, stato: stato)
	stato.bufro += "</a>"
}

func traktiTildon(stato: Stato) {
	if case .ekz = stato.cheno.last {
		stato.spaciBufron()
		stato.bufro += "<b>"
	}
	
	if let radiko = stato.artikolFabriko.radiko {
		stato.bufro += radiko
	}
	
	if case .ekz = stato.cheno.last {
		stato.bufro += "</b>"
	}
	
}

func trakti(uzon uzo: ArtikolNodo, stato: Stato) {
	if case .uzo(let tipo) = uzo.tipo {
		if tipo == "fak" {
			stato.spaciBufron()
			stato.bufro += "["
		}
	}
	
	traktiFilojn(de: uzo, stato: stato)
	
	if case .uzo(let tipo) = uzo.tipo {
		if tipo == "fak" {
			stato.bufro += "] "
		}
	}
}

func trakti(URLon url: ArtikolNodo, stato: Stato) {
	if case .url(let ref) = url.tipo {
		stato.spaciBufron()
		stato.bufro += "<a href=\(ref)>"
		traktiFilojn(de: url, stato: stato)
	}
}

// MARK: - Tekstaj helpiloj

func prepari(tekston teksto: String) -> String {
	var rezulto = teksto.replacingOccurrences(of: "\n", with: " ")
	rezulto = rezulto.replacingOccurrences(of: "\r", with: " ")
	rezulto = rezulto.replacingOccurrences(of: "\t", with: "")
	rezulto = rezulto.replacingOccurrences(of: "<em>", with: "<b>")
	rezulto = rezulto.replacingOccurrences(of: "</em>", with: "</b>")
	rezulto = rezulto.replacingOccurrences(of: "...", with: "…")
	
	return rezulto
}

extension String {
	func tondi() -> String {
		return self.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	func kunpremi(_ simbolo: Character) -> String {
		var rezulto = ""
		
		var lasta: Character? = nil
		for char in self {
			if char == simbolo,
			   char == lasta {
				continue
			} else {
				rezulto += String(char)
				lasta = char
			}
		}
		
		return rezulto
	}
}

