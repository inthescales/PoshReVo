/// Stato de serĉo
public struct SerchStato {
	/// La originala serĉteksto
	public var peto: String
	
	/// Rezultoj kiuj estas nun prezenteblaj
	public var rezultoj: [(String, [Destino])]

	/// Ĉu la serĉo jam prezentis ĉiujn rezultojn
	public var atingisFinon: Bool
	
	/// Prefiksarba nombrilo
	internal var iterator: TrieIterator
}
