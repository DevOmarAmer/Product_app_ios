//
//  ProductDTO.swift
//  Product
//
//  Created by Omar on 23/05/2026.
//

import Foundation

struct ProductResponseDTO: Codable {
    let products: [ProductDTO]
}

struct ProductDTO: Codable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let thumbnail: String
    
    func toDomain() -> Product {
        return Product(id: id, title: title, description: description, price: price, thumbnail: thumbnail)
    }
}
