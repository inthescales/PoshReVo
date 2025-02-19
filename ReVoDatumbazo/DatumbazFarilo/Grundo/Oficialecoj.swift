import Foundation
import CoreData

enum Oficialecoj {
	private static var fundamento = Oficialeco(
		kodo: "*",
		indikilo: "*",
		nomo: "fundamento",
		vico: 0
	)
	
	private static func aldono(numero: Int) -> Oficialeco {
		Oficialeco(
			kodo: "\(numero)",
			indikilo: "\(numero)",
			nomo: "\(numero)a aldono",
			vico: numero
		)
	}
	
	private static var alia = Oficialeco(
		kodo: "a",
		indikilo: nil,
		nomo: "alia oficialigo",
		vico: oficialajAldonoj + 1
	)
	
	private static var neoficiala = Oficialeco(
		kodo: "n",
		indikilo: nil,
		nomo: "neoficialaj",
		vico: oficialajAldonoj + 2
	)
	
	/// Nombro de oficialaj aldonoj
	static let oficialajAldonoj = 10
	
	/// Ĉiuj oficialecoj
	static let oficialecoj =
		[fundamento] +
		(1...oficialajAldonoj).map { aldono(numero: $0) } +
		[alia, neoficiala]

	/// Aldonas oficialecojn al la donata datumbazo
	/// Adds oficialnesses to the given database
	public static func skribi(en konteksto: NSManagedObjectContext) {
		print("Aldonas oficialecojn")
		
		for ofc in Oficialecoj.oficialecoj {
			ofc.skribi(en: konteksto)
		}
		try! konteksto.save()
		
		print("Aldonis \(Oficialecoj.oficialecoj.count) oficialecojn")
	}
}
