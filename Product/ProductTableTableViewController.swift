//
import UIKit
import SDWebImage
import Network

class ProductTableViewController: UITableViewController {
    
    
    var products: [Product] = []
    let networkMonitor = NWPathMonitor()

    override func viewDidLoad() {
        super.viewDidLoad()
            let nib = UINib(nibName: "MyCustomTableViewCell", bundle: nil)
            
            tableView.register(nib, forCellReuseIdentifier: "MyCustomCellID")
            
    
            
            self.title = "Product List"
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(navigateToAddScreen)
            )
            
            checkNetworkAndLoadData()
        }
    
    func checkNetworkAndLoadData() {
            let queue = DispatchQueue(label: "NetworkMonitorQueue")
            
            networkMonitor.pathUpdateHandler = { [weak self] path in
                DispatchQueue.main.async {
                    if path.status == .satisfied {
                        self?.fetchProductsFromAPI { apiProducts in
                            if let products = apiProducts {
                                self?.products = products
                                self?.tableView.reloadData()
                                
                                for item in products {
                                    DBManager.shared.saveProduct(product: item)
                                }
                            }
                        }
                    } else {
                        self?.products = DBManager.shared.fetchStoredProducts()
                        self?.tableView.reloadData()
                    }
                }
            }
            
            networkMonitor.start(queue: queue)
        }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCustomCellID", for: indexPath) as! MyCustomTableViewCell
        
        // Configure the cell...
        
        let product = products[indexPath.row]
        cell.cellTitleLabel.text = product.title
       
        if let imageUrl = URL(string: product.imageData) {
                    cell.cellImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "photo"))
                }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = products[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as? ProductDetailsViewController {
            
            detailsVC.product = selectedProduct
            
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @objc func navigateToAddScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let addVC = storyboard.instantiateViewController(withIdentifier: "AddProductViewController") as? AddProductViewController {
            
            addVC.onProductAdded = { [weak self] newProduct in
                self?.products.append(newProduct)
                self?.tableView.reloadData()
                
                DBManager.shared.saveProduct(product: newProduct)
            }
            
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }
    
    
    func fetchProductsFromAPI(completion: @escaping ([Product]?) -> Void) {
                let networkIndicator = UIActivityIndicatorView(style: .large)
                networkIndicator.center = self.view.center
                networkIndicator.startAnimating()
                self.view.addSubview(networkIndicator)
        
        
            
            let urlString = "https://dummyjson.com/products"
            guard let url = URL(string: urlString) else { return }
            
            let request = URLRequest(url: url)
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                DispatchQueue.main.async {
                    networkIndicator.stopAnimating()
                    networkIndicator.removeFromSuperview()
                }
                
                if let error = error {
                    print("Error fetching data: \(error.localizedDescription)")
                    return
                }
                
                guard let responseData = data else { return }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as! Dictionary<String, Any>
                    
                    if let productsArray = json["products"] as? [Dictionary<String, Any>] {
                        
                        var fetchedProducts: [Product] = []
                        
                        for item in productsArray {
                            let id = item["id"] as? Int32 ?? 0
                            let title = item["title"] as? String ?? "No Title"
                            let description = item["description"] as? String ?? ""
                            let category = item["category"] as? String ?? ""
                            let price = item["price"] as? Double ?? 0.0
                            let rating = item["rating"] as? Double ?? 0.0
                            
                            let thumbnailString = item["thumbnail"] as? String ?? ""
                            
                            let product = Product(id: id, title: title, description: description, category: category, price: Float(price), rating: Float(rating), imageData: thumbnailString)
                            
                            fetchedProducts.append(product)
                        }
                        
                        DispatchQueue.main.async {
                            self.products = fetchedProducts
                            self.tableView.reloadData()
                        }
                    }
                    
                } catch {
                    print("JSON Parsing Error: \(error.localizedDescription)")
                }
            }
            
            task.resume()
        }
}
