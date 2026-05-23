import Foundation
import CoreData
import UIKit

class DBManager {
    static let shared = DBManager()
    
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    private init() {}

    func saveProduct(product: Product) {
        DispatchQueue.main.async {
            let entity = NSEntityDescription.entity(forEntityName: "ProductEntity", in: self.context)!
            let newProduct = NSManagedObject(entity: entity, insertInto: self.context)
            
            newProduct.setValue(NSNumber(value: product.id), forKey: "id")
            newProduct.setValue(product.title, forKey: "title")
            newProduct.setValue(NSNumber(value: product.price), forKey: "price")
            
            newProduct.setValue(product.thumbnail, forKey: "thumbnail")
            newProduct.setValue(product.description, forKey: "desc")
            
            do {
                try self.context.save()
                print(" Product Saved Successfully to Core Data!")
            } catch {
                print(" Error saving to Core Data: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Fetch
    func fetchStoredProducts() -> [Product] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductEntity")
        var products: [Product] = []
        
        do {
            let results = try context.fetch(fetchRequest)
            for data in results {
                
                let id = data.value(forKey: "id") as? Int ?? 0
                let title = data.value(forKey: "title") as? String ?? "No Title"
                let description = data.value(forKey: "desc") as? String ?? ""
                let price = data.value(forKey: "price") as? Double ?? 0.0
                let thumbnail = data.value(forKey: "thumbnail") as? String ?? ""
                
                let p = Product(id: id,
                                title: title,
                                description: description,
                                price: price,
                                thumbnail: thumbnail)
                
                products.append(p)
            }
        } catch {
            print(" Fetch failed: \(error.localizedDescription)")
        }
        return products
    }
}
