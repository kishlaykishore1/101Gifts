//
//  ChangePasswordVC.swift
//  Gifts-iOS
//
//  Created by angrej singh on 02/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var newPassHeight: NSLayoutConstraint!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var reTypePassHeight: NSLayoutConstraint!
    @IBOutlet weak var txtReTypePass: UITextField!
    @IBOutlet weak var btnSecure1: UIButton!
    @IBOutlet weak var btnSecure2: UIButton!
    // MARK: - Properties
    var iconClick = true
    var userID = ""
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDelegate()
        btnSecure1.isSelected = false
    }
    @IBAction func btnSecureEntity(_ sender: UIButton) {
//        if sender.tag == 1 {
//            if btnSecure1.isSelected {
//                btnSecure1.setImage(#imageLiteral(resourceName: "hide"), for: .normal)
//                txtNewPassword.isSecureTextEntry = true
//            } else {
//               // btnSecure1.setImage(#imageLiteral(resourceName: "hide"), for: .normal)
//                txtNewPassword.isSecureTextEntry = false
//            }
//        } else {
//            if btnSecure2.isSelected {
//                btnSecure1.setImage(#imageLiteral(resourceName: "hide"), for: .normal)
//                txtReTypePass.isSecureTextEntry = true
//            } else {
//                txtReTypePass.isSecureTextEntry = false
//            }
//        }
    }
}
// MARK: - Action Method
extension ChangePasswordVC {
    @IBAction func action_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Button Submit Pressed
    @IBAction func action_Submit(_ sender: UIButton) {
        if !Validation.isPasswordMatched(for: txtNewPassword.text?.trim() ?? "", for: txtReTypePass.text?.trim() ?? "") {
            Common.showAlertMessage(message: Messages.passwordDidntMatched, alertType: .error)
            return
        }
        apiChangePass()
    }
}
// MARK: - TextField Deleate
extension ChangePasswordVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
        if(newLength > 0) {
             if txtNewPassword == textField {
                newPassHeight.constant = 12
            } else if txtReTypePass == textField {
                reTypePassHeight.constant = 12
            }
        } else {
             if txtNewPassword == textField {
                newPassHeight.constant = 0
            } else if txtReTypePass == textField {
                reTypePassHeight.constant = 0
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textFieldDelegate() {
        txtNewPassword.delegate = self
        txtReTypePass.delegate = self
        newPassHeight.constant = 0
        reTypePassHeight.constant = 0
    }
}
// MARK: - API Calling
extension ChangePasswordVC {
    func apiChangePass() {
        let param: [String : Any] = ["user_id": userID, "password":txtNewPassword.text!.trim()]
        if let getRequest = API.PASSRESET.request(method: .post, with: param, forJsonEncoding: true) {
            Global.showLoadingSpinner()
            getRequest.responseJSON { response in
                Global.dismissLoadingSpinner()
                API.PASSRESET.validatedResponse(response, completionHandler: { (jsonObject, error) in
                    guard error == nil else {
                    Common.showAlertMessage(message: jsonObject?["message"] as? String ?? "", alertType: .error)
                        return
                    }
                    Common.showAlertMessage(message: jsonObject?["message"] as? String ?? "", alertType: .success)
                    let vc = StoryBoard.Main.instantiateViewController(identifier: "LoginVC") as! LoginVC
                    self.navigationController?.pushViewController(vc, animated: false)
                })
            }
        }
    }
}
