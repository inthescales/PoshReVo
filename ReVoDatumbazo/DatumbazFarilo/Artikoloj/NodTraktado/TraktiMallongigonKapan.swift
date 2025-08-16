extension ArboAnalizilo {
	// TODO: Konsideri trakti ĉi tiajn mallongigojn
	
	/// Kapmallongigojn (<mlg>) mi ne klopodas nun trakti.
	/// Per ĉi tiu metodo ni ignoru ilin, por ke tekstoj ne estu fuŝitaj pro ĉirkaŭaj linisaltoj
	static func ignoriKapanMallongigon(teksto: String, stato: Stato) -> String {
		// TODO: Eble unuigi kun ignori(fonton:...) se ili daŭre restos same
		let lastaSibo = stato.sibStako.last ?? nil
		switch lastaSibo {
		case .fnt:
			// Fonto jam devas esti ignorata
			// vd. Oriono
			return teksto
		case .mlg:
			// Antaŭa <mlg> jam estas traktinta la aferon
			// vc. leon/o
			return teksto
		case .uzo:
			// Lasu spacon post uzo
			// vd. Kipro
			return teksto
		case nil:
			// Ĉe nil nenio farendas
			// vd. Dominiko
			return teksto
		default:
			// Estas kazoj en kiu ĉi metodo devus fortondi spacojn tiel kiel
			// ignori(fonton:...). Tamen, tiuj kazoj ne efektiviĝas nuntempe en
			// la datumbazo — do sufiĉas nun ke ignori(fonton:...) fidas ke ĉi metodo
			// tondus se necesus, kaj ne trotondas kiam ĝi sekvas <mlg>
			assert(false, "Neatendita antaŭaĵo")
			return teksto.tondi()
		}
	}
}
