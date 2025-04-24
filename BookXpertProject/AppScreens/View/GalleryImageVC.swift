//
//  GalleryImageVC.swift
//  BookXpertProject


import UIKit
import AVFoundation

class GalleryImageVC: UIViewController {
    
    @IBOutlet weak var backNaviViewOL: BackNavigationSubView!{
        didSet{
            self.backNaviViewOL.delegate = self
        }
    }
    @IBOutlet weak var previewImgOL: UIImageView!
    @IBOutlet weak var uploadViewOL: UIControl!
    @IBOutlet weak var uploadImgOL: UIImageView!
    @IBOutlet weak var uploadLblOL: UILabel!
    
    var imagePicker = UIImagePickerController()
    var uploadfileName = String()
    var uploadImageData:Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uploadViewOL.layer.cornerRadius = 5
        self.backNaviViewOL.titleCommonUISetup(titleTxt: "Picture Selection")
        self.imageSelectionSetup()
    }
    
    func imageSelectionSetup(){
        var selectImgTxt:String = "Upload Picture"
        if let selectedImgData = uploadImageData{
            selectImgTxt = "Change Picture"
            self.previewImgOL.image = UIImage(data: selectedImgData)
        }else{
            if let galleryDefaultImg = UIImage(named: "galleryImgPickIcon"){
                self.previewImgOL.image = galleryDefaultImg
            }
        }
        self.uploadLblOL.text = selectImgTxt
    }
    
    @IBAction func didTapUploadimg(_ sender: UIControl) {
        self.imageUpload(sender)
    }
    
    func imageUpload(_ sender: UIControl){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.cameraAuthorizationStatus()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Check the Camera Authorization
    func cameraAuthorizationStatus() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.openCamera()
                    }
                }
            }
        case .authorized:
            self.openCamera()
            print("Access authorized")
        case .denied, .restricted:
            self.openSettings()
            print("restricted")
        }
    }
    
    func openSettings(){
        let alert = UIAlertController(title: "Warning!", message: "Application does not have Access to Camera. To enable access, tap Settings and Allow Access to Camera", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Open the camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

}

extension GalleryImageVC: BackNavigationSubViewDelegate{
    func backIconPressed(isPressed:Bool){
        self.navigationController?.popViewController(animated: true)
    }
}

extension GalleryImageVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage{
            let imgData = NSData(data: editedImage.jpegData(compressionQuality: 1)!)
            let imageSize: Int = imgData.count
            if((Double(imageSize).rounded() / 1000.0) <= 5120){
                if let imgUrl = info[UIImagePickerController.InfoKey.referenceURL] as? URL{
                    let imgName = imgUrl.lastPathComponent
                    let documentDirectory = NSTemporaryDirectory()
                    let localPath = documentDirectory.appending(imgName)
                } else {
                    guard let image = info[.originalImage] as? UIImage else { return }
                    if (picker.sourceType == UIImagePickerController.SourceType.camera) {
                        let imgName = UUID().uuidString
                        let documentDirectory = NSTemporaryDirectory()
                        let localPath = documentDirectory.appending(imgName)
                        let data = image.jpegData(compressionQuality: 1) as? NSData
                        data?.write(toFile: localPath, atomically: true)
                        let photoURL = URL.init(fileURLWithPath: localPath)
                    }
                }
                
                self.uploadImageData = imgData as Data
                picker.dismiss(animated: false, completion: {
                    DispatchQueue.main.async {
                        self.imageSelectionSetup()
                    }
                })
                
            }else{
                let alert  = UIAlertController(title: "Warning", message: "Upload image is not exceed 5MB", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                picker.dismiss(animated: true, completion: nil)
            }
        }else{
            //Dismiss the UIImagePicker after selection
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
