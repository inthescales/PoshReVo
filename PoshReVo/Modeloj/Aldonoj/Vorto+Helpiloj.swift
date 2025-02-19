import ReVoDatumbazo

extension Vorto {
    
    // Titolo de vorto, havanta indikilon de oficialeco
    var kunaTitolo: String {
        if let verOfc = ofc {
            return titolo + Iloj.superLit(verOfc)
        } else {
            return titolo
        }
    }
}
