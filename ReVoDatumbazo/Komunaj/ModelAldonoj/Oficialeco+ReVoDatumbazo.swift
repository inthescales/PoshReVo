//
//  Oficialeco+ReVoDatumbazo.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 8/22/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import CoreData

extension Oficialeco {
	func skribi(en konteksto: NSManagedObjectContext) {
		let objekto = NSEntityDescription.insertNewObject(forEntityName: "Oficialeco", into: konteksto)
		objekto.setValue(kodo, forKey: "kodo")
		objekto.setValue(indikilo, forKey: "indikilo")
		objekto.setValue(nomo, forKey: "nomo")
		objekto.setValue(vico, forKey: "vico")
	}
	
    public static func el(_ objekto: NSManagedObject) -> Oficialeco? {
        if let kodo = objekto.value(forKey: "kodo") as? String,
            let nomo = objekto.value(forKey: "nomo") as? String,
			let vico = objekto.value(forKey: "vico") as? Int {
			let indikilo = (objekto.value(forKey: "indikilo") as? String) ?? ""
			return Oficialeco(kodo: kodo, indikilo: indikilo, nomo: nomo, vico: vico)
        }
        
        return nil
    }
}
