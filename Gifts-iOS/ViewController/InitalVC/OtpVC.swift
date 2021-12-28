//
//  OtpVC.swift
//  Gifts-iOS
//
//  Created by angrej singh on 23/09/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit

protocol BackspaceTextFieldDelegate: class {
    func textFieldDidEnterBackspace(_ textField: BackspaceTextField)
}
class OtpVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnVerify: DesignableButton!
    @IBOutlet weak var txtOtp1: BackspaceTextField!
    @IBOutlet weak var txtOtp2: BackspaceTextField!
    @IBOutlet weak var txtOtp3: BackspaceTextField!
    @IBOutlet weak var txtOtp4: BackspaceTextField!
    // MARK: - Properties
    var emailID = ""
    var fromForgetPass = false
    var textFields: [BackspaceTextField] {
        return [txtOtp1,txtOtp2,txtOtp3,txtOtp4]
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        txtOtp1.delegate = self
        txtOtp2.delegate = self
        txtOtp3.delegate = self
        txtOtp4.delegate = self
        textFields.forEach { $0.backspaceTextFieldDelegate = self }
        txtOtp1.becomeFirstResponder()
        setNavigationBarImage(for: UIImage(), color: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1))
    }
    override func viewWillAppear(_ animated: Bool) {
        lblEmail.text = emailID
        btnVerify.backgroundColor = #colorLiteral(red: 0.5333333333, green: 0.5294117647, blue: 0.5294117647, alpha: 1)
        btnVerify.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func action_OtpValidate(_ sender: UIButton) {
      apiOtpVerify()
//        let vc = StoryBoard.Home.instantiateViewController(identifier: "HomeVC") as! HomeVC
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: Resend Otp
    @IBAction func btnResendOtpPressed(_ sender: UIButton) {
    }
}
// MARK: - TextField Delegate
extension OtpVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((textField.text?.count)! < 1) && (string.count > 0) {
            if textField == txtOtp1 {
                txtOtp2.becomeFirstResponder()
            }
            if textField == txtOtp2 {
                txtOtp3.becomeFirstResponder()
            }
            if textField == txtOtp3 {
                txtOtp4.becomeFirstResponder()
            }
            if textField == txtOtp4 {
                txtOtp4.becomeFirstResponder()
                btnVerify.backgroundColor = #colorLiteral(red: 0.975289762, green: 0.358186841, blue: 0.2708096504, alpha: 1)
                btnVerify.isEnabled = true
            }
            textField.text = string
            return false
        } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            if textField == txtOtp2 {
                txtOtp1.becomeFirstResponder()
                btnVerify.backgroundColor = #colorLiteral(red: 0.5333333333, green: 0.5294117647, blue: 0.5294117647, alpha: 1)
                btnVerify.isEnabled = false
            }
            if textField == txtOtp3 {
                txtOtp2.becomeFirstResponder()
                btnVerify.backgroundColor = #colorLiteral(red: 0.5333333333, green: 0.5294117647, blue: 0.5294117647, alpha: 1)
                btnVerify.isEnabled = false
            }
            if textField == txtOtp4 {
                txtOtp3.becomeFirstResponder()
                btnVerify.backgroundColor = #colorLiteral(red: 0.5333333333, green: 0.5294117647, blue: 0.5294117647, alpha: 1)
                btnVerify.isEnabled = false
            }
            if textField == txtOtp1 {
                txtOtp1.resignFirstResponder()
            }
            textField.text = ""
            return false
        } else if ((textField.text?.count)! >= 1) {
            textField.text = string
            return false
        }
        return true
    }
}
// MARK: - Backspace Tracing Delegate
extension OtpVC: BackspaceTextFieldDelegate {
    func textFieldDidEnterBackspace(_ textField: BackspaceTextField) {
        guard let index = textFields.firstIndex(of: textField) else {
            return
        }
        if index > 0 {
            textFields[index - 1].becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
    }
}
// MARK: - BackspaceTextField
class BackspaceTextField: UITextField {
    weak var backspaceTextFieldDelegate: BackspaceTextFieldDelegate?
    override func deleteBackward() {
        if text?.isEmpty ?? false {
            backspaceTextFieldDelegate?.textFieldDidEnterBackspace(self)
        }
        super.deleteBackward()
    }
}
// MARK: - API Calling
extension OtpVC {
    func apiOtpVerify() {
        let otpNumber: String = "\(txtOtp1.text!)\(txtOtp2.text!)\(txtOtp3.text!)\(txtOtp4.text!)"
        let param: [String : Any] = ["mobile": emailID,"otp":otpNumber]
        if let getRequest = API.VERIFYOTP.request(method: .post, with: param, forJsonEncoding: true) {
            Global.showLoadingSpinner()
            getRequest.responseJSON { response in
                Global.dismissLoadingSpinner()
                API.VERIFYOTP.validatedResponse(response, completionHandler: { (jsonObject, error) in
                    guard error == nil else {
                    Common.showAlertMessage(message: jsonObject?["message"] as? String ?? "", alertType: .error)
                        return
                    }
                    guard let getData = jsonObject?["data"] as? [String: Any] else {
                        return
                    }
                    if self.fromForgetPass {
                        let userID = getData["user_id"] as? String
                        let vc = StoryBoard.Main.instantiateViewController(identifier: "ChangePasswordVC") as! ChangePasswordVC
                        vc.userID = userID ?? ""
                        self.navigationController?.pushViewController(vc, animated: false)
                    } else {
                        Common.showAlertMessage(message: jsonObject?["message"] as? String ?? "", alertType: .success)
                        MemberModel.storeMemberModel(value: getData)
                        if #available(iOS 13.0, *) {
                            let scene = UIApplication.shared.connectedScenes.first
                            if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                                sd.isUserLogin(true)
                            }
                        } else {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.isUserLogin(true)
                        }
                    }
                })
            }
        }
    }
}
