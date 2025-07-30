extension ArboAnalizilo {
	static func traktiFonton(akumulilo: BlokAkumulilo, stato: Stato) {
		switch stato.sibStako.last {
		case .uzo(_):
			// Lasu spacon post uzo
			break
		default:
			akumulilo.tondiTekston()
		}
	}
	
	static func traktiFonton(teksto: String, stato: Stato) -> String {
		switch stato.sibStako.last {
		case .uzo(_):
			// Lasu spacon post uzo
			return teksto
		default:
			return teksto.tondi()
		}
	}
}
