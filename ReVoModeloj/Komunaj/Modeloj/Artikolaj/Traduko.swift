//
//  Traduko.swift
//  PoshReVo
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation

/*
    Traduko de esperanta vorto en alian lingvon.
*/
public struct Traduko: Codable {
    public let lingvo: Lingvo
    public let teksto: String
    
    public init(lingvo: Lingvo, teksto: String) {
        self.lingvo = lingvo
        self.teksto = teksto
    }
}
