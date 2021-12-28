//
//  BaseImagePicker.swift
//

import UIKit
import AVFoundation

class BaseImagePicker: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    var index = 0
    var docTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
    }
    func openOptions(_ index: Int = 0, _ title: String = "") {
        self.index = index
        self.docTitle = title
        let alert = UIAlertController(title: "Choose Image", message: "Pick Image From : ", preferredStyle: .actionSheet)
        let gallaryAction = UIAlertAction(title: "Gallery", style: .default) { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.openPicker()
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.checkCameraPermission()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(gallaryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    //single image store
    func selectedImage(chooseImage:UIImage) {
    }
    //multiple image store
    func selectedImageWithIndex(chooseImage:UIImage, index: Int, title: String) {
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chooseImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        selectedImage(chooseImage: chooseImage)
        selectedImageWithIndex(chooseImage: chooseImage, index: self.index, title: self.docTitle)
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func openPicker() {
        self.present(imagePicker, animated: true, completion: nil)
    }
    func presentCameraSetting() {
        let alert = UIAlertController(title: "Error", message: "Camera access is denied", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title:  "Setting", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                })
            }
        })
        present(alert, animated: true)
    }
    func checkCameraPermission() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .denied:
            self.presentCameraSetting()
        case .restricted:
            print("user dont allow")
        case.authorized:
            print("Success")
            self.imagePicker.sourceType = .camera
            self.openPicker()
        case.notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (success) in
                if success {
                    print("Permission Granted")
                } else {
                    print("Permission Not Granted")
                }
            }
        default:
            break
        }
    }
}
