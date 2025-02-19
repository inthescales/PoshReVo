import CoreData

extension Lingvo {
	func skribi(en konteksto: NSManagedObjectContext) {
		let objekto = NSEntityDescription.insertNewObject(forEntityName: "Lingvo", into: konteksto)
		objekto.setValue(kodo, forKey: "kodo")
		objekto.setValue(nomo, forKey: "nomo")
	}
	
    static func el(_ objekto: NSManagedObject) -> Lingvo? {
        guard let kodo = objekto.value(forKey: "kodo") as? String,
			  let nomo = objekto.value(forKey: "nomo") as? String else {
			return nil
        }
        
		return Lingvo(kodo: kodo, nomo: nomo)
    }
}
