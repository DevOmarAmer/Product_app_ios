import Foundation

class ProductListViewModel {
    private let fetchProductsUseCase: FetchProductsUseCase
    private var products: [Product] = []
    
    var onDataUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    
    var numberOfProducts: Int { products.count }
    
    init(fetchProductsUseCase: FetchProductsUseCase) {
        self.fetchProductsUseCase = fetchProductsUseCase
    }
    
    func product(at index: Int) -> Product {
        return products[index]
    }
    
    func checkNetworkAndLoadData() {
        onLoadingStateChanged?(true)
        fetchProductsUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoadingStateChanged?(false)
                switch result {
                case .success(let domainProducts):
                    self?.products = domainProducts
                    self?.onDataUpdated?()
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func addNewProduct(_ product: Product) {
        products.append(product)
        fetchProductsUseCase.saveNewProduct(product: product)
        onDataUpdated?()
    }
}
