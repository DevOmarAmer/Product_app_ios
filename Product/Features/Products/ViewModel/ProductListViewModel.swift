import Foundation
import Network

class ProductListViewModel {
    
    private var products: [Product] = []
    
    private let networkMonitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    
    var onDataUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    
    var numberOfProducts: Int {
        return products.count
    }
    
    func product(at index: Int) -> Product {
        return products[index]
    }
    
    // MARK: - Logic (Network & Database)
    
    func checkNetworkAndLoadData() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.fetchProductsFromAPI()
            } else {
                self?.loadProductsFromDB()
            }
        }
        networkMonitor.start(queue: queue)
    }
    
    private func fetchProductsFromAPI() {
        DispatchQueue.main.async { self.onLoadingStateChanged?(true) }
        
        guard let url = URL(string: "https://dummyjson.com/products") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            DispatchQueue.main.async { self?.onLoadingStateChanged?(false) }
            
            if let error = error {
                DispatchQueue.main.async { self?.onError?(error.localizedDescription) }
                return
            }
            
            guard let responseData = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any]
                
                if let productsArray = json?["products"] as? [[String: Any]] {
                    var fetchedProducts: [Product] = []
                    
                    for item in productsArray {
                        let id = item["id"] as? Int ?? 0
                        let title = item["title"] as? String ?? "No Title"
                        let description = item["description"] as? String ?? ""
                        

                        let price = item["price"] as? Double ?? 0.0
                        

                        let thumbnailString = item["thumbnail"] as? String ?? ""
                        

                        let product = Product(id: id,
                                              title: title,
                                              description: description,
                                              price: price,
                                              thumbnail: thumbnailString)
                        
                        fetchedProducts.append(product)
                    }
                    
                    self?.products = fetchedProducts
                    

                    for item in fetchedProducts {
                        DBManager.shared.saveProduct(product: item)
                    }
                    

                    DispatchQueue.main.async {
                        self?.onDataUpdated?()
                    }
                }
            } catch {
                DispatchQueue.main.async { self?.onError?(error.localizedDescription) }
            }
        }.resume()
    }
    
    private func loadProductsFromDB() {
        self.products = DBManager.shared.fetchStoredProducts()
        DispatchQueue.main.async {
            self.onDataUpdated?()
        }
    }
    
    func addNewProduct(_ product: Product) {
        products.append(product)
        DBManager.shared.saveProduct(product: product)
        onDataUpdated?()
    }
}
