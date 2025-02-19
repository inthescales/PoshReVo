struct AliriloKashMemorero<K> {
    var kompleta: Bool = false
    var enhavoj: [K] = []
}

struct AliriloKashMemoro {
    static var lingvoj = AliriloKashMemorero<Lingvo>()
    static var fakoj = AliriloKashMemorero<Fako>()
}
