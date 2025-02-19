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
public final class Artikolo: Codable {
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
	
	public func encode(to encoder: any Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(titolo, forKey: .titolo)
		try container.encode(radiko, forKey: .radiko)
		try container.encode(indekso, forKey: .indekso)
		try ofc.flatMap { try container.encode($0, forKey: .ofc) }
		
		try container.encode(subartikoloj, forKey: .subartikoloj)
		
		// Alfabetigi tradukojn tiel ke ĝi ĉiam je sama ordigo
		try container.encode(tradukoj.sorted(by: { $0.lingvo < $1.lingvo }), forKey: .tradukoj)
	}
}
