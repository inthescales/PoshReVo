//
//  StiloTestoj.swift
//  PoshReVoUnuopTestoj
//
//  Created by Robin Hill on 5/4/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

import XCTest

@testable import ReVoModeloj

final class StiloTestoj: XCTestCase {
    
    func testKreiStilon() {
        let fig = Stilo("FIG", "figure")
        XCTAssertEqual(fig.kodo, "FIG")
        XCTAssertEqual(fig.nomo, "figure")
        
        let fraz = Stilo("FRAZ", "frazaĵo")
        XCTAssertEqual(fraz.kodo, "FRAZ")
        XCTAssertEqual(fraz.nomo, "frazaĵo")
    }
}
