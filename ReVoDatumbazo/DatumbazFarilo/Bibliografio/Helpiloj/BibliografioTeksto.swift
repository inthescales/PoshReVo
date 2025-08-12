import Foundation

/// Helpiloj kiuj faras kaj formas tekstojn tiel kiel ĝi aperu en bibliografiaĵoj
/// Spegulas artikolaj klason 'ArtikolTeksto
enum BibliografioTeksto {
	/// Liveras priskriban ĉenon por la verko
	static func priskribi(verkon verko: Verko) -> String {
		var teksto = ""
		
		if let autoro = verko.autoro {
			teksto += autoro + "\\n"
		} else if let eldono = verko.eldono,
				  let nomo = eldono.nomo {
			teksto += nomo + "\\n"
		}
		
		if let tradukisto = verko.tradukisto {
			teksto += "trd. " + tradukisto + "\\n"
		}
		
		teksto += TekstAtributo.volvi(verko.titolo, per: .kursiva)
		
		if let eldono = verko.eldono,
		   let eldonDato = eldono.dato {
			teksto += "\\n" + eldonDato
		}
		
		return teksto.tondi().kunpremi()
	}
}
