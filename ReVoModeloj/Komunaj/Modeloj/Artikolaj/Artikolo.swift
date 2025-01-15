//
//  Artikolo.swift
//  PoshReVo
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

/*
    Reprezentas la enhavojn de tuta paĝo en la vortaro.
*/
public final class Artikolo {
    public let titolo: String
    public let radiko: String
    public let indekso: String
    public let ofc: String?
    public let subartikoloj: [Subartikolo]
    public let tradukoj: [Traduko]
    
    public init(titolo: String,
                radiko: String,
                indekso: String,
                ofc: String?,
                subartikoloj: [Subartikolo],
                tradukoj: [Traduko]) {
        self.titolo = titolo
        self.radiko = radiko
        self.indekso = indekso
        self.ofc = ofc
        self.subartikoloj = subartikoloj
        self.tradukoj = tradukoj
    }
}
