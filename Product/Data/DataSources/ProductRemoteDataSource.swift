//
//  ProductRemoteDataSource.swift
//  Product
//
//  Created by Omar on 23/05/2026.
//

import Foundation

protocol ProductRemoteDataSourceProtocol {
    func fetchProducts(completion: @escaping (Result<[ProductDTO], Error>) -> Void)
}

class ProductRemoteDataSource: ProductRemoteDataSourceProtocol {
    func fetchProducts(completion: @escaping (Result<[ProductDTO], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/products") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let responseDTO = try JSONDecoder().decode(ProductResponseDTO.self, from: data)
                completion(.success(responseDTO.products))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
