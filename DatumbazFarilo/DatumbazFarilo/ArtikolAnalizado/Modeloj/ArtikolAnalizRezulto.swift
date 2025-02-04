import ReVoModelojOSX

/// Rezulto de analizo de artikol-dokumento.
struct ArtikolAnalizRezulto {
	/// Ĉiuj datumoj per kiu artikolo estos prezentata
	let artikolo: Artikolo
	
	/// Tradukoj kiuj estos serĉeblaj
	let serchTradukoj: [String: [SerchTraduko]]
	
	/// Markoj kaj siaj kunligitaj sencoj
	let markSencoj: [String: Int]
}
