//
//  Vorto.swift
//  PoshReVo
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation

/*
    Reprezentas unu aŭ plurajn vortojn havantajn unu saman difinon.
*/
public struct Vorto {
    public let titolo: String
    public let teksto: String
    public let marko: String?
    public let ofc: String?
    
    public init(titolo: String, teksto: String, marko: String?, ofc: String?) {
        self.titolo = titolo
        self.teksto = teksto
        self.marko = marko
        self.ofc = ofc
    }
}
