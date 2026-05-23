//
//  FetchProductsUseCase.swift
//  Product
//
//  Created by Omar on 23/05/2026.
//

import Foundation

class FetchProductsUseCase {
    private let repository: ProductRepository
    
    init(repository: ProductRepository) {
        self.repository = repository
    }
    
    func execute(completion: @escaping (Result<[Product], Error>) -> Void) {
        repository.getProducts(completion: completion)
    }
    
    func saveNewProduct(product: Product) {
        repository.saveProduct(product: product)
    }
}
