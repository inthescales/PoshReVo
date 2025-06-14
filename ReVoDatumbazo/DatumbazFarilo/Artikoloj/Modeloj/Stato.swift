import Foundation

extension ArboAnalizilo {
	/// Stato de artikol-traktado
	final class Stato {
		init(lingvoj: [String: Lingvo], stiloj: [String: String]) {
			self.lingvoj = lingvoj
			self.stiloj = stiloj
		}
		
		/// Fabriko kiu fabrikos la nune traktatan artikolon
		var artikolFabriko = ArtikolFabriko()
		
		// MARK: Grundaĵoj
		
		/// Lingvoj laŭ iliaj kodoj
		let lingvoj: [String: Lingvo]
		
		/// Stilaj tekstoj kaj iliaj kodoj
		let stiloj: [String: String]
		
		// MARK: Artikol-informoj
		
		/// La radiko de la nune traktata artikolo
		var artikolRadiko: String? {
			artikolFabriko.radiko
		}
		
		/// Variaĵoj de la nuna radiko
		var artikolRadikVariajhoj: [String: String] = [:]
		
		/// La nomo de la nune traktata artikolo, kiel ĝi aperos paĝ-kape
		var artikolNomo: String? {
			artikolFabriko.titolo
		}
		
		/// La indekso de la nune traktata artikolo
		var artikolIndekso: String? {
			artikolFabriko.indekso
		}
		
		// MARK: Arbo-tradirada stato
		
		/// Stako enhavanta la nod-tipojn de la ĉi-nodaj patroj
		var cheno: [NodTipo] = []
		
		/// Stako enhavanta la nod-tipojn de la lastaj siboj
		var sibStako: [NodTipo?] = []
		
		/// Titolo de nuna derivaĵo, plenteksta, kiel ĝi aperu en serĉrezultoj
		var derivajhNomo: String?
		
		/// Ĉiuj individuaj formoj de la nomo de la derivaĵo
		var derivajhFormoj: [String] {
			derivajhNomo.flatMap { ArtikolTeksto.kapFormoj(por: $0) } ?? []
		}
		
		/// Titolo de nuna derivaĵo, kun ~-oj, kiel ĝi aperu en tradukoj
		var derivajhTildo: String?
		
		/// Numero de la lasta subderivaĵo, se tio ekzistas
		var lastaSubderivajho: Int?
		
		/// Numero de la nuna subderivaĵo, se trairado enas subderivaĵon
		var nunaSubderivajho: Int?
		
		/// Numero de la lasta senco traktita en la derivaĵo (eĉ si la procezo jam eliris el ĉiuj sencoj)
		/// Necesas por nombri la sencojn (endas scii la lastan senc-numeron).
		var lastaSenco: Int?
		
		/// Numero de la *nuna* senco en sia derivaĵo. Havas valoron nur se la procezo estas nun ene de iu senco.
		/// Necesas por ke ni sciu ĉu la procezo ankoraŭ estas ene de senco, aŭ ĉu ĝi jam eliras (ekz. kiam ni renkontas tradukon post ĉiuj sencoj en derivaĵo)
		var nunaSenco: Int?
		
		/// Samkiel `lastaSenco` je subsencoj
		var lastaSubsenco: Int?
		
		/// Samkiel `nunaSenco` je subsencoj
		var nunaSubsenco: Int?
		
		/// La plej proksima supera marko de la nuna trairad-loko
		var marko: String? {
			for tipo in cheno.reversed() {
				switch tipo {
				case .art(let mrk):
					return mrk
				case .drv(let mrk):
					return mrk
				default:
					continue
				}
			}
			
			return nil
		}
		
		/// Por ĉiu marko kiu aperas en senco, la numero de tiu senco (por resolvi 'sncref'-ojn)
		var markSencoj: [String: Int] = [:]
		
		// MARK: Tradukoj kaj vortlisteroj
		
		/// Ĝisnunaj ĉi-derivaĵaj tradukoj
		var derivajhTradukoj: [String: [ArtikolTraduko]] = [:]
		// TODO: Testi ĉu aro necesas, aŭ ĉu lingvoj havas nur unu traduko po derivaĵo
		
		/// Ĉiuj jam-konstruitaj serĉtradukoj
		var serchTradukoj: [String: [SerchTraduko]] = [:]
		
		/// Ĉiujn sercheblaj esperantaj vortoj aŭ derivaĵoj
		var serchVortoj: [SerchVorto] = []
		
		/// Ĉiuj fakaj vortoj, laŭ iliaj fakoj
		var fakVortoj: [String: [FakVorto]] = [:]
		
		/// Vortoj laŭ oficialeco
		var ofcVortoj: [Oficialeco: [OfcVorto]] = [:]
		
		/// Aldonas serĉtradukon
		func aldoni(derivajhTradukon traduko: ArtikolTraduko, lingvo: String) {
			if derivajhTradukoj[lingvo] == nil { derivajhTradukoj[lingvo] = [] }
			
			if traduko.senco != nil {
				derivajhTradukoj[lingvo]?.append(traduko)
			} else {
				let indekso = derivajhTradukoj[lingvo]?.firstIndex(where: { $0.senco != nil }) ?? 0
				derivajhTradukoj[lingvo]?.insert(traduko, at: indekso)
			}
		}
		
		/// Aldonas serĉtradukon
		func aldoni(serchTradukon traduko: SerchTraduko, lingvo: String) {
			if serchTradukoj[lingvo] == nil { serchTradukoj[lingvo] = [] }
			serchTradukoj[lingvo]?.append(traduko)
		}
		
		/// Aldonas serĉvorton
		func aldoni(serchVorton vorto: SerchVorto) {
			serchVortoj.append(vorto)
		}
		
		/// Aldonas fakvorton
		func aldoni(fakVorton fakVorto: FakVorto, fako: String) {
			if fakVortoj[fako] == nil { fakVortoj[fako] = [] }
			fakVortoj[fako]?.append(fakVorto)
		}
		
		/// Aldonas ofcvorton
		func aldoni(ofcVorton ofcVorto: OfcVorto, oficialeco: Oficialeco) {
			if ofcVortoj[oficialeco] == nil { ofcVortoj[oficialeco] = [] }
			ofcVortoj[oficialeco]?.append(ofcVorto)
		}
	}
}
