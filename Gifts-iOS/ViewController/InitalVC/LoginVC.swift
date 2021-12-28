//
//  LoginVC.swift
//  Gifts-iOS
//
//  Created by angrej singh on 23/09/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices

class LoginVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblUserNameHeight: NSLayoutConstraint!
    @IBOutlet weak var lblPasswordHeight: NSLayoutConstraint!
    @IBOutlet weak var roundView: UIView!
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        DispatchQueue.main.async {
            self.roundView.layer.cornerRadius = self.roundView.frame.height/2
        }
        textFieldDelegate()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func btnForgetPasswordPressed(_ sender: UIButton) {
        let vc = StoryBoard.Main.instantiateViewController(identifier: "ForgetPasswordVC") as! ForgetPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - Action Method
extension LoginVC {
    @IBAction func action_Login(_ sender: UIButton) {
        if Validation.isBlank(for: txtPhoneNo.text ?? "") {
            Common.showAlertMessage(message: Messages.emptyMobile, alertType: .error)
            return
        } else if Validation.isBlank(for: txtPassword.text ?? "") {
            Common.showAlertMessage(message: Messages.emptyPassword, alertType: .error)
            return
        }
        apiUserLogin()
    }
    @IBAction func action_CreateAccount(_ sender: UIButton) {
        let vc = StoryBoard.Main.instantiateViewController(identifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func action_AppleLogin(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            let alert = UIAlertController(title: Messages.msgAlert, message: Messages.txtAppleSignInMes, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Messages.txtDissmiss, style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func action_Facebook(_ sender: UIControl) {
        facebookLogin()
    }
    @IBAction func action_GoogleSignIn(_ sender: UIControl) {
        Global.showLoadingSpinner()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
}
// MARK: - TextField Deleate
extension LoginVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
        if(newLength > 0) {
            if txtPhoneNo == textField {
                lblUserNameHeight.constant = 12
            } else if txtPassword == textField {
                lblPasswordHeight.constant = 12
            }
        } else {
            if txtPhoneNo == textField {
                lblUserNameHeight.constant = 0
            } else if txtPassword == textField {
                lblPasswordHeight.constant = 0
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textFieldDelegate() {
        txtPhoneNo.delegate = self
        txtPassword.delegate = self
        lblUserNameHeight.constant = 0
        lblPasswordHeight.constant = 0
    }
}
// MARK: - Login With Google
extension LoginVC : GIDSignInDelegate {
    // MARK: Google sign In
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        Global.dismissLoadingSpinner()
        if error != nil {
            return
        }
        let userId = user.userID ?? ""
        let givenName = user.profile.givenName ?? ""
        let familyName = user.profile.familyName ?? ""
        let email = user.profile.email ?? ""
        let url = "\(user.profile.imageURL(withDimension: 200)!)"
        print(userId)
        print(givenName)
        print(familyName)
        print(email)
        print(url)
        self.apiGoogleLogin(name: "\(givenName) \(familyName)", email: email, gID: userId, Image: url)
        GIDSignIn.sharedInstance()?.signOut()
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    }
}
// MARK: - Apple SignIn Delegate
@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
//            var isEmail = false
//            if email != nil {
//                isEmail = true
//            }
            //self.apiSocialLogin(fname: appleIDCredential.fullName?.givenName ?? "", lname: appleIDCredential.fullName?.familyName ?? "", emailId: appleIDCredential.email ?? "", socialID: appleIDCredential.user, socialType: "Apple", isEmail)
        }
    }
    // Authorization Failed
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}
// MARK: - For present window Apple Sign In
@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
// MARK: - FaceBook Login
extension LoginVC {
    //Social login
    private func facebookLogin() {
        if let accessToken = AccessToken.current {
            print("Facebook User Access Token: \(accessToken)")
            self.getFBUserData()
        }
        if AccessToken.current == nil {
            LoginManager().logIn(permissions: ["email"], from: self) { (result, error) -> Void in
                if (error == nil) {
                    let fbloginresult : LoginManagerLoginResult = result!
                    // if user cancel the login
                    if (result?.isCancelled) ?? false {
                        print("Facebook User Cancelled")
                        return
                    }
                    if(fbloginresult.grantedPermissions.contains("email")) {
                        self.getFBUserData()
                        print(AccessToken.current!.tokenString as Any)
                    }
                }
            }
        }
    }
    private func getFBUserData() {
        if((AccessToken.current) != nil) {
           Global.showLoadingSpinner()
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, response, error) -> Void in
                Global.dismissLoadingSpinner()
                if (error == nil) {
                    print(response as Any)
                    if let result = response as? [String : Any] {
                        print(result)
                        let email = result["email"] as? String ?? ""
                        let firstName = result["first_name"] as? String ?? ""
                        let id = result["id"] as? String ?? ""
                        let lastName = result["last_name"] as? String ?? ""
                        let picture = result["picture"] as? [String: Any]
                        let data = picture?["data"] as? [String: Any]
                        let imageUrl = data?["url"] as? String ?? ""
                        print(email)
                        print(firstName)
                        print(lastName)
                        print(id)
                        print(imageUrl)
                        //Api call login
                        self.apiFacebookLogin(name: "\(firstName) \(lastName)", email: email, fID: id, Image: imageUrl)
                        LoginManager().logOut()
                    }
                }
            })
        }
    }
}
// MARK: - API Calling
extension LoginVC {
    func apiUserLogin() {
        let param: [String : Any] = ["mobile": txtPhoneNo.text!.trim(),"password": txtPassword.text!.trim(),"device_type": "ios","device_token": Constants.UDID,"app_version":Constants.kVersionNo ?? "","app_version_code":Constants.kVersionNo ?? ""]
        if let getRequest = API.LOGIN.request(method: .post, with: param, forJsonEncoding: true) {
            Global.showLoadingSpinner()
            getRequest.responseJSON { response in
                Global.dismissLoadingSpinner()
                API.LOGIN.validatedResponse(response, completionHandler: { (jsonObject, error) in
                    guard error == nil else {
                        return
                    }
                    guard let getData = jsonObject?["data"] as? [String: Any] else {
                        return
                    }
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
                })
            }
        }
    }
  // MARK: Google Login Api Setup
    func apiGoogleLogin(name:String,email:String,gID:String,Image:String) {
        let param: [String : Any] = ["full_name": name,"email": email,"language_type":getLanguage(),"google_id":gID,"image_url":Image,"device_type": "ios","device_token": Constants.UDID,"app_version":Constants.kVersionNo ?? "","app_version_code":Constants.kVersionNo ?? ""]
        if let getRequest = API.GOOGLELOGIN.request(method: .post, with: param, forJsonEncoding: true) {
            Global.showLoadingSpinner()
            getRequest.responseJSON { response in
                Global.dismissLoadingSpinner()
                API.GOOGLELOGIN.validatedResponse(response, completionHandler: { (jsonObject, error) in
                    guard error == nil else {
                        return
                    }
                    guard let getData = jsonObject?["data"] as? [String: Any] else {
                        return
                    }
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
                })
            }
        }
    }
    // MARK: Facebook Login Api Setup
      func apiFacebookLogin(name:String,email:String,fID:String,Image:String) {
          let param: [String : Any] = ["full_name": name,"email": email,"language_type":getLanguage(),"facebook_id":fID,"image_url":Image,"device_type": "ios","device_token": Constants.UDID,"app_version":Constants.kVersionNo ?? "","app_version_code":Constants.kVersionNo ?? ""]
          if let getRequest = API.FACEBOOKLOGIN.request(method: .post, with: param, forJsonEncoding: true) {
              Global.showLoadingSpinner()
              getRequest.responseJSON { response in
                  Global.dismissLoadingSpinner()
                  API.FACEBOOKLOGIN.validatedResponse(response, completionHandler: { (jsonObject, error) in
                      guard error == nil else {
                          return
                      }
                      guard let getData = jsonObject?["data"] as? [String: Any] else {
                          return
                      }
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
                  })
              }
          }
      }
}
