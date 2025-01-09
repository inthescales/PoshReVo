import Foundation
import CoreData
import ReVoDatumbazoOSX

print(FileManager.default.currentDirectoryPath)

var revoIndiko: String = radiko + "/fontoj/revo"
var grundIndiko: String = radiko + "/fontoj/grundo"

let datumbazIndiko: String = radiko + "/datumbazo.sqlite"

/* let lingvoAnalizilo = LingvoAnalizilo()
legiXMLon(el: grundIndiko + "/cfg/lingvoj.xml", delegate: lingvoAnalizilo)
let lingvoj = lingvoAnalizilo.lingvoj

let fakoAnalizilo = FakoAnalizilo()
legiXMLon(el: grundIndiko + "/cfg/fakoj.xml", delegate: fakoAnalizilo)
let fakoj = fakoAnalizilo.fakoj

let mallongigoAnalizilo = MallongigoAnalizilo()
legiXMLon(el: grundIndiko + "/cfg/mallongigoj.xml", delegate: mallongigoAnalizilo)
let mallongigoj = mallongigoAnalizilo.mallongigoj

let stiloAnalizilo = StiloAnalizilo()
legiXMLon(el: grundIndiko + "/cfg/stiloj.xml", delegate: stiloAnalizilo)
let stiloj = stiloAnalizilo.stiloj

let literoAnalizilo = LiteroAnalizilo()
legiXMLon(el: grundIndiko + "/cfg/literoj.xml", delegate: literoAnalizilo)
let literoj = literoAnalizilo.literoj

for (key, val) in stiloj {
	print(key + ": " + val)
} */


//
//var container: NSPersistentContainer
//container = NSPersistentContainer(name: "PoshReVoDatumoj")
//container.loadPersistentStores { storeDescription, error in
//	if let error = error {
//		fatalError("Fatal Error loading store: \(error.localizedDescription)")
//	}
//}

var managedObjectModel: NSManagedObjectModel = {
	let momdIndiko = URL(fileURLWithPath: radiko + "/fontoj/test.momd")
	return NSManagedObjectModel(contentsOf: momdIndiko)!
}()


var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
	
	let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
	let docsUrl = URL(fileURLWithPath: datumbazIndiko)
	
	do {
		let pragmas: [String : String] = ["journal_mode" : "DELETE", "synchronous" : "OFF"]
		do {
			// Forigi malnovan datumbazon
			try FileManager.default.removeItem(at: docsUrl)
		} catch { }
		let options = [NSSQLitePragmasOption : pragmas]
		try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: docsUrl, options: options)
	} catch {
		// Report any error we got.
		var dict = [String: Any]()
		dict[NSLocalizedDescriptionKey] = "Malsukcesis sharghante je datumoj"
		dict[NSLocalizedFailureReasonErrorKey] = "Eraro sharghante je datumoj"
		dict[NSUnderlyingErrorKey] = error as NSError
		print(dict)
		abort()
	}
	
	return coordinator
}()

var managedObjectContext: NSManagedObjectContext = {
	let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
	managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
	return managedObjectContext
}()

LingvoAnalizilo2.legi(el: grundIndiko + "/cfg/lingvoj.xml", en: managedObjectContext)
FakoAnalizilo2.legi(el: grundIndiko + "/cfg/fakoj.xml", en: managedObjectContext)
MallongigoAnalizilo2.legi(el: grundIndiko + "/cfg/mallongigoj.xml", en: managedObjectContext)
StiloAnalizilo2.legi(el: grundIndiko + "/cfg/stiloj.xml", en: managedObjectContext)
Oficialecoj.aldoni(al: managedObjectContext)

print("All done :)")
