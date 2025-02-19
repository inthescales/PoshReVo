//
//  Oficialeco+ReVoDatumbazo.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 8/22/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import CoreData

extension Oficialeco {
    
    public static func elDatumbazObjekto(_ objekto: NSManagedObject) -> Oficialeco? {
        if let kodo = objekto.value(forKey: "kodo") as? String,
            let indikilo = objekto.value(forKey: "indikilo") as? String,
            let nomo = objekto.value(forKey: "nomo") as? String {
            return Oficialeco(kodo: kodo, indikilo: indikilo, nomo: nomo)
        }
        
        return nil
    }
}

// MARK: - Equatable

extension Oficialeco: Equatable {
    public static func ==(lhs: Oficialeco, rhs: Oficialeco) -> Bool {
        return lhs.kodo == rhs.kodo && lhs.indikilo == rhs.indikilo && lhs.nomo == rhs.nomo
    }
}

// MARK: - Comparable

extension Oficialeco: Comparable {
    public static func < (lhs: Oficialeco, rhs: Oficialeco) -> Bool {
        if lhs.kodo == "*" || rhs.kodo == "n" { return true }
        if lhs.kodo == "n" || rhs.kodo == "*" { return false }
        if lhs.kodo == "a" && rhs.kodo != "n" { return false }
        if lhs.kodo != "n" && rhs.kodo == "a" { return true }
        return lhs.nomo.compare(rhs.nomo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
    }
}
