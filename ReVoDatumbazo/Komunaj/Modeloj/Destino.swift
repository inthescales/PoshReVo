//
//  Destino.swift
//  ReVoModeloj
//
//  Created by Robin Hill on 7/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

#if os(iOS)
import ReVoModeloj
#elseif os(macOS)
import ReVoModelojOSX
#endif

public struct Destino {
    let artikolObjekto: NSManagedObject
    public let nomo: String
    public let teksto: String
    public let indekso: String
    public let marko: String?
    public let senco: String?
    
    public init?(objekto: NSManagedObject) {
        
        guard let artikolObjekto = objekto.value(forKey: "artikolo") as? NSManagedObject else {
            return nil
        }
        
        self.artikolObjekto = artikolObjekto
        
        guard let teksto = objekto.value(forKey: "teksto") as? String,
            let indekso = objekto.value(forKey: "indekso") as? String else {
                return nil
        }
		
		// Nomo nur necesas se montriĝos subtitolon
		let nomo = objekto.value(forKey: "nomo") as? String ?? teksto

        let marko = objekto.value(forKey: "marko") as? String
        let senco = objekto.value(forKey: "senco") as? String
        
        self.nomo = nomo
        self.teksto = teksto
        self.indekso = indekso
        self.marko = marko
        self.senco = senco
    }

    
    public func artikolo(enVortaro vortaro: VortaroDatumbazo) -> Artikolo? {
        return Artikolo.elDatumbazObjekto(objekto: artikolObjekto, datumbazo: vortaro)
    }
}

// MARK: - Equatable

extension Destino: Equatable {
    public static func ==(lhs: Destino, rhs: Destino) -> Bool {
        return lhs.nomo == rhs.marko &&
            lhs.teksto == rhs.teksto &&
            lhs.indekso == rhs.indekso &&
            lhs.marko == rhs.marko &&
            lhs.senco == rhs.senco &&
            lhs.artikolObjekto == rhs.artikolObjekto
    }
}

// MARK: - Comparable

extension Destino: Comparable {
    public static func < (lhs: Destino, rhs: Destino) -> Bool {
        return lhs.nomo.compare(rhs.nomo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
    }
}
