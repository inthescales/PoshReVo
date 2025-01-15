//
//  Mallongigo.swift
//  PoshReVo
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import Foundation

/*
    Reprezentas vortaran mallongigon, kiuj inkluzivas fontojn, verikistojn, aldonojn.
 */
public struct Mallongigo {
    public let kodo: String
    public let nomo: String
    
    public init(kodo: String, nomo: String) {
        self.kodo = kodo
        self.nomo = nomo
    }
}

// MARK: - Comparable

extension Mallongigo: Comparable {
	public static func < (lhs: Mallongigo, rhs: Mallongigo) -> Bool {
		lhs.kodo.compare(
			rhs.kodo,
			options: .caseInsensitive,
			range: nil,
			locale: Locale(identifier: "eo")
		) == .orderedAscending
	}
}
