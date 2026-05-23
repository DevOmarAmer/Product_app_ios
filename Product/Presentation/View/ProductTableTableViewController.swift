import UIKit
import SDWebImage

class ProductTableViewController: UITableViewController {
    
    private let viewModel = ProductListViewModel(
        fetchProductsUseCase: FetchProductsUseCase(
            repository: ProductRepositoryImpl(
                remoteDataSource: ProductRemoteDataSource(),
                localDataSource: ProductLocalDataSource()
            )
        )
    )
    private let networkIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        
        viewModel.checkNetworkAndLoadData()
    }
    
    private func setupUI() {
        let nib = UINib(nibName: "MyCustomTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MyCustomCellID")
        
        self.title = "Product List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(navigateToAddScreen)
        )
        
        networkIndicator.center = self.view.center
        networkIndicator.hidesWhenStopped = true
        self.view.addSubview(networkIndicator)
    }
    
    private func bindViewModel() {
        
        viewModel.onDataUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            if isLoading {
                self?.networkIndicator.startAnimating()
            } else {
                self?.networkIndicator.stopAnimating()
            }
        }
        
        viewModel.onError = { errorMessage in
            print("Error fetching data: \(errorMessage)")
        }
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfProducts
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCustomCellID", for: indexPath) as! MyCustomTableViewCell
        
        let product = viewModel.product(at: indexPath.row)
        
        cell.cellTitleLabel.text = product.title
        
        if let imageUrl = URL(string: product.thumbnail) {
            cell.cellImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "photo"))
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = viewModel.product(at: indexPath.row)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as? ProductDetailsViewController {
            detailsVC.product = selectedProduct
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @objc func navigateToAddScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let addVC = storyboard.instantiateViewController(withIdentifier: "AddProductViewController") as? AddProductViewController {
            
            addVC.onProductAdded = { [weak self] newProduct in
                self?.viewModel.addNewProduct(newProduct)
            }
            
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }
}
