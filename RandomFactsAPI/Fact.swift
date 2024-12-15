//
//  Fact.swift
//  RandomFactsAPI
//
//  Created by Ibrahim Syed on 2024-12-14.
//

import Foundation

struct Fact: Codable {
    let text: String
    let id: String
    let source: String
    let sourceUrl: String
    let language: String
    let permalink: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case source
        case sourceUrl = "source_url"
        case language
        case permalink
    }
    
}
