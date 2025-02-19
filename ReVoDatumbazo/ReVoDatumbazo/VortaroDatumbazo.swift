//import Foundation
import CoreData

/// Venigas datumojn el la datumbazo, kaj liveras ilin diversforme (t.e. kiel `Lingvon`, `Fakon`, ktp., kaj ne datumbazobjekton)
public final class VortaroDatumbazo {

    private let alirilo: DatumbazAlirilo

    public init(konteksto: NSManagedObjectContext) {
        alirilo = DatumbazAlirilo(konteksto: konteksto)
    }
    
    // MARK: - Modeloserĉado
    
    public func lingvo(porKodo kodo: String) -> Lingvo? {
        if let objekto = alirilo.lingvo(kodo: kodo) {
			return Lingvo.el(objekto)
        }
        return nil
    }
    
    public func fako(porKodo kodo: String) -> Fako? {
        if let objekto = alirilo.fako(kodo: kodo) {
            return Fako.el(objekto)
        }
        return nil
    }
    
    public func artikolo(porIndekso indekso: String) -> Artikolo? {
        if let objekto = alirilo.artikolo(indekso: indekso) {
			return Artikolo.el(objekto, alirilo: alirilo)
        }
        
        return nil
    }
	
	public func artikolo(de destino: Destino) -> Artikolo? {
		Artikolo.el(destino.artikolObjekto, alirilo: alirilo)
	}

    public func iuAjnArtikolo() -> Artikolo? {
        if let objekto = alirilo.iuAjnArtikolo() {
            return Artikolo.el(objekto, alirilo: alirilo)
        }
        
        return nil
    }
    
    // MARK: - Klasoj de modeloj
	
    public func fakVortoj(fako kodo: String) -> [Destino] {
        alirilo.fakVortoj(fako: kodo).compactMap { objekto in
            Destino(objekto: objekto)
        }.sorted { (lhs, rhs) -> Bool in
            return lhs < rhs
        }
    }
    
    public func ofcVortoj(oficialeco kodo: String) -> [Destino] {
        alirilo.ofcVortoj(oficialeco: kodo).compactMap { objekto in
            Destino(objekto: objekto)
        }.sorted { (lhs, rhs) -> Bool in
            return lhs < rhs
        }
    }
    
    // MARK: - Chiuj modeloj
    
    public func chiujLingvoj() -> [Lingvo] {
        alirilo.chiujLingvoj.compactMap { objekto in
            Lingvo.el(objekto)
        }.sorted { (lhs, rhs) -> Bool in
            return lhs < rhs
        }
    }
    
    public func chiujFakoj() -> [Fako] {
        alirilo.chiujFakoj.compactMap { objekto in
            Fako.el(objekto)
        }.sorted { (lhs, rhs) -> Bool in
            return lhs < rhs
        }
    }
        
    public func chiujOficialecoj() -> [Oficialeco]? {
        alirilo.chiujOficialecoj.compactMap { objekto in
            Oficialeco.el(objekto)
        }.sorted { (lhs, rhs) -> Bool in
            return lhs < rhs
        }
    }
    
    // MARK: - Trie-serĉado
    
    public func komenciSerchon(lingvo: Lingvo, teksto: String, komenco: Int? = 0, limo: Int) -> SerchStato {
        if let iterator = alirilo.starigiTrieIterator(lingvo: lingvo.kodo, peto: teksto) {
            let komencaStato = SerchStato(
				peto: teksto,
				rezultoj: [],
				atingisFinon: false,
				iterator: iterator
			)
            return daurigiSerchon(stato: komencaStato, limo: limo)
        }
		
		let nombrilo = TrieIterator(
			lingvoKodo: lingvo.kodo,
			peto: teksto,
			komencaNodo: nil
		)
        return SerchStato(
			peto: teksto,
			rezultoj: [],
			atingisFinon: true,
			iterator: nombrilo
		)
    }
    
    public func daurigiSerchon(stato: SerchStato, limo: Int) -> SerchStato {
        let rezultObjektoj = alirilo.serchi(iterator: stato.iterator, limo: limo)
        let novajRezultoj = rezultObjektoj.compactMap { rezulto in
            (
                rezulto.0,
                rezulto.1.compactMap {
                    Destino(objekto: $0)
                }
            )
        }
        return SerchStato(
			peto: stato.peto,
			rezultoj: stato.rezultoj + novajRezultoj,
			atingisFinon: novajRezultoj.isEmpty,
			iterator: stato.iterator
		)
    }
}
