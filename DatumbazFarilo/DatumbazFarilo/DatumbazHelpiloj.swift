import CoreData

enum Datumbaza {
	/// Liveras NSManagedObject-on reprezentantan lingvon havantan la donatan kodon
	static func lingvo(porKodo kodo: String, en konteksto: NSManagedObjectContext) -> NSManagedObject? {
		let serchPeto = NSFetchRequest<NSFetchRequestResult>()
		serchPeto.entity = NSEntityDescription.entity(forEntityName: "Lingvo", in: konteksto)
		serchPeto.predicate = NSPredicate(format: "kodo == %@", argumentArray: [kodo])
		
		return try! konteksto.fetch(serchPeto).first as? NSManagedObject
	}
	
	/// Liveras NSManagedObject-on reprezentantan fakon havantan la donatan kodon
	static func fako(porKodo kodo: String, en konteksto: NSManagedObjectContext) -> NSManagedObject? {
		let serchPeto = NSFetchRequest<NSFetchRequestResult>()
		serchPeto.entity = NSEntityDescription.entity(forEntityName: "Fako", in: konteksto)
		serchPeto.predicate = NSPredicate(format: "kodo == %@", argumentArray: [kodo])
		
		return try! konteksto.fetch(serchPeto).first as? NSManagedObject
	}
	
	/// Liveras NSManagedObject-on reprezentantan oficialecon havantan la donatan kodon
	static func oficialeco(porKodo kodo: String, en konteksto: NSManagedObjectContext) -> NSManagedObject? {
		let serchPeto = NSFetchRequest<NSFetchRequestResult>()
		serchPeto.entity = NSEntityDescription.entity(forEntityName: "Oficialeco", in: konteksto)
		serchPeto.predicate = NSPredicate(format: "kodo == %@", argumentArray: [kodo])

		return try! konteksto.fetch(serchPeto).first as? NSManagedObject
	}
	
	/// Liveras artikolan NSManagedObject-on havantan certan indekson.
	static func artikolo(porIndekso indekso: String, en konteksto: NSManagedObjectContext) -> NSManagedObject? {
		let serchPeto = NSFetchRequest<NSFetchRequestResult>()
		serchPeto.entity = NSEntityDescription.entity(forEntityName: "Artikolo", in: konteksto)
		serchPeto.predicate = NSPredicate(format: "indekso == %@", argumentArray: [indekso])
		
		return try! konteksto.fetch(serchPeto).first as? NSManagedObject
	}
}
