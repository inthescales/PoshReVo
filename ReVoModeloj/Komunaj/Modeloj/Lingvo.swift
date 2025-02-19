//
//  Lingvo.swift
//  PoshReVo
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation

/*
    Reprezentas lingvon ekzistantan en la vortaro.
    Uzata en serĉado kaj listigado de tradukoj en artikoloj.
*/
public final class Lingvo : NSObject, Codable {
    
    public let kodo: String
    public let nomo: String
    
    public init(kodo: String, nomo: String) {
        self.kodo = kodo
        self.nomo = nomo
    }
    
    public override var hash: Int {
        return kodo.hashValue
    }
	
	
	public static var esperanto: Lingvo {
		return Lingvo(kodo: "eo", nomo: "Esperanto")
	}
}

// MARK: - Equatable

extension Lingvo {
    public override func isEqual(_ object: Any?) -> Bool {
        if let lingvo = object as? Lingvo {
            return self == lingvo
        }
        else {
            return false
        }
    }
    
    public static func ==(lhs: Lingvo, rhs: Lingvo) -> Bool {
        return lhs.kodo == rhs.kodo && lhs.nomo == rhs.nomo
    }
}

// MARK: - Comparable

extension Lingvo: Comparable {
    public static func < (lhs: Lingvo, rhs: Lingvo) -> Bool {
        return lhs.nomo.compare(rhs.nomo, options: .caseInsensitive, range: nil, locale: Locale(identifier: "eo")) == .orderedAscending
    }
}

