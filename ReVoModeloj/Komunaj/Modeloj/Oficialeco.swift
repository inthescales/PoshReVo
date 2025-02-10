//
//  Oficialeco.swift
//  ReVoModeloj
//
//  Created by Robin Hill on 8/22/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation

/*
    Reprezentas oficialeco-indikolo, ekzemple de fundamento aŭ oficiala aldono
 */
public struct Oficialeco: Codable {
    public let kodo: String
    public let indikilo: String
    public let nomo: String
    
    public init(kodo: String, indikilo: String, nomo: String) {
        self.kodo = kodo
        self.indikilo = indikilo
        self.nomo = nomo
    }
}
