import UIKit

class AddProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    // دول مبقوش مستخدمين في الموديل الجديد، بس هنسيبهم عشان الـ Storyboard ميعملش Crash
    // (يُفضل لاحقاً تحذفهم من الشاشة وتمسح السطرين دول)
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var ratingTextField: UITextField!
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var selectBtn: UIButton!
    
    var onProductAdded: ((Product) -> Void)?
    
    // متغير لحفظ الرابط المحلي للصورة بعد اختيارها من المعرض
    private var localThumbnailUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocalizedStrings()
        
        // إخفاء الحقول غير المستخدمة
        categoryTextField?.isHidden = true
        ratingTextField?.isHidden = true
    }
    
    // MARK: - Localization Setup
    func setupLocalizedStrings() {
        self.title = NSLocalizedString("add_product_title", comment: "")
        
        titleTextField.placeholder = NSLocalizedString("product_title_placeholder", comment: "")
        descTextField.placeholder = NSLocalizedString("product_desc_placeholder", comment: "")
        priceTextField.placeholder = NSLocalizedString("product_price_placeholder", comment: "")
        
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
        // 1. التحقق من الحقول الأساسية فقط وتحويل السعر لـ Double
        guard let title = titleTextField.text, !title.isEmpty,
              let desc = descTextField.text, !desc.isEmpty,
              let priceText = priceTextField.text, let price = Double(priceText)
        else {
            showLocalizedAlert()
            return
        }
        
        // 2. توليد ID وهمي للمنتج الجديد (لأننا مش بنضيفه في الـ API الحقيقي)
        let dummyId = Int.random(in: 1000...99999)
        
        // 3. لو المستخدم مختارش صورة، هنحط صورة وهمية كـ Default
        let finalImageUrl = localThumbnailUrl.isEmpty ? "https://dummyjson.com/image/150" : localThumbnailUrl
        
        // 4. بناء الموديل النضيف
        let newProduct = Product(id: dummyId,
                                 title: title,
                                 description: desc,
                                 price: price,
                                 thumbnail: finalImageUrl)
            
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
        
        var selectedImage: UIImage?
        
        if let pickedImage = info[.editedImage] as? UIImage {
            selectedImage = pickedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        
        if let imageToSave = selectedImage {
            productImageView.image = imageToSave
            // حفظ الصورة في الجهاز للحصول على مسارها
            saveImageLocally(image: imageToSave)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    // دالة مساعدة لحفظ الصورة محلياً وتحويل مسارها لـ String عشان نمشي مع معمارية الموديل
    private func saveImageLocally(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            // حفظ مسار الملف كـ String لاستخدامه في الـ thumbnail
            localThumbnailUrl = fileURL.absoluteString
        } catch {
            print("Error saving image locally: \(error)")
        }
    }
}
