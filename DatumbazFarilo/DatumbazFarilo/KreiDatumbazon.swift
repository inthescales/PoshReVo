import Foundation
import CoreData

/// Kreas novan datumbazon en destinon el fontoj je la font-indiko, liveras 'managed object' kontekston
/// Creates a new database at the destination using data in the source path, returns managed object context
func kreiDatumbazon(fontIndiko: String, destino: String) -> NSManagedObjectContext {
	let managedObjectModel: NSManagedObjectModel = {
		let momdIndiko = URL(fileURLWithPath: fontIndiko + "/test.momd")
		return NSManagedObjectModel(contentsOf: momdIndiko)!
	}()

	let persistentStoreCoordinator: NSPersistentStoreCoordinator = {
		let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
		let datumbazUrl = URL(fileURLWithPath: destino)
		
		do {
			let pragmas: [String : String] = ["journal_mode" : "DELETE", "synchronous" : "OFF"]
			do {
				// Forigi malnovan datumbazon
				try FileManager.default.removeItem(at: datumbazUrl)
			} catch { }
			let options = [NSSQLitePragmasOption : pragmas]
			try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: datumbazUrl, options: options)
		} catch {
			// Report any error we got.
			var dict = [String: Any]()
			dict[NSLocalizedDescriptionKey] = "Malsukcesis datumo-ŝarĝado"
			dict[NSLocalizedFailureReasonErrorKey] = "Eraro en datumo-ŝarĝado"
			dict[NSUnderlyingErrorKey] = error as NSError
			print(dict)
			abort()
		}
		
		return coordinator
	}()

	let managedObjectContext: NSManagedObjectContext = {
		let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
		managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
		return managedObjectContext
	}()
	
	return managedObjectContext
}
