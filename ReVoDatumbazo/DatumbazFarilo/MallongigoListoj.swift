import Foundation

final class MallongigoListoj {
	static let dosiernomo = "MallongigoListo.swift"

	public static func generiDosieron(fakoj: [Fako], mallongigoj: [Mallongigo], destinIndiko: String) {
		let teksto = fariKodon(fakoj: fakoj, mallongigoj: mallongigoj)
		let destino = URL(fileURLWithPath: destinIndiko + "/" + dosiernomo)
		skribiListojn(teksto: teksto, destino: destino)
    }
	
	private static func skribiListojn(teksto: String, destino: URL) {
		do {
			try teksto.write(to: destino, atomically: false, encoding: .utf8)
		}
		catch {
			print("Eraro: Ne sukcesis generi mallongigolistojn.")
		}
	}
    
	private static func fariKodon(fakoj: [Fako], mallongigoj: [Mallongigo]) -> String {
        print("Verkas mallongigolistojn")
        
        var teksto = ""
		
		teksto += "// Komputile generataj mallongigo-listoj\n"
		teksto += "// Ne ŝanĝu mane. Vidu 'MallongigoListoj.swift' en ReVoDatumbazo.\n"
        teksto += "\n"
		teksto += "final class MallongigoListo {\n"
		teksto += kodigiVortarajnMallongigojn(mallongigoj: mallongigoj).marghenShovi()
		teksto += "\n\n"
		teksto += kodigiFakajnMallongigojn(fakoj: fakoj).marghenShovi()
		teksto += "\n}\n"
		
        return teksto
    }
    
	/// Faras swift-kodon kodigante aron da vortaraj mallongigoj (ekz. "a. K.", "ekz." )
	private static func kodigiVortarajnMallongigojn(mallongigoj: [Mallongigo]) -> String {
		var teksto =  "/// Tekstaj mallongigoj uzataj en artikoloj\n"
		teksto += "static let vortaraj = [\n"
		for mallongigo in mallongigoj.sorted() {
			teksto += "\t(\"" + mallongigo.kodo + "\", \"" + mallongigo.nomo + "\"),\n"
        }
		teksto += "]"
        
        return teksto
    }
    
	/// Faras swift-kodon kodigante aron da fakaj mallongigoj (ekz. "BEL", "MAŜ")
	private static func kodigiFakajnMallongigojn(fakoj: [Fako]) -> String {
		var teksto = "/// Mallongaj faknomoj, uzataj anstataŭ bildetoj en ĉi-apo\n"
		teksto += "static let fakaj = [\n"
		for fako in fakoj.sorted() {
			teksto += "\t(\"" + fako.kodo + "\", \"" + fako.nomo + "\"),\n"
        }
		teksto += "]"
		
		return teksto
    }
}

// MARK: - Helpiloj

fileprivate extension String {
	/// Aldonas tabon al komenco di ĉiu linio
	func marghenShovi() -> String {
		// ("\t" + self).replacingOccurrences(of: "\n", with: "\n\t")
		let disigitaj = self.split(separator: "\n")
		return "\t" + disigitaj.joined(separator: "\n\t")
	}
}
