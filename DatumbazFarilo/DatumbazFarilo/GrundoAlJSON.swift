import Foundation
import ReVoModelojOSX

enum GrundoAlJSON {
	/// Konvertas grundaĵojn en JSON-ajn dosierojn.
	/// Uzata por provizi la testojn je fidindajn grund-datumojn
	static func konverti(
		el grundoIndikilo: String,
		al destino: String,
		lingvoj: [Lingvo],
		stiloj: [Stilo],
		signoj: [String: String],
		mallongigoj: [String: String],
		urloj: [String: String]
	) {
		let lingvojDict = lingvoj.map { ["nomo": $0.nomo, "kodo": $0.kodo] }
		try! JSONEncoder().encode(lingvojDict).write(to: URL(fileURLWithPath: destino + "/lingvoj.json"))
		
		let stilojDict = stiloj.map { ["nomo": $0.nomo, "kodo": $0.kodo] }
		try! JSONEncoder().encode(stilojDict).write(to: URL(fileURLWithPath: destino + "/stiloj.json"))
		
		try! JSONEncoder().encode(signoj).write(to: URL(fileURLWithPath: destino + "/signoj.json"))
		try! JSONEncoder().encode(mallongigoj).write(to: URL(fileURLWithPath: destino + "/mallongigoj.json"))
		try! JSONEncoder().encode(urloj).write(to: URL(fileURLWithPath: destino + "/urloj.json"))
	}
	
	/// Legas grundaĵojn kaj JSONigas ilin
	static func konverti(el grundoIndikilo: String, al destino: String) {
		let lingvoj = LingvoAnalizilo.legi(el: grundIndiko + "/cfg/lingvoj.xml")
		let stiloj = StiloAnalizilo.legi(el: grundIndiko + "/cfg/stiloj.xml")
		let signoj = SignoAnalizilo.analizi(el: grundIndiko + "/dtd/vokosgn.dtd")
		let mallongigoj = DTDAnalizilo.entoj(el: grundIndiko + "/dtd/vokomll.dtd")
		let urloj = DTDAnalizilo.entoj(el: grundIndiko + "/dtd/vokourl.dtd")
		
		GrundoAlJSON.konverti(
			el: grundIndiko,
			al: radiko + "/produktajhoj/json",
			lingvoj: lingvoj,
			stiloj: stiloj,
			signoj: signoj,
			mallongigoj: mallongigoj,
			urloj: urloj
		)
	}
}
