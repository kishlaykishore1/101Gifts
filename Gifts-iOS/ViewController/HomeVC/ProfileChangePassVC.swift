//
//  ProfileChangePassVC.swift
//  Gifts-iOS
//
//  Created by angrej singh on 12/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit

class ProfileChangePassVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var lblCureentPassHeight: NSLayoutConstraint!
    @IBOutlet weak var lblNewPassHeight: NSLayoutConstraint!
    @IBOutlet weak var lblReEnterPassHeight: NSLayoutConstraint!
    @IBOutlet weak var txtCurrentPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtReEnterPass: UITextField!
    @IBOutlet weak var btnCureentPass: UIButton!
    @IBOutlet weak var btnRePass: UIButton!
    @IBOutlet weak var btnNewPass: UIButton!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDelegate()
    }
    @IBAction func action_PassHideShow(_ sender: UIButton) {
    }
}
// MARK: - Action Method
extension ProfileChangePassVC {
    @IBAction func action_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func action_Submit(_ sender: UIButton) {
        if !Validation.isPasswordMatched(for:txtNewPass.text?.trim() ?? "", for: txtReEnterPass.text?.trim() ?? "") {
            Common.showAlertMessage(message: Messages.passwordDidntMatched, alertType: .error)
            return
        } else if Validation.isBlank(for: txtCurrentPass.text) {
            Common.showAlertMessage(message: Messages.emptyCurrentPassword, alertType: .error)
        } else if Validation.isBlank(for: txtNewPass.text ?? "") {
            Common.showAlertMessage(message: Messages.emptyNewPassword, alertType: .error)
            return
        } else if Validation.isBlank(for: txtNewPass.text ?? "") {
            Common.showAlertMessage(message: Messages.emptyCurrentPassword, alertType: .error)
            return
        }
        apiChangePass()
    }
}
// MARK: - TextField Deleate
extension ProfileChangePassVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
        if(newLength > 0) {
            if txtCurrentPass == textField {
                lblCureentPassHeight.constant = 12
            } else if txtNewPass == textField {
                lblNewPassHeight.constant = 12
            } else if txtReEnterPass == textField {
                lblReEnterPassHeight.constant = 12
            }
        } else {
            if txtCurrentPass == textField {
                lblCureentPassHeight.constant = 0
            } else if txtNewPass == textField {
                lblNewPassHeight.constant = 0
            } else if txtReEnterPass == textField {
                lblReEnterPassHeight.constant = 0
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textFieldDelegate() {
        txtCurrentPass.delegate = self
        txtNewPass.delegate = self
        txtReEnterPass.delegate = self
        lblCureentPassHeight.constant = 0
        lblNewPassHeight.constant = 0
        lblReEnterPassHeight.constant = 0
    }
}
// MARK: - API Calling
extension ProfileChangePassVC {
    func apiChangePass() {
        let param: [String : Any] = ["user_id": MemberModel.getMemberModel()?.userID ?? 0, "password": txtNewPass.text?.trim() ?? "", "old_password": txtCurrentPass.text?.trim() ?? ""]
        if let getRequest = API.CHANGEPASSWORD.request(method: .post, with: param, forJsonEncoding: true) {
            Global.showLoadingSpinner()
            getRequest.responseJSON { response in
                Global.dismissLoadingSpinner()
                API.CHANGEPASSWORD.validatedResponse(response, completionHandler: { (jsonObject, error) in
                    guard error == nil else {
                        Common.showAlertMessage(message: jsonObject?["message"] as? String ?? "", alertType: .error)
                        return
                    }
                    Common.showAlertMessage(message: jsonObject?["message"] as? String ?? "", alertType: .success)
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
}
