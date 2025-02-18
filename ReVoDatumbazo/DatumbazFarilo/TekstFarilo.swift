import Foundation

import ReVoModelojOSX

final class TekstFarilo {

	public static func generiTekstojn(fakoj: [Fako], mallongigoj: [Mallongigo], destinIndiko: String) {
		let teksto = fariTekstojn(fakoj: fakoj, mallongigoj: mallongigoj)
		let fileURL = URL(fileURLWithPath: destinIndiko + "/Generataj.strings")
				
        do {
            try teksto.write(to: fileURL, atomically: false, encoding: .utf8)
        }
        catch {
            print("Eraro: Ne sukcesis generi tekstojn.")
        }
    }
    
	private static func fariTekstojn(fakoj: [Fako], mallongigoj: [Mallongigo]) -> String {
        
        print("Verkas tekstojn")
        
        var teksto = ""
		teksto += "// Komputile generataj tekstoj\n"
		teksto += "// Ne ŝanĝu mane. Vidu 'TekstFarilo.swift' en DatumbazKonstruilo.\n"
        teksto += "\n"
		teksto += fariVortaroMallongiganTekston(mallongigoj: mallongigoj)
		teksto += fariFakoMallongiganTekston(fakoj: fakoj)
        return teksto
    }
    
	private static func fariVortaroMallongiganTekston(mallongigoj: [Mallongigo]) -> String {
        var teksto = ""
		for mallongigo in mallongigoj.sorted() {
			teksto += "<b>" + mallongigo.kodo + "</b>\\\n    " + mallongigo.nomo + "\\\n\n"
        }
        
        return "\"informoj vortaraj-mallongigoj teksto\"\t\t\t= \"" + teksto + "\";\n"
    }
    
	private static func fariFakoMallongiganTekston(fakoj: [Fako]) -> String {
        var teksto = ""
		for fako in fakoj.sorted() {
			teksto += "<b>" + fako.kodo + "</b>\\\n    " + fako.nomo + "\\\n\n"
        }
        
        return "\"informoj fakaj-mallongigoj teksto\"\t\t\t\t= \"" + teksto + "\";\n"
    }
    
}
