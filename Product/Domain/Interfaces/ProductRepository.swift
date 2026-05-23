//
//  ProductRepository.swift
//  Product
//
//  Created by Omar on 23/05/2026.
//

import Foundation

protocol ProductRepository {
    func getProducts(completion: @escaping (Result<[Product], Error>) -> Void)
    func saveProduct(product: Product)
}
