import Foundation
import CoreData

/// Kreas novan datumbazon en destinon el fontoj je la font-indiko, liveras 'managed object' kontekston
/// Creates a new database at the destination using data in the source path, returns managed object context
func kreiDatumbazon(destino: String) -> NSManagedObjectContext {
	let managedObjectModel: NSManagedObjectModel = {
		let datumbazBundle = Bundle(for: PrefiksArboFarilo.self)
		let modelURL = datumbazBundle.url(forResource: "PoshReVoDatumoj", withExtension: "momd")!
		return NSManagedObjectModel(contentsOf: modelURL)!
	}()

	let persistentStoreCoordinator: NSPersistentStoreCoordinator = {
		let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
		let datumbazUrl = URL(fileURLWithPath: destino)
		
		do {
			// Forigi malnovan datumbazon
			try FileManager.default.removeItem(at: datumbazUrl)
			
			let pragmas: [String : String] = ["journal_mode" : "DELETE", "synchronous" : "OFF"]
			let options = [NSSQLitePragmasOption : pragmas]
			try coordinator.addPersistentStore(
				ofType: NSSQLiteStoreType,
				configurationName: nil,
				at: datumbazUrl,
				options: options
			)
		} catch {
			// Raporti erarojn
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
		managedObjectContext.undoManager = nil
		return managedObjectContext
	}()
	
	return managedObjectContext
}
