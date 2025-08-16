import Foundation
import CoreData

/// Faras prefiksarbon por artikolserĉado
final class PrefiksArboFarilo {
	/// Nodo en la prefiksarbo
	final class Nodo {
		var sekvaj: [Character: Nodo] = [:]
		var destinoj: [Destino] = []
	}

	let konteksto: NSManagedObjectContext
	let serchVortoj: [SerchVorto]
	let tradukaro: [String: [SerchTraduko]]
	let artikolObjektoj: [String: NSManagedObject]
	
	let alirilo: DatumbazAlirilo
	var komencajNodoj: [String: [Character: Nodo]] = [:]
	
	init(
		konteksto: NSManagedObjectContext,
		serchVortoj: [SerchVorto],
		tradukaro: [String: [SerchTraduko]],
		artikolObjektoj: [String: NSManagedObject]
	) {
		self.konteksto = konteksto
		self.serchVortoj = serchVortoj
		self.tradukaro = tradukaro
		self.artikolObjektoj = artikolObjektoj
		
		self.alirilo = DatumbazAlirilo(konteksto: konteksto)
	}
	
	// MARK: - Arbokonstruado
	
	/// Konstrui prefiksarbon por ĉiuj lingvoj, kaj esperantaj derivaĵoj kaj nacilingvaj tradukoj
	func kreiArbojn() {
		let datumoj: [(String, [Serchebla])] =
			[(Lingvo.esperantaKodo, serchVortoj)]
			+ tradukaro.map { ($0, $1) }
		for (lingvoKodo, sercheblaj) in datumoj {
			kreiArbon(por: lingvoKodo, enhavanta: sercheblaj)
		}
	}
	
	/// Krei prefiksarbon por certa lingvo, enhavanta certajn serĉvortojn
	private func kreiArbon(por lingvoKodo: String, enhavanta sercheblaj: [Serchebla]) {
		print("Kreas prefiksarbon por " + lingvoKodo)
		komencajNodoj[lingvoKodo] = [:]

		for serchebla in sercheblaj {
			var nunaNodo: Nodo?
			
			for (i, litero) in serchebla.serchTeksto.lowercased().enumerated() {
				if i == 0 {
					nunaNodo = komencajNodoj[lingvoKodo]?[litero]
						?? fariKomencanNodon(por: lingvoKodo, litero: litero)
				} else {
					nunaNodo = nunaNodo?.sekvaj[litero]
						?? fariSekvanNodon(por: nunaNodo!, litero: litero)
				}
			}
			
			// Se la nuna serĉebla havas saman tekston, subtekston, kaj markon kiel
			// alian destinon en unu sama nodo, ne indas skribi ambaŭ.
			// Tio povas okazi se pluraj sencoj ene de unu derivaĵo havas unu saman
			// nacilingvan tradukon.
			let duobla = nunaNodo?.destinoj.contains(where: {
				$0.teksto == serchebla.videblaTeksto
				&& $0.subteksto == serchebla.subteksto
				&& $0.marko == serchebla.derivajhMarko
			}) ?? false
			
			if !duobla {
				nunaNodo?.destinoj.append(fariDestinon(el: serchebla, por: nunaNodo!))
			}
		}
	}
	
	/// Faras nodon kal aldonas ĝin kiel komencan nodon al la lingvo
	private func fariKomencanNodon(por lingvo: String, litero: Character) -> Nodo {
		let novaNodo = Nodo()
		komencajNodoj[lingvo]![litero] = novaNodo
		return novaNodo
	}
	
	/// Faras nodon kal aldonas ĝin kiel sekvan nodon al la nodo
	private func fariSekvanNodon(por nodo: Nodo, litero: Character) -> Nodo {
		let novaNodo = Nodo()
		nodo.sekvaj[litero] = novaNodo
		return novaNodo
	}
	
	/// Faras destinon kaj aldonas ĝin al la nodo
	private func fariDestinon(el serchebla: Serchebla, por nodo: Nodo) -> Destino {
		guard let artikolObjekto = artikolObjektoj[serchebla.indekso]
				?? alirilo.artikolo(indekso: serchebla.indekso) else {
			assert(false, "Ne trovis artikolan datumbazobjekton")
		}
		
		return Destino(
			teksto: serchebla.videblaTeksto,
			subTeksto: serchebla.subteksto,
			marko: serchebla.derivajhMarko,
			senco: serchebla.senco.flatMap { String($0) },
			artikolObjekto: artikolObjekto
		)
	}
	
	// MARK: - Skribado
	
	/// Skribas tutan prefiksarbaron en kontekston
	func skribi(en konteksto: NSManagedObjectContext) {
		for (lingvo, komencaj) in komencajNodoj {
			print("Skribas arbon por " + lingvo)
			
			let lingvObjekto = alirilo.lingvo(kodo: lingvo)!
			for (litero, nodo) in komencaj {
				let komencNodo = skribi(nodon: nodo, litero: litero, en: konteksto)
				lingvObjekto.mutableSetValue(forKey: "komencajNodoj").add(komencNodo)
			}
			
			try! konteksto.save()
		}
	}
	
	/// Skribas nodon, kaj ĝiajn filojn, en datumbazon
	private func skribi(
		nodon nodo: Nodo,
		litero: Character,
		en konteksto: NSManagedObjectContext
	) -> NSManagedObject {
		let novaNodo = NSEntityDescription.insertNewObject(forEntityName: "TrieNodo", into: konteksto)
		novaNodo.setValue(String(litero), forKey: "litero")
		
		for (litero, sekva) in nodo.sekvaj {
			let sekvaNodo = skribi(nodon: sekva, litero: litero, en: konteksto)
			novaNodo.mutableSetValue(forKey: "sekvajNodoj").add(sekvaNodo)
		}
		
		for destino in nodo.destinoj {
			let destinObjekto = destino.skribi(en: konteksto)
			novaNodo.mutableOrderedSetValue(forKey: "destinoj").add(destinObjekto)
		}
		
		return novaNodo
	}
}
