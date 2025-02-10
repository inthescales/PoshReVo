//
//  Stilo.swift
//  PoshReVo
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation

/*
    Reprezentas skriban stilon. Uzataj en kelkaj difinoj.
 */
public struct Stilo: Codable {
    public let kodo: String
    public let nomo: String
    
    public init(kodo: String, nomo: String) {
        self.kodo = kodo
        self.nomo = nomo
    }
}

// MARK: - Equatable

extension Stilo: Equatable {
    public static func ==(lhs: Stilo, rhs: Stilo) -> Bool {
        return lhs.kodo == rhs.kodo && lhs.nomo == rhs.nomo
    }
}

// MARK: - Comparable

extension Stilo: Comparable {
    public static func < (lhs: Stilo, rhs: Stilo) -> Bool {
        return lhs.nomo.compare(rhs.nomo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
    }
}
