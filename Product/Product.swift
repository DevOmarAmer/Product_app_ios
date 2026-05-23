import Foundation

struct ProductResponse: Codable {
    let products: [Product]
}

struct Product: Codable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let thumbnail: String
}
