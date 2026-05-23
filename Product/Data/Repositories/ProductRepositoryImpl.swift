//
//  ProductRepositoryImpl.swift
//  Product
//
//  Created by Omar on 23/05/2026.
//

import Foundation
import Network

class ProductRepositoryImpl: ProductRepository {
    private let remoteDataSource: ProductRemoteDataSourceProtocol
    private let localDataSource: ProductLocalDataSourceProtocol
    private let networkMonitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    init(remoteDataSource: ProductRemoteDataSourceProtocol, localDataSource: ProductLocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func getProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.remoteDataSource.fetchProducts { result in
                    switch result {
                    case .success(let dtos):
                        let domainProducts = dtos.map { dto in
                            self?.localDataSource.saveProduct(product: dto)
                            return dto.toDomain()
                        }
                        completion(.success(domainProducts))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else {
                let localDTOs = self?.localDataSource.fetchStoredProducts() ?? []
                let domainProducts = localDTOs.map { $0.toDomain() }
                completion(.success(domainProducts))
            }
        }
        networkMonitor.start(queue: queue)
    }
    
    func saveProduct(product: Product) {
        let dto = ProductDTO(id: product.id, title: product.title, description: product.description, price: product.price, thumbnail: product.thumbnail)
        localDataSource.saveProduct(product: dto)
    }
}
