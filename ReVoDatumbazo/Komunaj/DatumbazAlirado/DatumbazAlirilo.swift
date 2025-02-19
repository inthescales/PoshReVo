import Foundation
import CoreData

/// Rekte aliras datumbazon, farante ĉiajn petojn kaj liverante NSManagedObject-ojn
final class DatumbazAlirilo {
    private let konteksto: NSManagedObjectContext
    
    init(konteksto: NSManagedObjectContext) {
        self.konteksto = konteksto
    }
    
	// MARK: - Kolektojn de ĉiuj datumbazeroj de certa speco
	
	/// Ĉiuj lingvoj
	lazy var chiujLingvoj: [NSManagedObject] = {
		let serchPeto = NSFetchRequest<NSFetchRequestResult>()
		serchPeto.entity = NSEntityDescription.entity(forEntityName: "Lingvo", in: konteksto)
		
		do {
			return try konteksto.fetch(serchPeto) as? [NSManagedObject] ?? []
		} catch {
			return []
		}
	}()
	
	/// Ĉiuj fakoj
	lazy var chiujFakoj: [NSManagedObject] = {
		let serchPeto = NSFetchRequest<NSFetchRequestResult>()
		serchPeto.entity = NSEntityDescription.entity(forEntityName: "Fako", in: konteksto)
		do {
			if let objektoj = try konteksto.fetch(serchPeto) as? [NSManagedObject] {
				return objektoj
			}
		} catch { }
		
		return []
	}()
	
	/// Ĉiuj oficialecoj
	lazy var chiujOficialecoj: [NSManagedObject] = {
		let serchPeto = NSFetchRequest<NSFetchRequestResult>()
		serchPeto.entity = NSEntityDescription.entity(forEntityName: "Oficialeco", in: konteksto)
		
		do {
			return try konteksto.fetch(serchPeto) as? [NSManagedObject] ?? []
		} catch {
			return []
		}
	}()
	
    // MARK: - Vortlistaj destinoj
    
	/// Destinoj al ĉiuj fakvortoj de certa fako
    func fakVortoj(fako kodo: String) -> [NSManagedObject] {
        guard let fako = fako(kodo: kodo) else {
			return []
        }
        
		return fako.mutableSetValue(forKey: "fakvortoj").allObjects as? [NSManagedObject] ?? []
    }
    
	/// Destinoj al ĉiuj ofc-vortoj de certa oficialeco
    func ofcVortoj(oficialeco kodo: String) -> [NSManagedObject] {
        guard let oficialeco = oficialeco(kodo: kodo) else {
			return []
        }
        
		return oficialeco.mutableSetValue(forKey: "ofcvortoj").allObjects as? [NSManagedObject] ?? []
    }
	
	// MARK: - Serĉi individuajn objektojn
	
	/// Lingvo havanta certan kodon
	func lingvo(kodo: String) -> NSManagedObject? {
		let serchPeto = NSFetchRequest<NSFetchRequestResult>()
		serchPeto.entity = NSEntityDescription.entity(forEntityName: "Lingvo", in: konteksto)
		serchPeto.predicate = NSPredicate(format: "kodo == %@", argumentArray: [kodo])
		
		do {
			return try konteksto.fetch(serchPeto).first as? NSManagedObject
		} catch {
			return nil
		}
	}
	
	/// Fako havanta certan kodon
	func fako(kodo: String) -> NSManagedObject? {
		let serchPeto = NSFetchRequest<NSFetchRequestResult>()
		serchPeto.entity = NSEntityDescription.entity(forEntityName: "Fako", in: konteksto)
		serchPeto.predicate = NSPredicate(format: "kodo == %@", argumentArray: [kodo])
		
		do {
			return try konteksto.fetch(serchPeto).first as? NSManagedObject
		} catch {
			return nil
		}
	}
	
	/// Oficialeco havanta certan kodon
	func oficialeco(kodo: String) -> NSManagedObject? {
		let serchPeto = NSFetchRequest<NSFetchRequestResult>()
		serchPeto.entity = NSEntityDescription.entity(forEntityName: "Oficialeco", in: konteksto)
		serchPeto.predicate = NSPredicate(format: "kodo == %@", argumentArray: [kodo])
		
		do {
			return try konteksto.fetch(serchPeto).first as? NSManagedObject
		} catch {
			return nil
		}
	}
	
	/// Artikolo havanta certan indekson
	func artikolo(indekso: String) -> NSManagedObject? {
		let serchPeto = NSFetchRequest<NSFetchRequestResult>()
		serchPeto.entity = NSEntityDescription.entity(forEntityName: "Artikolo", in: konteksto)
		serchPeto.predicate = NSPredicate(format: "indekso == %@", argumentArray: [indekso])
		
		do {
			return try konteksto.fetch(serchPeto).first as? NSManagedObject
		} catch {
			return nil
		}
	}
    
    // MARK: - Aliaj
    
	/// Liveras iu ajn artikolon, hazarde
    func iuAjnArtikolo() -> NSManagedObject? {
        let numero = Int.random(in: 0..<nombroDeArtikoloj)
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Artikolo", in: konteksto)
        serchPeto.predicate = NSPredicate(format: "numero == %@", argumentArray: [numero])
		
        do {
            return try konteksto.fetch(serchPeto).first as? NSManagedObject
        } catch {
			return nil
		}
    }
    
    // MARK: - Helpiloj
    
	/// Nombro de artikoloj en la datumbazo
	lazy var nombroDeArtikoloj: Int = {
        let nombroPeto = NSFetchRequest<NSFetchRequestResult>()
        nombroPeto.entity = NSEntityDescription.entity(forEntityName: "Artikolo", in: konteksto)
        
        do {
            return try konteksto.count(for: nombroPeto)
        } catch {
			return 0
		}
    }()
}
