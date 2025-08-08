extension Fako {
	/// Kelkajn kodojn aperu en artikoloj kaj mallongigolistoj alie ol siaj internaj formoj
	static func netaKodo(por kodo: String) -> String {
		switch kodo {
		case "AUT":
			return "AŬT"
		case "MAS":
			return "MAŜ"
		case "POSX":
			return "POŜ"
		case "SHI":
			return "ŜIP"
		default:
			return kodo
		}
	}
}
