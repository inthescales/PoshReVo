import Foundation
import CoreData

/// Indekso kiu kondukas al loko en artikolo kiun priskribaj informoj.
/// Aperos en vortlistoj kaj serĉrezultoj.
public struct Destino {
	/// Nomo kiu aperos en serĉrezulto, vortolisto, ktp.
    public let teksto: String
	
	/// Subteksto kiu aperos flanke en listo
    public let subteksto: String?
	
	/// Marko ene de artikolo (pli ofte je derivaĵo)
    public let marko: String?
	
	/// Senco ene artikolero
    public let senco: String?
	
	/// Datumbazobjekto de la artikolo
	let artikolObjekto: NSManagedObject
    
	public init(
		teksto: String,
		subTeksto: String?,
		marko: String?,
		senco: String?,
		artikolObjekto: NSManagedObject
	) {
		self.teksto = teksto
		self.subteksto = subTeksto
		self.marko = marko
		self.senco = senco
		self.artikolObjekto = artikolObjekto
	}
	
	/// Skribas destinon en datumbazon
	public func skribi(en konteksto: NSManagedObjectContext) -> NSManagedObject {
		let novaObjekto = NSEntityDescription.insertNewObject(forEntityName: "Destino", into: konteksto)
		novaObjekto.setValue(teksto, forKey: "teksto")
		novaObjekto.setValue(subteksto, forKey: "subteksto")
		novaObjekto.setValue(marko, forKey: "marko")
		novaObjekto.setValue(senco, forKey: "senco")
		novaObjekto.setValue(artikolObjekto, forKey: "artikolo")
		
		return novaObjekto
	}
	
	/// Krei Destinon el datumbazobjekto
    public init?(objekto: NSManagedObject) {
        guard let artikolObjekto = objekto.value(forKey: "artikolo") as? NSManagedObject,
			  let teksto = objekto.value(forKey: "teksto") as? String else {
                return nil
        }
		
		let subTeksto = objekto.value(forKey: "subteksto") as? String
		let marko = objekto.value(forKey: "marko") as? String
		let senco = objekto.value(forKey: "senco") as? String
		
		self.teksto = teksto
		self.subteksto = subTeksto
        self.marko = marko
        self.senco = senco
		self.artikolObjekto = artikolObjekto
    }
}

// MARK: - Comparable

extension Destino: Comparable {
    public static func < (lhs: Destino, rhs: Destino) -> Bool {
        return lhs.teksto.compare(
			rhs.teksto,
			options: .caseInsensitive,
			range: nil,
			locale: Locale(identifier: "eo")
		) == .orderedAscending
    }
}
