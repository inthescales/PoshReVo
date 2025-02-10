import CoreData

import ReVoModelojOSX

/// Enhavas ĉiujn necesajn informojn el voko-grundo
class Grundo: Codable {
	let lingvoj: [Lingvo]
	let fakoj: [Fako]
	let stiloj: [Stilo]
	let signoj: [String: String]
	let mallongigojVerkaj: [String: String]
	let mallongigojVortaraj: [Mallongigo]
	let urloj: [String: String]
	
	lazy var lingvoDict = lingvoj.reduce(into: [String: Lingvo]()) { dict, lingvo in
		dict[lingvo.kodo] = lingvo
	}

	lazy var stiloDict = stiloj.reduce(into: [String: String]()) { dict, stilo in
		dict[stilo.kodo] = stilo.nomo
	}
	
	init(
		lingvoj: [Lingvo],
		fakoj: [Fako],
		stiloj: [Stilo],
		signoj: [String : String],
		mallongigojVerkaj: [String : String],
		mallongigojVortaraj: [Mallongigo],
		urloj: [String : String]
	) {
		self.lingvoj = lingvoj
		self.fakoj = fakoj
		self.stiloj = stiloj
		self.signoj = signoj
		self.mallongigojVerkaj = mallongigojVerkaj
		self.mallongigojVortaraj = mallongigojVortaraj
		self.urloj = urloj
	}
	
	static func legi(el indikilo: String) -> Grundo {
		let lingvoj = LingvoAnalizilo.legi(el: indikilo + "/cfg/lingvoj.xml")
		let fakoj = FakoAnalizilo.legi(el: indikilo + "/cfg/fakoj.xml")
		let vortarajMallongigoj = VortarajMallongigojAnalizilo.legi(el: indikilo + "/cfg/mallongigoj.xml")
		let stiloj = StiloAnalizilo.legi(el: indikilo + "/cfg/stiloj.xml")
		let signoj = SignoAnalizilo.analizi(el: indikilo + "/dtd/vokosgn.dtd")
		let verkajMallongigoj = DTDAnalizilo.entoj(el: indikilo + "/dtd/vokomll.dtd")
		let urloj = DTDAnalizilo.entoj(el: indikilo + "/dtd/vokourl.dtd")
		
		return Grundo(
			lingvoj: lingvoj,
			fakoj: fakoj,
			stiloj: stiloj,
			signoj: signoj,
			mallongigojVerkaj: verkajMallongigoj,
			mallongigojVortaraj: vortarajMallongigoj,
			urloj: urloj)
	}
	
	func skribi(json indikilo: String) {
		try! JSONEncoder().encode(self).write(to: URL(fileURLWithPath: indikilo + "/grundo.json"))
	}
	
	func skribi(en konteksto: NSManagedObjectContext) {
		LingvoAnalizilo.registri(lingvojn: lingvoj, en: konteksto)
		FakoAnalizilo.registri(fakojn: fakoj, en: konteksto)
		VortarajMallongigojAnalizilo.registri(mallongigojn: mallongigojVortaraj, en: konteksto)
		StiloAnalizilo.registri(stilojn: stiloj, en: konteksto)
		Oficialecoj.aldoni(al: konteksto)
	}
}
