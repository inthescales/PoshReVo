import UIKit

/// Fasada stilo por la apo
class InterfacStilo {
	// Noto: Nun, ĉi klaso nur enhavas kolorojn. Estontece, se aliaj interfacstilaĵoj agordeblos,
	// konsideru dividon de ĉi klaso en pluraj, ligitaj per enhavanta 'InterfacStilo'
	
	// MARK: - Ecoj
	
	/// Nomo kiun vidos la uzanto en agordoj
	let nomo: String
	
	/// Interna identiga nomo, kiu estos skribata al uzantdatumoj
	let identigilo: String
	
	/// Hela variaĵo
	private var hela: Koloraro
	
	/// Malhela variaĵo
	private var malhela: Koloraro
	
	// MARK: - Koloroj
	
	lazy var navigaciaFono = UIColor(hela: hela.navigaciaFono, malhela: malhela.navigaciaFono)
	lazy var navigaciaButono = UIColor(hela: hela.navigaciaButono, malhela: malhela.navigaciaButono)
	lazy var navigaciaButonoMalaktiva = UIColor(hela: hela.navigaciaButonoMalaktiva, malhela: malhela.navigaciaButonoMalaktiva)
	lazy var navigaciaSerchilo = UIColor(hela: hela.navigaciaSerchilo, malhela: malhela.navigaciaSerchilo)
	lazy var navigaciaTeksto = UIColor(hela: hela.navigaciaTeksto, malhela: malhela.navigaciaTeksto)
	lazy var dokumentaFono = UIColor(hela: hela.dokumentaFono, malhela: malhela.dokumentaFono)
	lazy var dokumentaAlternaFono = UIColor(hela: hela.dokumentaAlternaFono, malhela: malhela.dokumentaAlternaFono)
	lazy var dokumentaTeksto = UIColor(hela: hela.dokumentaTeksto, malhela: malhela.dokumentaTeksto)
	lazy var dokumentaMalfortaTeksto = UIColor(hela: hela.dokumentaMalfortaTeksto, malhela: malhela.dokumentaMalfortaTeksto)
	lazy var dokumentaDividilo = UIColor(hela: hela.dokumentaDividilo, malhela: malhela.dokumentaDividilo)
	lazy var dokumentLigilo = UIColor(hela: hela.dokumentLigilo, malhela: malhela.dokumentLigilo)
	lazy var dokumentEkzemplo = UIColor(hela: hela.dokumentEkzemplo, malhela: malhela.dokumentEkzemplo)
	lazy var dokumentRimarko = UIColor(hela: hela.dokumentRimarko, malhela: malhela.dokumentRimarko)
	lazy var menuoFono = UIColor(hela: hela.menuoFono, malhela: malhela.menuoFono)
	lazy var ombro = UIColor(hela: hela.ombro, malhela: malhela.ombro)
	
	// MARK: - Valorizado
	
	init(nomo: String, identigilo: String, hela: Koloraro, malhela: Koloraro) {
		self.nomo = nomo
		self.identigilo = identigilo
		self.hela = hela
		self.malhela = malhela
	}
	
	// MARK: - Alirado
	
	/// Liveras stilon havantan certan nomon, se ĝi ekzistas
	static func kun(nomo: String) -> InterfacStilo? {
		return .chiuj.first(where: { stilo in stilo.nomo == nomo })
	}
	
	/// Defaŭlta stilo - uzata ĉe nove instalata apo, kaj se alia stilo ne troviĝas
	static var defaulta: InterfacStilo = .pergamena
	
	/// Ĉiuj elekteblaj stiloj
	static var chiuj: [InterfacStilo] = [
		.klara,
		.pergamena
	]
}
