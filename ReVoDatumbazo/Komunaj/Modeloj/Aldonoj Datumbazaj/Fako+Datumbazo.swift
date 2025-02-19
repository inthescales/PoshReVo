import CoreData

extension Fako {
	func skribi(en konteksto: NSManagedObjectContext) {
		let objekto = NSEntityDescription.insertNewObject(forEntityName: "Fako", into: konteksto)
		objekto.setValue(kodo, forKey: "kodo")
		objekto.setValue(nomo, forKey: "nomo")
	}
	
    static func el(_ objekto: NSManagedObject) -> Fako? {
        guard let kodo = objekto.value(forKey: "kodo") as? String,
			  let nomo = objekto.value(forKey: "nomo") as? String else {
			return nil
        }
        
		return Fako(kodo: kodo, nomo: nomo)
    }
}
