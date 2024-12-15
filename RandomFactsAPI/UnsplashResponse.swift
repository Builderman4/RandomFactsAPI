//
//  UnsplashResponse.swift
//  RandomFactsAPI
//
//  Created by Ibrahim Syed on 2024-12-14.
//

import Foundation

struct UnsplashResponse: Codable {
    let results: [UnsplashImage]
}

struct UnsplashImage: Codable {
    let id: String
    let description: String?
    let urls: UnsplashImageURLs
}

struct UnsplashImageURLs: Codable {
    let regular: String
}
