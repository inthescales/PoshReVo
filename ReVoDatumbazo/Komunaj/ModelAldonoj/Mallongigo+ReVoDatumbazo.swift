//
//  Mallongigo+ReVoDatumbazo.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 7/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import CoreData

#if os(iOS)
import ReVoModeloj
#elseif os(macOS)
import ReVoModelojOSX
#endif

extension Mallongigo {
    
    public static func elDatumbazObjekto(_ objekto: NSManagedObject) -> Mallongigo? {
        if let kodo = objekto.value(forKey: "kodo") as? String,
           let nomo = objekto.value(forKey: "nomo") as? String {
            return Mallongigo(kodo: kodo, nomo: nomo)
        }
        
        return nil
    }
}

// MARK: - Equatable

extension Mallongigo: Equatable {
    public static func ==(lhs: Mallongigo, rhs: Mallongigo) -> Bool {
        return lhs.kodo == rhs.kodo && lhs.nomo == rhs.nomo
    }
}

// MARK: - Comparable

extension Mallongigo: Comparable {
    public static func < (lhs: Mallongigo, rhs: Mallongigo) -> Bool {
        return lhs.nomo.compare(rhs.nomo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
    }
}
