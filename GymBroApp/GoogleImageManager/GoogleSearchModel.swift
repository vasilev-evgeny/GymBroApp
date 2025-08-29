//
//  GoogleSearchModel.swift
//  GymBroApp
//
//  Created by Евгений Васильев on 28.08.2025.
//
import Foundation

struct GoogleSearchResult: Codable {
    let items: [GoogleImageItem]?
}

struct GoogleImageItem: Codable {
    let link: String
    let image: GoogleImageInfo?
}

struct GoogleImageInfo: Codable {
    let thumbnailLink: String?
    let width: Int?
    let height: Int?
    
    enum CodingKeys: String, CodingKey {
        case thumbnailLink = "thumbnailLink"
        case width, height
    }
}
