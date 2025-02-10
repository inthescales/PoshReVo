enum SignoAnalizilo {
	static func analizi(el indikilo: String) -> [String: String] {
		var signoj = DTDAnalizilo.entoj(el: indikilo)
		
		// Kelkaj aldonoj estas necesaj — ĉi-signoj aperas en artikoloj tamen ne
		// estas difinitaj en la signo-dokumento
		signoj["a_a"] = signoj["a_A"]
		signoj["a_fatha_a"] = signoj["a_fatha_A"]
		
		return signoj
	}
}
