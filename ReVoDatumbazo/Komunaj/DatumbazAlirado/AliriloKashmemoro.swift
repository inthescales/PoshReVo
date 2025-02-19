//
//  AliriloKashMemoro.swift
//  ReVoDatumbazo
//
//  Created by Robin Hill on 7/3/20.
//  Copyright © 2020 Robin Hill. All rights reserved.
//

struct AliriloKashMemorero<K> {
    var kompleta: Bool = false
    var enhavoj: [K] = []
}

struct AliriloKashMemoro {
    static var lingvoj = AliriloKashMemorero<Lingvo>()
    static var fakoj = AliriloKashMemorero<Fako>()
}
