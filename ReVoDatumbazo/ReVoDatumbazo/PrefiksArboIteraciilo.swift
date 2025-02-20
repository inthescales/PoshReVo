import Foundation
import CoreData

/// Traserĉas la prefiksarbon kaj havigas taŭgajn artikolojn (pli precize, ĝiajn destinojn)
final class PrefiksArboIteraciilo {
	struct Rezulto {
		let teksto: String
		let destinoj: [NSManagedObject]
	}
	
	/// Nodo en prefiksarbo. Tegas NSManagedObject-on, por neteco.
	private final class ArboNodo {
		/// Objekto tegata
		private let objekto: NSManagedObject
		
		lazy var litero: String? = {
			(objekto.value(forKey: "litero") as? String)
		}()
		
		lazy var sekvajNodoj = {
			let sekvaj = (objekto.value(forKey: "sekvajNodoj") as? Set<NSManagedObject>) ?? Set<NSManagedObject>()
			return sekvaj.map { ArboNodo($0) }
		}()
		
		lazy var destinoj: [NSManagedObject] = {
			objekto.mutableOrderedSetValue(forKey: "destinoj").array as? [NSManagedObject] ?? []
		}()
		
		init(_ objekto: NSManagedObject) {
			self.objekto = objekto
		}
	}
	
	/// Nodo kaj sia teksto kiu restas ne-esporata
	private typealias Esploroto = (teksto: String, nodo: ArboNodo)
	
	/// Ĉu la itraciilo jam trovis ĉiujn eblajn rezultojn
    var atingisFinon: Bool
	
	/// Locale por tekstordigoj
	private let locale: Locale
	
	/// Nodoj kiuj restas por esplori
	private var esplorStaplo: [Esploroto] = []
	
	/// Rezultoj kiuj jam troviĝis en esplorado, sed kiujn la iteraciilo jam ne liveris
	private var rezultoStaplo: [Rezulto] = []
    
    init(lingvoKodo: String, peto: String, komencaNodo: NSManagedObject?) {
        locale = Locale(identifier: lingvoKodo)
        atingisFinon = false
        
		komencaNodo.flatMap { esplorStaplo.append((teksto: peto, nodo: ArboNodo($0))) }
    }

	/// Liveras la sekvan nodon en la prefiksarbo, se iu restas
    func next() -> Rezulto? {
		// Liveri jam-trovitan rezulton, se eblas
        if let sekvaDestino = rezultoStaplo.popLast() {
            return sekvaDestino
        }
        
		// Esplori sekvan esplorotan nodon
		while let esploroto = esplorStaplo.popLast() {
			let nunaNodo = esploroto.nodo
			
			// Aldoni sekvajn nodojn kiel esplorotajn
			esplorStaplo += nunaNodo.sekvajNodoj.sorted(by: { unua, dua in
				kompari(unua.litero, dua.litero)
			})
			.map {
				(teksto: esploroto.teksto + ($0.litero ?? ""), nodo: $0)
			}
			
			// Grupigi destinojn lau videbla nomo
			// Ĉi tio ĉefe (nur?) gravas en kazoj de du vortoj kiuj estas samnomaj krom maj/minuskleco, ekz. tarso/Tarso
			var nomGrupoj = [String: [NSManagedObject]]()
			for destino in nunaNodo.destinoj {
				if let videbla = destino.value(forKey: "teksto") as? String {
					if nomGrupoj[videbla] == nil {
						nomGrupoj[videbla] = [destino]
					} else {
						nomGrupoj[videbla]?.append(destino)
					}
				}
			}
			
			// Aldoni rezultojn alfabete
			for klavo in nomGrupoj.keys.sorted(by: { (unua, dua) -> Bool in
				return kompari(unua, dua)
			}) {
				guard let destinoj = nomGrupoj[klavo] else {
					continue
				}
				
				let rezulto = Rezulto(teksto: klavo, destinoj: destinoj)
				rezultoStaplo.append(rezulto)
			}
			
			return rezultoStaplo.popLast()
		}
			
		atingisFinon = true
		return nil
    }
	
	// MARK: - Helpiloj
	
	/// Komparas du ĉenojn laŭ alfabeta ordo
	private func kompari(_ unua: String?, _ dua: String?) -> Bool {
		(unua ?? "").compare(
			(dua ?? ""),
			options: .forcedOrdering,
			range: nil,
			locale: locale
		) == .orderedDescending
	}
}
