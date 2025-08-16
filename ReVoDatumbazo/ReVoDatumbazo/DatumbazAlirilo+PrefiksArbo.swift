import CoreData

extension DatumbazAlirilo {
	/// Kreas TrieIterator-on kiu montros rezultojn el certa loko en lingva prefiksarbo
    func starigiIteraciilon(lingvo lingvoKodo: String, peto: String) -> PrefiksArboIteraciilo? {
        guard peto.count > 0,
			  let lingvo = lingvo(kodo: lingvoKodo),
			  let komencaNodo = komencaNodo(en: lingvo, kun: String(peto.prefix(1))) else {
            return nil
        }
        
        var nunNodo = komencaNodo
        for nunLitero in String(peto.suffix(peto.count - 1)) {
            if let sekvaNodo = sekvaNodo(el: nunNodo, kun: String(nunLitero)) {
                nunNodo = sekvaNodo
            } else {
                return nil
            }
        }
        
        return PrefiksArboIteraciilo(lingvoKodo: lingvoKodo, peto: peto, komencaNodo: nunNodo)
    }
    
	/// Serĉi rezultojn komencante je la nuna stato de la TrieIterator, ĝis certa limo de rezultoj
	func serchi(iterator: PrefiksArboIteraciilo, limo: Int) -> [PrefiksArboIteraciilo.Rezulto] {
		var rezultoj: [PrefiksArboIteraciilo.Rezulto] = []
		while !iterator.atingisFinon && rezultoj.count < limo {
            if let sekva = iterator.next() {
                rezultoj.append(sekva)
            }
        }
        
        return rezultoj
    }
    
    // MARK: - Hepiloj
    
	/// Liveras komencan nodon en lingvo laŭ certa litero
    private func komencaNodo(en lingvo: NSManagedObject, kun litero: String) -> NSManagedObject? {
		let komencajNodoj = [NSManagedObject](lingvo.value(forKey: "komencajNodoj") as? Set ?? [])
		return komencajNodoj.first {
			$0.value(forKey: "litero") as? String == litero.lowercased()
        }
    }
	
	/// Liveras sekvan nodon el alia nodo laŭ certa litero
    private func sekvaNodo(el nodo: NSManagedObject, kun litero: String) -> NSManagedObject? {
        let sekvaj = [NSManagedObject](nodo.value(forKey: "sekvajNodoj") as? Set ?? [])
		return sekvaj.first {
			return $0.value(forKey: "litero") as? String == litero.lowercased()
		}
    }
}
