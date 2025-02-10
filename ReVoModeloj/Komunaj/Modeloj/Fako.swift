//
//  Fako.swift
//  PoshReVo
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation

/*
    Reprezentas fakon al kiu apartenas vorto aŭ frazaĵo. Uzataj en kelkaj difinoj.
 */
public struct Fako: Codable {
    public let kodo: String
    public let nomo: String
    
    public init(kodo: String, nomo: String) {
        self.kodo = kodo
        self.nomo = nomo
    }
}

// MARK: - Equatable

extension Fako: Equatable {
    public static func ==(lhs: Fako, rhs: Fako) -> Bool {
        return lhs.kodo == rhs.kodo && lhs.nomo == rhs.nomo
    }
}

// MARK: - Comparable

extension Fako: Comparable {
    public static func < (lhs: Fako, rhs: Fako) -> Bool {
        return lhs.nomo.compare(rhs.nomo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
    }
}
