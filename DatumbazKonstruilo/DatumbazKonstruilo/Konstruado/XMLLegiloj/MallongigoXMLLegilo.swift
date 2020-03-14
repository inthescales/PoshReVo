//
//  MallongigoXMLLegilo.swift
//  DatumbazKonstruilo
//
//  Created by Robin Hill on 3/14/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation
import CoreData

class MallongigoXMLLegilo: NSObject, XMLParserDelegate {
    
    public var mallongigoKvanto = 0
    
    private let konteksto: NSManagedObjectContext
    private var nunaMallongigo: NSManagedObject?
    private var mallongigoNomo: String = ""
    
    init(_ konteksto: NSManagedObjectContext) {
        self.konteksto = konteksto
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "mallongigo", let kodo = attributeDict["mll"] {
            nunaMallongigo = NSEntityDescription.insertNewObject(forEntityName: "Mallongigo", into: konteksto)
            nunaMallongigo?.setValue(kodo, forKey: "kodo")
            mallongigoNomo = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        mallongigoNomo += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "mallongigo" {
            if let nunaMallongigo = nunaMallongigo {
                nunaMallongigo.setValue(mallongigoNomo, forKey: "nomo")
                mallongigoKvanto += 1
            }
        }
    }
}
