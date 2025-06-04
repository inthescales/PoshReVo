import ReVoDatumbazo

struct UzantDatumaro {
	var elektitaLingvo: Lingvo
	
	var lingvoj: [Lingvo]
	
	var historio: [Konservitajho]
	
	var konservitaj: [Konservitajho]
	
	func chuKonservita(artikolo: Artikolo) -> Bool {
		konservitaj.contains(where: { $0.indekso == artikolo.indekso })
	}
	
	static var komuna: UzantDatumaro {
		UzantDatumoRegilo.komuna.datumaro
	}
}
