import ReVoModelojOSX

extension Artikolo: CustomStringConvertible {
	public var description: String {
		var rezulto = ""
		
		rezulto += String(repeating: "=", count: titolo.count) + "\n"
		rezulto += titolo + "\n"
		rezulto += String(repeating: "=", count: titolo.count) + "\n"
		rezulto += "\n"
		for subartikolo in subartikoloj {
			if subartikoloj.count > 1 {
				rezulto += String(repeating: "=", count: 20) + "\n"
			}
			if !subartikolo.teksto.isEmpty {
				rezulto += subartikolo.teksto + "\n"
			}
			
			for vorto in subartikolo.vortoj {
				rezulto += String(repeating: "-", count: 20) + "\n"
				rezulto += vorto.titolo + " (\(vorto.ofc ?? "n"))" + "\n"
				rezulto += String(repeating: "-", count: 20) + "\n"
				rezulto += vorto.teksto + "\n"
				rezulto += String(repeating: "-", count: 20) + "\n\n"
			}
			
			if subartikoloj.count > 1 {
				rezulto += String(repeating: "=", count: 20) + "\n"
			}
		}
		
		if subartikoloj.count == 1 {
			rezulto += String(repeating: "=", count: 20) + "\n"
		}
		
		for traduko in tradukoj.sorted(by: { $0.lingvo < $1.lingvo }) {
			rezulto += String(repeating: "-", count: 20) + "\n"
			rezulto += "(\(traduko.lingvo.nomo))\n"
			rezulto += traduko.teksto + "\n"
		}
		rezulto += String(repeating: "-", count: 20) + "\n"
		
		return rezulto
	}
}
