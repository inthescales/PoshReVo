import Foundation

enum GrundoAlJSON {
	/// Konvertas grundaĵojn en JSON-ajn dosierojn.
	/// Uzata por provizi la testojn je fidindajn grund-datumojn
	static func konverti(el grundoIndikilo: String, al destino: String) {
		let lingvoj = LingvoAnalizilo.legi(el: grundIndiko + "/cfg/lingvoj.xml")
			.map { ["nomo": $0.nomo, "kodo": $0.kodo] }
		try! JSONEncoder().encode(lingvoj).write(to: URL(fileURLWithPath: destino + "/lingvoj.json"))

		let fakoj = FakoAnalizilo.legi(el: grundIndiko + "/cfg/fakoj.xml")
			.map { ["nomo": $0.nomo, "kodo": $0.kodo] }
		try! JSONEncoder().encode(fakoj).write(to: URL(fileURLWithPath: destino + "/fakoj.json"))

		let stiloj = StiloAnalizilo.legi(el: grundIndiko + "/cfg/stiloj.xml")
			.map { ["nomo": $0.nomo, "kodo": $0.kodo] }
		try! JSONEncoder().encode(stiloj).write(to: URL(fileURLWithPath: destino + "/stiloj.json"))

		let signoj = SignoAnalizilo.analizi(el: grundIndiko + "/dtd/vokosgn.dtd")
		try! JSONEncoder().encode(signoj).write(to: URL(fileURLWithPath: destino + "/signoj.json"))
		
		let mallongigoj = DTDAnalizilo.entoj(el: grundIndiko + "/dtd/vokomll.dtd")
		try! JSONEncoder().encode(mallongigoj).write(to: URL(fileURLWithPath: destino + "/mallongigoj.json"))

		let urloj = DTDAnalizilo.entoj(el: grundIndiko + "/dtd/vokourl.dtd")
		try! JSONEncoder().encode(urloj).write(to: URL(fileURLWithPath: destino + "/urloj.json"))
	}
}
