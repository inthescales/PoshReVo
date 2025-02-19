//
//  DatumbazAlirilo.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 8/18/19.
//  Copyright © 2019 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

final class DatumbazAlirilo {
    
    let konteksto: NSManagedObjectContext
    
    public init(konteksto: NSManagedObjectContext) {
        self.konteksto = konteksto
    }
    
    // MARK: - Serĉi individuajn objektojn
    
    func lingvo(porKodo kodo: String) -> NSManagedObject? {
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Lingvo", in: konteksto)
        serchPeto.predicate = NSPredicate(format: "kodo == %@", argumentArray: [kodo])
        do {
            return try konteksto.fetch(serchPeto).first as? NSManagedObject
        } catch {
            
        }
        
        return nil
    }
    
    func fako(porKodo kodo: String) -> NSManagedObject? {
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Fako", in: konteksto)
        serchPeto.predicate = NSPredicate(format: "kodo == %@", argumentArray: [kodo])
        do {
            return try konteksto.fetch(serchPeto).first as? NSManagedObject
        } catch {
            
        }
        
        return nil
    }
    
    func oficialeco(porKodo kodo: String) -> NSManagedObject? {
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Oficialeco", in: konteksto)
        serchPeto.predicate = NSPredicate(format: "kodo == %@", argumentArray: [kodo])
        do {
            return try konteksto.fetch(serchPeto).first as? NSManagedObject
        } catch {
            
        }
        
        return nil
    }
    
    func artikolo(porIndekso indekso: String) -> NSManagedObject? {
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Artikolo", in: konteksto)
        serchPeto.predicate = NSPredicate(format: "indekso == %@", argumentArray: [indekso])
        do {
            return try konteksto.fetch(serchPeto).first as? NSManagedObject
        } catch {
            
        }
        
        return nil
    }
    
    // MARK: - Kolekti klasojn da objektoj
    
    public func vortoj(oficialeco: String) -> [NSManagedObject]? {
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Artikolo", in: konteksto)
        serchPeto.predicate = NSPredicate(format: "ofc == %@", argumentArray: [oficialeco])
        do {
            return try konteksto.fetch(serchPeto) as? [NSManagedObject]
        } catch {
            
        }
        
        return nil
    }
        
    public func fakVortoj(porFako kodo: String) -> [NSManagedObject]? {

        if let fako = fako(porKodo: kodo) {
            let vortoj = fako.mutableSetValue(forKey: "fakvortoj").allObjects as? [NSManagedObject]
            return vortoj?.sorted(by: { (unua: NSManagedObject, dua: NSManagedObject) -> Bool in
                let unuaNomo = unua.value(forKey: "teksto") as! String
                let duaNomo = dua.value(forKey: "teksto") as! String
                return unuaNomo.compare(duaNomo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
            })
        }
        
        return nil
    }
    
    public func ofcVortoj(porOficialeco kodo: String) -> [NSManagedObject]? {
        
        if let oficialeco = oficialeco(porKodo: kodo) {
            let vortoj = oficialeco.mutableSetValue(forKey: "ofcvortoj").allObjects as? [NSManagedObject]
            return vortoj?.sorted(by: { (unua: NSManagedObject, dua: NSManagedObject) -> Bool in
                let unuaNomo = unua.value(forKey: "teksto") as! String
                let duaNomo = dua.value(forKey: "teksto") as! String
                return unuaNomo.compare(duaNomo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
            })
        }
        
        return nil
    }
    
    // MARK: - Kolekti ĉiujn objektojn
    
    func chiujLingvoj() -> [NSManagedObject] {
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Lingvo", in: konteksto)
        do {
            if let objektoj = try konteksto.fetch(serchPeto) as? [NSManagedObject] {
                return objektoj
            }
        } catch { }
        
        return []
    }
    
    func chiujFakoj() -> [NSManagedObject] {
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Fako", in: konteksto)
        do {
            if let objektoj = try konteksto.fetch(serchPeto) as? [NSManagedObject] {
                return objektoj
            }
        } catch { }
        
        return []
    }
    
    func chiujStiloj() -> [NSManagedObject] {
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Stilo", in: konteksto)
        do {
            if let objektoj = try konteksto.fetch(serchPeto) as? [NSManagedObject] {
                return objektoj
            }
        } catch { }
        
        return []
    }
    
    func chiujMallongigoj() -> [NSManagedObject] {
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Mallongigo", in: konteksto)
        do {
            if let objektoj = try konteksto.fetch(serchPeto) as? [NSManagedObject] {
                return objektoj
            }
        } catch { }
        
        return []
    }
    
    func chiujOficialecoj() -> [NSManagedObject] {
        
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Oficialeco", in: konteksto)
        do {
            if let objektoj = try konteksto.fetch(serchPeto) as? [NSManagedObject] {
                return objektoj
            }
        } catch { }
        
        return []
    }
    
    // MARK: - Aliaj
    
    func iuAjnArtikolo() -> NSManagedObject? {
        let kvanto = kvantoDeArtikoloj()
        let numero = Int.random(in: 0..<kvanto)
        let serchPeto = NSFetchRequest<NSFetchRequestResult>()
        serchPeto.entity = NSEntityDescription.entity(forEntityName: "Artikolo", in: konteksto)
        serchPeto.predicate = NSPredicate(format: "numero == %@", argumentArray: [numero])
        do {
            return try konteksto.fetch(serchPeto).first as? NSManagedObject
        } catch {}
        
        return nil
    }
    
    // MARK: - Helpiloj
    
    private func kvantoDeArtikoloj() -> Int {
        let kvantoPeto = NSFetchRequest<NSFetchRequestResult>()
        kvantoPeto.entity = NSEntityDescription.entity(forEntityName: "Artikolo", in: konteksto)
        
        do {
            return try konteksto.count(for: kvantoPeto)
        } catch {}
    
        return 0
    }
}
