//
//  RegisterVC.swift
//  Gifts-iOS
//
//  Created by angrej singh on 23/09/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//
import UIKit
import GooglePlaces
import CoreLocation
class RegisterVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnRadioMale: UIImageView!
    @IBOutlet weak var btnRadioFemale: UIImageView!
    @IBOutlet weak var btnRadioEnglish: UIImageView!
    @IBOutlet weak var btnRadioRussian: UIImageView!
    @IBOutlet weak var lblFullnameHeight: NSLayoutConstraint!
    @IBOutlet weak var lblEmailHeight: NSLayoutConstraint!
    @IBOutlet weak var lblPhoneHeight: NSLayoutConstraint!
    @IBOutlet weak var lblAddressHeight: NSLayoutConstraint!
    @IBOutlet weak var lblPasswordHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTermsNService: TTTAttributedLabel!
    var selectedGender = 1
    var selectedLang = 1
    let locationManager = CLLocationManager()
    var lat = 0.0
    var long = 0.0
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackButton(tintColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), isImage: true)
        setNavigationBarImage(for: UIImage(), color: #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1))
        textFieldDelegate()
        setup()
        // Location Permission
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            DispatchQueue.main.async {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
                //locationManager.distanceFilter = 5
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func backBtnTapAction() {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Button Submit Action
    @IBAction func action_submit(_ sender: UIButton) {
        if Validation.isBlank(for: txtFullName.text ?? "") {
            Common.showAlertMessage(message: Messages.emptyName, alertType: .error)
            return
        } else if Validation.isBlank(for: txtEmail.text ?? "") {
            Common.showAlertMessage(message: Messages.emptyEmail, alertType: .error)
            return
        } else if Validation.isBlank(for: txtPhone.text ?? "") {
            Common.showAlertMessage(message: Messages.emptyMobile, alertType: .error)
            return
        } else if !Validation.isValidEmail(for: txtEmail.text ?? "") {
            Common.showAlertMessage(message: Messages.validEmailAddress, alertType: .error)
            return
        } else if !Validation.isValidMobileNumber(value: txtPhone.text ?? "") {
            Common.showAlertMessage(message: Messages.validMobile, alertType: .error)
            return
        } else if Validation.isBlank(for: txtAddress.text ?? "") {
            Common.showAlertMessage(message: Messages.emptyAddress, alertType: .error)
            return
        }
        apiUserRegistration()
    }
    // MARK: - Button Gender Action
    @IBAction func btnGenderPressed(_ sender: UIView) {
        if sender.tag == 1 {
            btnRadioMale.image = #imageLiteral(resourceName: "radioBtnFill")
            btnRadioFemale.image = #imageLiteral(resourceName: "radioBtnBlk")
            selectedGender = 1
        } else {
            btnRadioMale.image = #imageLiteral(resourceName: "radioBtnBlk")
            btnRadioFemale.image = #imageLiteral(resourceName: "radioBtnFill")
            selectedGender = 2
        }
    }
    // MARK: - Button Language Action
    @IBAction func actionSelectLanguage(_ sender: UIView) {
        if sender.tag == 1 {
            btnRadioEnglish.image = #imageLiteral(resourceName: "radioBtnFill")
            btnRadioRussian.image = #imageLiteral(resourceName: "radioBtnBlk")
            selectedLang = 1
        } else {
            btnRadioEnglish.image = #imageLiteral(resourceName: "radioBtnBlk")
            btnRadioRussian.image = #imageLiteral(resourceName: "radioBtnFill")
            selectedLang = 2
        }
    }
    // MARK: - Address Pickup Action
    @IBAction func ActionAddressPick(_ sender: UIView) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))!
        autocompleteController.placeFields = fields
        // Display the autocomplete view controller.
        self.present(autocompleteController, animated: true, completion: nil)
    }
}
// MARK: - TextField Deleate
extension RegisterVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
        if(newLength > 0) {
            if txtFullName == textField {
                lblFullnameHeight.constant = 12
            } else if txtEmail == textField {
                lblEmailHeight.constant = 12
            } else if txtPhone == textField {
                lblPhoneHeight.constant = 12
            } else if txtAddress == textField {
                lblAddressHeight.constant = 12
            } else if txtPassword == textField {
                lblPasswordHeight.constant = 12
            }
        } else {
            if txtFullName == textField {
                lblFullnameHeight.constant = 0
            } else if txtEmail == textField {
                lblEmailHeight.constant = 0
            } else if txtPhone == textField {
                lblPhoneHeight.constant = 0
            } else if txtAddress == textField {
                lblAddressHeight.constant = 0
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
        txtFullName.delegate = self
        txtEmail.delegate = self
        txtAddress.delegate = self
        txtPhone.delegate = self
        txtPassword.delegate = self
        lblFullnameHeight.constant = 0
        lblEmailHeight.constant = 0
        lblPhoneHeight.constant = 0
        lblAddressHeight.constant = 0
        lblPasswordHeight.constant = 0
    }
}

// MARK: - API Calling
extension RegisterVC {
    func apiUserRegistration() {
        let param: [String : Any] = ["full_name": txtFullName.text!.trim(),"email":txtEmail.text!.trim(),"mobile":txtPhone.text!.trim(),"gender":selectedGender,"language_type":selectedLang,"address":txtAddress.text!.trim(),"latitude":lat,"longitude":long,"password": txtPassword.text!.trim(),"device_type": "ios","device_token": Constants.UDID,"app_version":Constants.kVersionNo ?? "","app_version_code":Constants.kVersionNo ?? ""]
        if let getRequest = API.SIGNUP.request(method: .post, with: param, forJsonEncoding: true) {
            Global.showLoadingSpinner()
            getRequest.responseJSON { response in
                Global.dismissLoadingSpinner()
                API.SIGNUP.validatedResponse(response, completionHandler: { (jsonObject, error) in
                    guard error == nil else {
                        return
                    }
                    let vc = StoryBoard.Main.instantiateViewController(identifier: "OtpVC") as! OtpVC
                    vc.emailID = self.txtEmail.text!.trim()
                    self.navigationController?.pushViewController(vc, animated: false)
                    Common.showAlertMessage(message: jsonObject?["message"] as? String ?? "", alertType: .success)
                })
            }
        }
    }
}
// MARK: - Location Manager Delegtes
extension RegisterVC:CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // DispatchQueue.main.async {
        //             guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        //             self.lat = locValue.latitude
        //             self.long = locValue.longitude
        //  }
    }
}
// MARK: - Google Place Autocomplete
extension RegisterVC:GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        txtAddress.text = place.name
        self.lat = place.coordinate.latitude
        self.long = place.coordinate.longitude
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - TermsOfUse Label Set
extension RegisterVC {
    func setup() {
        lblTermsNService.numberOfLines = 0
        let txt1 = "By pressing Continue, you acknowledge having read our ".localized
       // let txt2 = "and you accept our".localized
        let strPP = Messages.txtPPNewsFeed
      //  let strTC = Messages.txtTCNewsFeed
        let string = "\(txt1) \(strPP)"
        let nsString = string as NSString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1
        let fullAttributedString = NSAttributedString(string:string, attributes: [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1),
            NSAttributedString.Key.font: UIFont.init(name: "Poppins-Medium", size: 11) ?? UIFont()
        ])
        lblTermsNService.textAlignment = .center
        lblTermsNService.attributedText = fullAttributedString
       // let rangeTC = nsString.range(of: strTC)
        let rangePP = nsString.range(of: strPP)
        let ppLinkAttributes: [String: Any] = [
            NSAttributedString.Key.foregroundColor.rawValue: #colorLiteral(red: 0.975289762, green: 0.358186841, blue: 0.2708096504, alpha: 1),
            NSAttributedString.Key.underlineStyle.rawValue: true,
            NSAttributedString.Key.font.rawValue: UIFont.init(name: "Poppins-SemiBold", size: 12) ?? UIFont()
        ]
        lblTermsNService.activeLinkAttributes = ppLinkAttributes
        lblTermsNService.linkAttributes = ppLinkAttributes
       // let urlTC = URL(string: "action://TC")!
        let urlPP = URL(string: "action://PP")!
        //lblTermsNService.addLink(to: urlTC, with: rangeTC)
        lblTermsNService.addLink(to: urlPP, with: rangePP)
        lblTermsNService.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lblTermsNService.delegate = self
    }
}

// MARK: - TTTAttributedLabelDelegate
extension RegisterVC: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if url.absoluteString == "action://PP" {
                let webViewController: WebViewController = StoryBoard.Main.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                webViewController.titleString = Messages.txtTitle
                webViewController.url = "https://101gifts.site/public/app/privacy_policy"
                guard let getNav = UIApplication.topViewController()?.navigationController else {
                    return
                }
                let rootNavView = UINavigationController(rootViewController: webViewController)
                getNav.present( rootNavView, animated: true, completion: nil)
        }
    }
}
