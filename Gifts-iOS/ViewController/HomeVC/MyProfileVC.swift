//
//  MyProfileVC.swift
//  Gifts-iOS
//
//  Created by angrej singh on 01/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit
import AlamofireImage

class MyProfileVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var lblFullNameHeight: NSLayoutConstraint!
    @IBOutlet weak var txtGender: UITextField!
    @IBOutlet weak var genderHeight: NSLayoutConstraint!
    @IBOutlet weak var emailHeight: NSLayoutConstraint!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var phoneHeight: NSLayoutConstraint!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var addressHeight: NSLayoutConstraint!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var languageHeight: NSLayoutConstraint!
    @IBOutlet weak var txtLanguage: UITextField!
    // MARK: - Properties
    var userProfileData: UserProfileModel?
    var gender = ""
    var tag = Int()
    var home: HomeVC?
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.userProfile.layer.cornerRadius = self.userProfile.frame.height/2
        }
        self.navigationController?.navigationBar.isHidden = true
        textFieldDelegate()
        userDataSet()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userProfile.isUserInteractionEnabled = true
        userProfile.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        showImagePickerView()
    }
}
// MARK: - Action Method And Function
extension MyProfileVC {
    @IBAction func action_BackTap(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.home?.apiUserProfile()
        }
    }
    @IBAction func action_EditProfile(_ sender: UIControl) {
        tag = sender.tag
        print(tag)
        switch sender.tag {
        case 101:
            alertWithTextField(title: Messages.FullNameAlert, message: Messages.FullNameMsgAlert, placeHolder: Messages.FullNamePlaceHolderAlert)
        case 102:
            showActionSheet(title1: Messages.ActionSheetMale, title2: Messages.ActionSheetFemale, title3: Messages.ActionSheetCancel)
        case 103:
            alertWithTextField(title: Messages.EmailAlert, message: Messages.EmailNameMsgAlert, placeHolder: Messages.EmailPlaceHolderAlert)
        case 104:
            alertWithTextField(title: Messages.PhoneAlert, message: Messages.PhoneMsgAlert, placeHolder: Messages.PhonePlaceHolderAlert)
        case 105:
            alertWithTextField(title: Messages.AddressAlert, message: Messages.AddressMsgAlert, placeHolder: Messages.AddressPlaceHolderAlert)
        case 106:
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        case 107:
            let vc = StoryBoard.Home.instantiateViewController(identifier: "ProfileChangePassVC") as! ProfileChangePassVC
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    func alertWithTextField(title: String, message: String, placeHolder: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = placeHolder
                textField.autocapitalizationType = .sentences
                textField.isEnabled = false
            }
            let saveAction = UIAlertAction(title: "Change", style: .default, handler: { _ in
                let firstTextField = alertController.textFields![0] as UITextField
                if firstTextField.text?.trim().count == 0 {
                    Common.showAlertMessage(message: Messages.txtPleaseEnter, alertType: .error)
                    return
                }
                if self.tag == 101 {
                    self.txtFullName.text = firstTextField.text
                } else if self.tag == 103 {
                    self.txtEmail.text = firstTextField.text
                } else if self.tag == 104 {
                    self.txtPhoneNumber.text = firstTextField.text
                } else if self.tag == 105 {
                    self.txtAddress.text = firstTextField.text
                }
                self.apiProfileUpdate()
            })
            let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: { _ in
            })
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: {
                let firstTextField = alertController.textFields![0] as UITextField
                firstTextField.isEnabled = true
                firstTextField.becomeFirstResponder()
            })
        }
    }
    func showActionSheet(title1: String, title2: String, title3: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: title1, style: .default, handler: { (_) in
            self.txtGender.text = title1
            self.gender = "1"
            self.apiProfileUpdate()
        }))
        alert.addAction(UIAlertAction(title: title2, style: .default, handler: { (_) in
            self.txtGender.text = title2
            self.gender = "2"
            self.apiProfileUpdate()
        }))
        alert.addAction(UIAlertAction(title: title3, style: .destructive, handler: { (_) in
            print("User click Dismiss button")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func userDataSet() {
        lblName.text = userProfileData?.fullName ?? ""
        if let url = URL(string: userProfileData?.image ?? "") {
            userProfile.af_setImage(withURL: url)
        }
        if userProfileData?.fullName == "" {
            lblFullNameHeight.constant = 0
            txtFullName.text = userProfileData?.fullName ?? ""
        } else {
            lblFullNameHeight.constant = 12
            txtFullName.text = userProfileData?.fullName ?? ""
        }
        if userProfileData?.address == "" {
            addressHeight.constant = 0
            lblLocation.text = userProfileData?.address ?? ""
        } else {
            addressHeight.constant = 12
            lblLocation.text = userProfileData?.address ?? ""
        }
        if userProfileData?.address == "" {
            addressHeight.constant = 0
            lblLocation.text = userProfileData?.address ?? ""
        } else {
            addressHeight.constant = 12
            lblLocation.text = userProfileData?.address ?? ""
        }
        if userProfileData?.email == "" {
            emailHeight.constant = 0
            txtEmail.text = userProfileData?.email ?? ""
        } else {
            emailHeight.constant = 12
            txtEmail.text = userProfileData?.email ?? ""
        }
        if userProfileData?.mobile == "" {
            phoneHeight.constant = 0
            txtPhoneNumber.text = userProfileData?.mobile ?? ""
        } else {
            phoneHeight.constant = 12
            txtPhoneNumber.text = userProfileData?.mobile ?? ""
        }
        if userProfileData?.address == "" {
            addressHeight.constant = 12
            txtAddress.text = userProfileData?.address ?? ""
        } else {
            addressHeight.constant = 12
            txtAddress.text = userProfileData?.address ?? ""
        }
        if userProfileData?.gender == "" {
            genderHeight.constant = 0
            txtGender.placeholder = "Gender"
        } else {
            genderHeight.constant = 12
            if userProfileData?.gender ?? "" == "1" {
                txtGender.text = "Male"
            } else {
                txtGender.text = "Female"
            }
        }
        if userProfileData?.languageType == "" {
            languageHeight.constant = 0
            txtLanguage.placeholder = "Language"
        } else {
            languageHeight.constant = 14
            if userProfileData?.languageType ?? "" == "1" {
                txtLanguage.text = "English"
            } else {
                txtLanguage.text = "Russian"
            }
        }
    }
}
// MARK: - TextField Deleate
extension MyProfileVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
        if(newLength > 0) {
            if txtFullName == textField {
                lblFullNameHeight.constant = 12
            } else if txtGender == textField {
                genderHeight.constant = 12
            } else if txtEmail == textField {
                emailHeight.constant = 12
            } else if txtPhoneNumber == textField {
                phoneHeight.constant = 12
            } else if txtAddress == textField {
                addressHeight.constant = 12
            } else if txtLanguage == textField {
                languageHeight.constant = 14
            }
        } else {
            if txtFullName == textField {
                lblFullNameHeight.constant = 0
            } else if txtGender == textField {
                genderHeight.constant = 0
            } else if txtEmail == textField {
                emailHeight.constant = 0
            } else if txtPhoneNumber == textField {
                phoneHeight.constant = 0
            } else if txtAddress == textField {
                addressHeight.constant = 0
            } else if txtLanguage == textField {
                languageHeight.constant = 0
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textFieldDelegate() {
        txtFullName.delegate = self
        txtGender.delegate = self
        txtEmail.delegate = self
        txtAddress.delegate = self
        txtPhoneNumber.delegate = self
        txtLanguage.delegate = self
        lblFullNameHeight.constant = 0
        genderHeight.constant = 0
        emailHeight.constant = 0
        phoneHeight.constant = 0
        addressHeight.constant = 0
        languageHeight.constant = 0
    }
}
// MARK: - UIImagePickerController Config
extension MyProfileVC {
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            let imagePicker = UIImagePickerController( )
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            Common.showAlertMessage(message: Messages.txtCameraFind, alertType: .warning)
        }
    }
    func openGallary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    func showImagePickerView() {
        let alert = UIAlertController(title: Messages.photoMassage, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title:  Messages.txtCamera, style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: Messages.txtGallery, style: .default, handler: { _ in
            self.openGallary()
        }))
        alert.addAction(UIAlertAction.init(title: Messages.txtCancel, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MyProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let  pickedImage = info[.editedImage] as? UIImage {
            userProfile.contentMode = .scaleAspectFill
            userProfile.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
        apiProfileUpdate()
    }
}
// MARK: - Api Calling Update Profile
extension MyProfileVC {
    //Upload Profile Image
    func apiProfileUpdate() {
        let param: [String : Any] = ["user_id": MemberModel.getMemberModel()?.userID ?? 0, "email": txtEmail.text?.trim() ?? "", "mobile": txtPhoneNumber.text?.trim() ?? "", "language_type": "1", "address": txtAddress.text?.trim() ?? "", "full_name": txtFullName.text?.trim() ?? "", "gender": gender]
        print(param)
        Global.showLoadingSpinner()
        API.UPDATEPROFILE.requestUpload( with: param, files: ["image": userProfile.image ?? ""]) { (jsonObject, error) in
            Global.dismissLoadingSpinner()
            guard error == nil, let getData = jsonObject?["data"] as? [String: Any] else {
                Common.showAlertMessage(message: Messages.ProfileNotUpdate, alertType: .error)
                return
            }
            Common.showAlertMessage(message: jsonObject?["message"] as? String ?? "", alertType: .success)
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                let decoder = JSONDecoder()
                self.userProfileData = try decoder.decode(UserProfileModel.self, from: jsonData)
                print(self.userProfileData ?? "")
                self.userDataSet()
            } catch let err {
                print("Err", err)
            }
        }
    }
}
