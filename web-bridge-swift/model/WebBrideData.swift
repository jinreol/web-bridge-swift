//
//  WebBrideData.swift
//  web-bridge-swift
//
//  Created by 60104968 on 2021/07/23.
//

import Foundation

// ================================================================
// Web <-> Native 통신용 구조체
// ================================================================
struct WebBrideData: Codable {
    var command: String
    var data: String
}
