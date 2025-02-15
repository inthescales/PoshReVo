import Foundation
import CoreData

private struct Oficialeco {
	let kodo: String
	let indikilo: String?
	let nomo: String

	private static var fundamento = Oficialeco(
		kodo: "*",
		indikilo: "*",
		nomo: "fundamento"
	)
	
	private static func aldono(numero: Int) -> Oficialeco {
		Oficialeco(
			kodo: "\(numero)",
			indikilo: "\(numero)",
			nomo: "\(numero)a aldono"
		)
	}
	
	private static var alia = Oficialeco(
		kodo: "a",
		indikilo: nil,
		nomo: "alia oficialigo"
	)
	
	private static var neoficiala = Oficialeco(
		kodo: "n",
		indikilo: nil,
		nomo: "neoficialaj"
	)
	
	static let oficialecoj = [
		fundamento,
		aldono(numero: 1),
		aldono(numero: 2),
		aldono(numero: 3),
		aldono(numero: 4),
		aldono(numero: 5),
		aldono(numero: 6),
		aldono(numero: 7),
		aldono(numero: 8),
		aldono(numero: 9),
		aldono(numero: 10),
		alia,
		neoficiala
	]
}

enum Oficialecoj {
	/// Aldonas oficialecojn al la donata datumbazo
	/// Adds oficialnesses to the given database
	public static func aldoni(al konteksto: NSManagedObjectContext) {
		print("Aldonas oficialecojn")
		
		for ofc in Oficialeco.oficialecoj {
			let novaOfc = NSEntityDescription.insertNewObject(forEntityName: "Oficialeco", into: konteksto)
			novaOfc.setValue(ofc.kodo, forKey: "kodo")
			novaOfc.setValue(ofc.indikilo ?? "", forKey: "indikilo")
			novaOfc.setValue(ofc.nomo, forKey: "nomo")
		}
		try! konteksto.save()
		
		print("Aldonis \(Oficialeco.oficialecoj.count) oficialecojn")
	}
}
