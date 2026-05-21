import Foundation
import SQLite3
import CoreData
import UIKit

class DBManager {
    static let shared = DBManager()
    

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        private init() {}

        func saveProduct(product: Product) {
            let entity = NSEntityDescription.entity(forEntityName: "ProductEntity", in: context)!
            let newProduct = NSManagedObject(entity: entity, insertInto: context)
            
            newProduct.setValue(product.title, forKey: "title")
            newProduct.setValue(product.price, forKey: "price")
            newProduct.setValue(product.imageData, forKey: "imageData")
            newProduct.setValue(product.rating, forKey: "rating")
            newProduct.setValue(product.category, forKey: "category")
            newProduct.setValue(product.description, forKey: "desc")
            
            do {
                try context.save()
            } catch {
                print("Error saving to Core Data: \(error)")
            }
        }

        func fetchStoredProducts() -> [Product] {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductEntity")
            var products: [Product] = []
            
            do {
                let results = try context.fetch(fetchRequest)
                for data in results {
                    let p = Product(
                        id: data.value(forKey: "id") as? Int32,
                        title: data.value(forKey: "title") as? String ?? "",
                        description: data.value(forKey: "desc") as? String ?? "",
                        category: data.value(forKey: "category") as? String ?? "",
                        price: data.value(forKey: "price") as? Float ?? 0.0,
                        rating: data.value(forKey: "rating") as? Float ?? 0.0,
                        imageData: data.value(forKey: "imageData") as? String ?? ""
                    )
                    products.append(p)
                }
            } catch {
                print("Fetch failed")
            }
            return products
        }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    var db: OpaquePointer?
//    let dbPath: String = "ProductsDB.sqlite"
    
//    private init() {
//        db = openDatabase()
//        createTable()
//    }
    
//    private func openDatabase() -> OpaquePointer? {
//        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
//        var db: OpaquePointer? = nil
//        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
//            return db
//        }
//        return nil
//    }
    
//    private func createTable() {
//        let createTableString = """
//        CREATE TABLE IF NOT EXISTS Product(
//        Id INTEGER PRIMARY KEY AUTOINCREMENT,
//        Title TEXT,
//        Description TEXT,
//        Category TEXT,
//        Price REAL,
//        Rating REAL,
//        ImageData TEXT);
//        """
//        var createTableStatement: OpaquePointer?
//        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
//            sqlite3_step(createTableStatement)
//        }
//        sqlite3_finalize(createTableStatement)
//    }
    
//    // MARK: - Insert
//    func insert(product: Product) {
//        let insertStatementString = "INSERT INTO Product (Title, Description, Category, Price, Rating, ImageData) VALUES (?, ?, ?, ?, ?, ?);"
//        var insertStatement: OpaquePointer?
//        
//        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
//            sqlite3_bind_text(insertStatement, 1, (product.title as NSString).utf8String, -1, nil)
//            sqlite3_bind_text(insertStatement, 2, (product.description as NSString).utf8String, -1, nil)
//            sqlite3_bind_text(insertStatement, 3, (product.category as NSString).utf8String, -1, nil)
//            sqlite3_bind_double(insertStatement, 4, Double(product.price))
//            sqlite3_bind_double(insertStatement, 5, Double(product.rating))
//            
//           
//            sqlite3_bind_text(insertStatement, 6, (product.imageData as NSString).utf8String, -1, nil)
//            
//            sqlite3_step(insertStatement)
//        }
//        sqlite3_finalize(insertStatement)
//    }
//    
//    // MARK: - Read
//    func read() -> [Product] {
//        let queryStatementString = "SELECT * FROM Product;"
//        var queryStatement: OpaquePointer?
//        var products: [Product] = []
//        
//        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
//            while sqlite3_step(queryStatement) == SQLITE_ROW {
//                let id = sqlite3_column_int(queryStatement, 0)
//                
//                let titlePtr = sqlite3_column_text(queryStatement, 1)
//                let title = titlePtr != nil ? String(cString: titlePtr!) : ""
//                
//                let descPtr = sqlite3_column_text(queryStatement, 2)
//                let description = descPtr != nil ? String(cString: descPtr!) : ""
//                
//                let catPtr = sqlite3_column_text(queryStatement, 3)
//                let category = catPtr != nil ? String(cString: catPtr!) : ""
//                
//                let price = Float(sqlite3_column_double(queryStatement, 4))
//                let rating = Float(sqlite3_column_double(queryStatement, 5))
//                
//                let imgPtr = sqlite3_column_text(queryStatement, 6)
//                let imageDataString = imgPtr != nil ? String(cString: imgPtr!) : ""
//                
//                let product = Product(id: id, title: title, description: description, category: category, price: price, rating: rating, imageData: imageDataString)
//                products.append(product)
//            }
//        }
//        sqlite3_finalize(queryStatement)
//        return products
//    }
//    
//    // MARK: - Delete
//    func delete(id: Int32) {
//        let deleteStatementString = "DELETE FROM Product WHERE Id = \(id);"
//        var deleteStatement: OpaquePointer?
//        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
//            sqlite3_step(deleteStatement)
//        }
//        sqlite3_finalize(deleteStatement)
//    }
}
