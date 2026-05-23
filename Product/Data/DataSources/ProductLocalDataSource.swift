//
//  ProductLocalDataSource.swift
//  Product
//
//  Created by Omar on 23/05/2026.
//

import CoreData
import UIKit

protocol ProductLocalDataSourceProtocol {
    func fetchStoredProducts() -> [ProductDTO]
    func saveProduct(product: ProductDTO)
}

class ProductLocalDataSource: ProductLocalDataSourceProtocol {
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func fetchStoredProducts() -> [ProductDTO] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductEntity")
        var products: [ProductDTO] = []
        
        do {
            let results = try context.fetch(fetchRequest)
            for data in results {
                let id = data.value(forKey: "id") as? Int ?? 0
                let title = data.value(forKey: "title") as? String ?? ""
                let description = data.value(forKey: "desc") as? String ?? ""
                let price = data.value(forKey: "price") as? Double ?? 0.0
                let thumbnail = data.value(forKey: "thumbnail") as? String ?? ""
                
                products.append(ProductDTO(id: id, title: title, description: description, price: price, thumbnail: thumbnail))
            }
        } catch {
            print("❌ Local Fetch Failed")
        }
        return products
    }
    
    func saveProduct(product: ProductDTO) {
        DispatchQueue.main.async {
            let entity = NSEntityDescription.entity(forEntityName: "ProductEntity", in: self.context)!
            let newProduct = NSManagedObject(entity: entity, insertInto: self.context)
            
            newProduct.setValue(NSNumber(value: product.id), forKey: "id")
            newProduct.setValue(product.title, forKey: "title")
            newProduct.setValue(NSNumber(value: product.price), forKey: "price")
            newProduct.setValue(product.thumbnail, forKey: "thumbnail")
            newProduct.setValue(product.description, forKey: "desc")
            
            try? self.context.save()
        }
    }
}
