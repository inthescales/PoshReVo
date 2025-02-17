import Foundation
import CoreData

#if os(iOS)
import ReVoModeloj
#elseif os(macOS)
import ReVoModelojOSX
#endif

/// Indekso kiu kondukas al loko en artikolo kaj priskribaj informoj, kiu povos aperi en listo
public struct Destino {
	/// Nomo kiu aperos en serĉrezulto, vortolisto, ktp.
    public let teksto: String
	
	/// Subteksto kiu aperos flanke en listo
    public let subTeksto: String?
	
	/// Indekso de la artikolo
    public let indekso: String
	
	/// Marko ene de artikolo (pli ofte je derivaĵo)
    public let marko: String?
	
	/// Senco ene artikolero
    public let senco: String?
	
	/// Datumbazobjekto de la artikolo
	let artikolObjekto: NSManagedObject
    
	public init(
		teksto: String,
		subTeksto: String,
		indekso: String,
		marko: String?,
		senco: String?,
		artikolObjekto: NSManagedObject
	) {
		self.teksto = teksto
		self.subTeksto = subTeksto
		self.indekso = indekso
		self.marko = marko
		self.senco = senco
		self.artikolObjekto = artikolObjekto
	}
	
    public init?(objekto: NSManagedObject) {
        guard let artikolObjekto = objekto.value(forKey: "artikolo") as? NSManagedObject,
			  let teksto = objekto.value(forKey: "teksto") as? String,
			  let indekso = objekto.value(forKey: "indekso") as? String else {
                return nil
        }
		
		// Nomo nur necesas se montriĝos subtitolon
		let subTeksto = objekto.value(forKey: "nomo") as? String
		let marko = objekto.value(forKey: "marko") as? String
		let senco = objekto.value(forKey: "senco") as? String
		
		self.teksto = teksto
		self.subTeksto = subTeksto
		self.indekso = indekso
        self.marko = marko
        self.senco = senco
		self.artikolObjekto = artikolObjekto
    }

	/// Kreas artikol-modelon, uzanta grund-informoj el la vortaro
    public func artikolo(enVortaro vortaro: VortaroDatumbazo) -> Artikolo? {
        return Artikolo.elDatumbazObjekto(objekto: artikolObjekto, datumbazo: vortaro)
    }
}

// MARK: - Equatable

extension Destino: Equatable {
    public static func ==(lhs: Destino, rhs: Destino) -> Bool {
        return lhs.teksto == rhs.marko &&
            lhs.subTeksto == rhs.subTeksto &&
            lhs.indekso == rhs.indekso &&
            lhs.marko == rhs.marko &&
            lhs.senco == rhs.senco &&
            lhs.artikolObjekto == rhs.artikolObjekto
    }
}

// MARK: - Comparable

extension Destino: Comparable {
    public static func < (lhs: Destino, rhs: Destino) -> Bool {
        return lhs.teksto.compare(rhs.teksto, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
    }
}
