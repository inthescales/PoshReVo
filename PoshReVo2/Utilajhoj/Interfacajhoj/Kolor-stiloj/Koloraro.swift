import UIKit

/// Aro da koloroj sufiĉaj por tute kolorigi la apon
struct Koloraro {
	// MARK: - Navigaciejaj Koloroj
	
	/// Fonkoloro ĉe la navigaciejo
	var navigaciaFono: UIColor
	
	/// Tekstkoloro ĉe la navigaciejo
	var navigaciaTeksto: UIColor
	
	/// Koloro de butonoj en la navigaciejo
	var navigaciaButono: UIColor
	
	/// Koloroj de premeblaj objektoj en la navigacejo, kiuj ne estas aktivaj
	/// Ĉefe uzata en la lingvobreto
	var navigaciaButonoMalaktiva: UIColor
	
	// MARK: - Dokumentaj Koloroj
	
	/// Fonkoloro de dokumentoj — vortlistoj, artikoloj, informtekstoj, ks.
	var dokumentaFono: UIColor
	
	/// Alterna fonkoloro en dokumentoj, ekz. en plurmembra listo da tradukoj
	var dokumentaAlternaFono: UIColor
	
	/// Tekstkoloro en dokumentoj
	var dokumentaTeksto: UIColor
	
	/// Malforta tekstkoloro en dokumentoj — nottekstoj en malplenaj listoj, aviztekstoj kiam neniuj tradukoj estas, ks.
	var dokumentaMalfortaTeksto: UIColor
	
	/// Dividilo inter sekcioj en dokumentoj
	var dokumentaDividilo: UIColor
	
	/// Ligiloj aperantaj en dokumentoj
	var dokumentLigilo: UIColor
	
	// MARK: - Artikolaj Koloroj
	
	/// Koloro de ekzemploj en artikoloj
	var dokumentEkzemplo: UIColor
	
	/// Koloro de rimarkoj en artikoloj
	var dokumentRimarko: UIColor
	
	// MARK: - Aliaj
	
	var ombro: UIColor
}
