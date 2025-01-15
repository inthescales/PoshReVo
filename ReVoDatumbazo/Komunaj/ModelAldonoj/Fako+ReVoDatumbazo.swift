//
//  Fako+ReVoDatumbazo.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 7/3/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import CoreData

#if os(iOS)
import ReVoModeloj
#elseif os(macOS)
import ReVoModelojOSX
#endif

extension Fako {
	public func skribi(en konteksto: NSManagedObjectContext) {
		let objekto = NSEntityDescription.insertNewObject(forEntityName: "Fako", into: konteksto)
		objekto.setValue(kodo, forKey: "kodo")
		objekto.setValue(nomo, forKey: "nomo")
	}
	
    public static func elDatumbazObjekto(_ objekto: NSManagedObject) -> Fako? {
        if let kodo = objekto.value(forKey: "kodo") as? String,
           let nomo = objekto.value(forKey: "nomo") as? String {
            return Fako(kodo: kodo, nomo: nomo)
        }
        
        return nil
    }
}
