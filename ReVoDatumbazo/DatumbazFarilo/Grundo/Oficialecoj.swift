import Foundation
import CoreData

/// Disponebligas oficialecojn
enum Oficialecoj {
	static var fundamento = Oficialeco(
		kodo: "*",
		indikilo: "*",
		nomo: "fundamento",
		vico: 0
	)
	
	static func aldono(numero: Int) -> Oficialeco {
		Oficialeco(
			kodo: "\(numero)",
			indikilo: "\(numero)",
			nomo: "\(numero)a aldono",
			vico: numero
		)
	}
	
	static var alia = Oficialeco(
		kodo: "a",
		indikilo: nil,
		nomo: "alia oficialigo",
		vico: oficialajAldonoj + 1
	)
	
	static var neoficiala = Oficialeco(
		kodo: Oficialeco.neoficialaKodo,
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

extension Oficialeco {
	/// Faras kaj liveras oficialecon havantan tiun kodon
	static func kun(kodo: String?) -> Oficialeco? {
		switch kodo {
		case nil:
			return Oficialecoj.neoficiala
		case "*":
			return Oficialecoj.fundamento
		case "1", "2", "3", "4", "5", "6", "7", "8", "9", "10":
			return Oficialecoj.aldono(numero: Int(kodo!)!)
		default:
			return Oficialecoj.alia
		}
	}
}
