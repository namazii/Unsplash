//
//  Model.swift
//  CollectionImage
//
//  Created by Назар Ткаченко on 05.05.2022.
//

import Foundation

struct ImageResult: Codable {
    let results: [ImageElement]
}

// MARK: - ImageElement
struct ImageElement: Codable {
    let id: String
    let createdAt: String
    let description: String?
    let urls: Urls
    let likes: Int
    let user: User
    let location: Location
    let downloads: Int

}

// MARK: - User
struct User: Codable {
    let id: String
    let name: String
}

// MARK: - Location
struct Location: Codable {
    let name: String?
}

// MARK: - Urls
struct Urls: Codable {
    let full: String
    let thumb: String
    let regular: String
}
