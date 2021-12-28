//
//  ForgetPasswordVC.swift
//  Gifts-iOS
//
//  Created by kishlay kishore on 08/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit

class ForgetPasswordVC: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblEmailHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDelegate()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func backBtnTapAction() {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func action_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func action_Submit(_ sender: UIButton) {
        if Validation.isBlank(for: txtEmail.text ?? "") {
            Common.showAlertMessage(message: Messages.emptyEmail, alertType: .error)
            return
        }
        apiForgotPass()
    }
}
// MARK: - TextField Deleate
extension ForgetPasswordVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
        if(newLength > 0) {
            if txtEmail == textField {
                lblEmailHeight.constant = 12
            }
        } else {
            if txtEmail == textField {
                lblEmailHeight.constant = 0
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textFieldDelegate() {
        txtEmail.delegate = self
        lblEmailHeight.constant = 0
    }
}
// MARK: - API Calling
extension ForgetPasswordVC {
    func apiForgotPass() {
        let param: [String : Any] = ["mobile": txtEmail.text!.trim()]
        if let getRequest = API.FORGOTPASS.request(method: .post, with: param, forJsonEncoding: true) {
            Global.showLoadingSpinner()
            getRequest.responseJSON { response in
                Global.dismissLoadingSpinner()
                API.FORGOTPASS.validatedResponse(response, completionHandler: { (jsonObject, error) in
                    guard error == nil else {
                    Common.showAlertMessage(message: jsonObject?["message"] as? String ?? "", alertType: .error)
                        return
                    }
                    Common.showAlertMessage(message: jsonObject?["message"] as? String ?? "", alertType: .success)
                    let vc = StoryBoard.Main.instantiateViewController(identifier: "OtpVC") as! OtpVC
                    vc.emailID = self.txtEmail.text?.trim() ?? ""
                    vc.fromForgetPass = true
                    self.navigationController?.pushViewController(vc, animated: false)
                })
            }
        }
    }
}
