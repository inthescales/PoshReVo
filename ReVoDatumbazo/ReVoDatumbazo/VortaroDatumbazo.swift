//import Foundation
import CoreData

/// Venigas datumojn el la datumbazo, kaj liveras ilin forme de diversaj modeloj
public final class VortaroDatumbazo {
    private let alirilo: DatumbazAlirilo

    public init(konteksto: NSManagedObjectContext) {
        alirilo = DatumbazAlirilo(konteksto: konteksto)
    }
	
	// MARK: - Chiuj modeloj
	
	/// Ĉiuj lingvoj
	public lazy var chiujLingvoj: [Lingvo] = {
		alirilo.chiujLingvoj().compactMap { objekto in
			Lingvo.el(objekto)
		}.sorted { (lhs, rhs) -> Bool in
			return lhs < rhs
		}
	}()
	
	/// Ĉiuj lingvoj krom Esperanto
	public lazy var neesperantajLingvoj: [Lingvo] = {
		alirilo.chiujLingvoj().compactMap { objekto in
			Lingvo.el(objekto)
		}
		.filter { lingvo in
			lingvo.kodo != Lingvo.esperantaKodo
		}
		.sorted { (lhs, rhs) -> Bool in
			return lhs < rhs
		}
	}()
	
	/// Ĉiuj Fakoj
	public lazy var chiujFakoj: [Fako] = {
		alirilo.chiujFakoj().compactMap { objekto in
			Fako.el(objekto)
		}.sorted { (lhs, rhs) -> Bool in
			return lhs < rhs
		}
	}()
    
    // MARK: - Modeloserĉado
    
	/// Liveras lingvon havantan certan kodon
    public func lingvo(kodo: String) -> Lingvo? {
        if let objekto = alirilo.lingvo(kodo: kodo) {
			return Lingvo.el(objekto)
        }
        return nil
    }
    
	/// Liveras fakon havantan certan kodon
    public func fako(kodo: String) -> Fako? {
        if let objekto = alirilo.fako(kodo: kodo) {
            return Fako.el(objekto)
        }
        return nil
    }
    
	/// Liveras artikolon havantan certan indekson
    public func artikolo(indekso: String) -> Artikolo? {
        if let objekto = alirilo.artikolo(indekso: indekso) {
			return Artikolo.el(objekto, alirilo: alirilo)
        }
        
        return nil
    }
	
	/// Liveras artikolon, al kiu kondukas destino
	public func artikolo(de destino: Destino) -> Artikolo? {
		Artikolo.el(destino.artikolObjekto, alirilo: alirilo)
	}

	/// Liveras iun ajn artikolon, hazarde
    public func iuAjnArtikolo() -> Artikolo? {
        if let objekto = alirilo.iuAjnArtikolo() {
            return Artikolo.el(objekto, alirilo: alirilo)
        }
        
        return nil
    }
    
    // MARK: - Vortolistoj
	
	/// Liveras fakvortajn destinojn de certa fako
    public func fakVortoj(fako kodo: String) -> [Destino] {
        alirilo.fakVortoj(fako: kodo).compactMap { objekto in
            Destino(objekto: objekto)
        }.sorted { (lhs, rhs) -> Bool in
            return lhs < rhs
        }
    }
    
	/// Liveras oficialecajn vortojn de certa oficialeco
    public func ofcVortoj(oficialeco kodo: String) -> [Destino] {
        alirilo.ofcVortoj(oficialeco: kodo).compactMap { objekto in
            Destino(objekto: objekto)
        }.sorted { (lhs, rhs) -> Bool in
            return lhs < rhs
        }
    }
	
	/// Ĉiuj oficialecoj
	public lazy var chiujOficialecoj: [Oficialeco] = {
        alirilo.chiujOficialecoj().compactMap { objekto in
            Oficialeco.el(objekto)
        }.sorted { (lhs, rhs) -> Bool in
            return lhs < rhs
        }
    }()
	
	/// Ĉiuj oficialigoj — tio estas, ĉiuj oficialecoj krom 'neoficiala'
	public lazy var chiujOficialigoj: [Oficialeco] = {
		alirilo.chiujOficialecoj().compactMap { objekto in
			Oficialeco.el(objekto)
		}.filter {
			$0.kodo != Oficialeco.neoficialaKodo
		}
		.sorted { (lhs, rhs) -> Bool in
			return lhs < rhs
		}
	}()
	
	/// Oficialeco por neoficialigitaj radikoj
	public lazy var neoficialaj: Oficialeco? = {
		alirilo.chiujOficialecoj().compactMap { objekto in
			Oficialeco.el(objekto)
		}.first {
			$0.kodo == Oficialeco.neoficialaKodo
		}
	}()
    
    // MARK: - Vorto-serĉado
    
	/// Komencas tekst-serĉon, kaj liveras staton uzeblan por daŭrigi ĝin
    public func komenciSerchon(
		lingvo: Lingvo,
		teksto: String,
		komenco: Int? = 0,
		limo: Int
	) -> SerchStato {
        if let iteraciilo = alirilo.starigiIteraciilon(lingvo: lingvo.kodo, peto: teksto) {
            let komencaStato = SerchStato(
				peto: teksto,
				rezultoj: [],
				atingisFinon: false,
				iterator: iteraciilo
			)
            return daurigiSerchon(stato: komencaStato, limo: limo)
		} else {	
			return SerchStato.malsukcesa(lingvo: lingvo.kodo, peto: teksto)
		}
    }
    
	/// Daŭrigas jam komencitan serĉon, laŭ la stato
    public func daurigiSerchon(stato: SerchStato, limo: Int) -> SerchStato {
        let rezultObjektoj = alirilo.serchi(iterator: stato.iterator, limo: limo)
        let novajRezultoj = rezultObjektoj.map { rezulto in
            SerchRezulto(
				teksto: rezulto.teksto,
				destinoj: rezulto.destinoj.compactMap {
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
