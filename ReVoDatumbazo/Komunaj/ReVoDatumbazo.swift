import Foundation
import CoreData

public final class ReVoDatumbazo {
	/// Legas konteksto el la destino, se ĝi ekzistas
	public static func legiDatumbazon(el datumbazURL: URL) -> NSManagedObjectContext {
		return starigiDatumbazon(en: datumbazURL, nurlega: true)
	}
	
	/// Forigas datumbazon en la destino, kaj kreas novan tie
	public static func kreiDatumbazon(destino: String) -> NSManagedObjectContext {
		let destinoURL = URL(fileURLWithPath: destino)
		
		// Forigi malnovan datumbazon
		if FileManager.default.fileExists(atPath: destino) {
			try? FileManager.default.removeItem(at: destinoURL)
		}
		
		return starigiDatumbazon(en: destinoURL, nurlega: false)
	}
	
	/// Kreas novan datumbazon en destinon el fontoj je la font-indiko, liveras 'managed object' kontekston
	/// Creates a new database at the destination using data in the source path, returns managed object context
	static func starigiDatumbazon(en datumbazURL: URL, nurlega: Bool) -> NSManagedObjectContext {
		let managedObjectModel: NSManagedObjectModel = {
			let datumbazBundle = Bundle(for: Self.self)
			let modelURL = datumbazBundle.url(forResource: "PoshReVoDatumoj", withExtension: "momd")!
			return NSManagedObjectModel(contentsOf: modelURL)!
		}()

		let persistentStoreCoordinator: NSPersistentStoreCoordinator = {
			let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
			
			do {
				let options: [String : Any] = [
					NSReadOnlyPersistentStoreOption : nurlega,
					NSSQLitePragmasOption : ["journal_mode" : "DELETE", "synchronous" : "OFF"]
				]
				try coordinator.addPersistentStore(
					ofType: NSSQLiteStoreType,
					configurationName: nil,
					at: datumbazURL,
					options: options
				)
			} catch {
				print("Malsukcesis starigi datumbazon, kun jena eraro:")
				print(error)
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

}
