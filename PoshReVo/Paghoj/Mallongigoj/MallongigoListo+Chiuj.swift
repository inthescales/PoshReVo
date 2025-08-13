extension MallongigoListoj {
	/// Ĉiuj mallongigoj de ĉiuj specoj
	static var chiuj: [(String, String)] = {
		let sumo: [(String, String)] = Self.vortaraj + Self.fakaj + Self.bibliografiaj
		return sumo.sorted { lhs, rhs in
			lhs.0 < rhs.0
		}
	}()
}
