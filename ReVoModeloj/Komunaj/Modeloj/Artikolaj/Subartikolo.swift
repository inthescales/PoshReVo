//
//  Subartikolo.swift
//  PoshReVo
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation

/*
    Parto de artikolo havanta sian propran tekstojn supre de listo da vortoj.
*/
public struct Subartikolo {
    public let teksto: String
    public let vortoj: [Vorto]
    
    public init(teksto: String, vortoj: [Vorto]) {
        self.teksto = teksto
        self.vortoj = vortoj
    }
}
