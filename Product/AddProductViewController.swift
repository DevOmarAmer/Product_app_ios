import UIKit

class AddProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var ratingTextField: UITextField!
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var selectBtn: UIButton!
    var onProductAdded: ((Product) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocalizedStrings()
    }
    
    // MARK: - Localization Setup
    func setupLocalizedStrings() {
        self.title = NSLocalizedString("add_product_title", comment: "")
        
        titleTextField.placeholder = NSLocalizedString("product_title_placeholder", comment: "")
        categoryTextField.placeholder = NSLocalizedString("product_category_placeholder", comment: "")
        descTextField.placeholder = NSLocalizedString("product_desc_placeholder", comment: "")
        priceTextField.placeholder = NSLocalizedString("product_price_placeholder", comment: "")
        ratingTextField.placeholder = NSLocalizedString("product_rating_placeholder", comment: "")
        
        saveButton?.setTitle(NSLocalizedString("save_button", comment: ""), for: .normal)
        selectBtn?.setTitle(NSLocalizedString("select_from_gallery", comment: ""), for: .normal)
    
    }
    
    // MARK: - Actions
    @IBAction func selectImageTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty,
              let category = categoryTextField.text, !category.isEmpty,
              let desc = descTextField.text, !desc.isEmpty,
              let priceText = priceTextField.text, let price = Float(priceText),
              let ratingText = ratingTextField.text, let rating = Float(ratingText)
        else {
            showLocalizedAlert()
            return
        }
        
        let newProduct = Product(id: nil, title: title, description: desc, category: category, price: price, rating: rating, imageData: "macbook")
            
        // DBManager.shared.insert(product: newProduct)
        
        onProductAdded?(newProduct)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func showLocalizedAlert() {
        let alertTitle = NSLocalizedString("error_alert_title", comment: "")
        let alertMessage = NSLocalizedString("error_alert_message", comment: "")
        let okText = NSLocalizedString("ok_button", comment: "")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okText, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            productImageView.image = pickedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            productImageView.image = originalImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
