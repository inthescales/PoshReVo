/// Stato de serĉo
public struct SerchStato {
	/// La originala serĉteksto
	public var peto: String
	
	/// Rezultoj kiuj estas nun prezenteblaj
	public var rezultoj: [SerchRezulto]

	/// Ĉu la serĉo jam prezentis ĉiujn rezultojn
	public var atingisFinon: Bool
	
	/// Prefiksarba nombrilo
	var iterator: PrefiksArboIteraciilo
	
	/// Liveras serchstaton taŭga por kazoj en kiu nenia komenca nodo troviĝis
	static func malsukcesa(lingvo: String, peto: String) -> SerchStato {
		return SerchStato(
			peto: peto,
			rezultoj: [],
			atingisFinon: false,
			iterator: PrefiksArboIteraciilo(lingvoKodo: lingvo, peto: peto, komencaNodo: nil)
		)
	}
}
