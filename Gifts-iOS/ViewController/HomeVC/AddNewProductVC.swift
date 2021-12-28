//
//  AddNewProductVC.swift
//  Gifts-iOS
//
//  Created by angrej singh on 06/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit

class AddNewProductVC: BaseImagePicker {
    // MARK: - Outlets
    @IBOutlet weak var lblselectCategoryHeight: NSLayoutConstraint!
    @IBOutlet weak var lblNameProductHeight: NSLayoutConstraint!
    @IBOutlet weak var lblPhoneHeight: NSLayoutConstraint!
    @IBOutlet weak var lblLocationHeight: NSLayoutConstraint!
    @IBOutlet weak var lblDescriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    // MARK: - Properties
    var arrImages: [UIImage] = []
    var home: HomeVC?
    var lat: Double?
    var Long: Double?
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldDelegate()
        self.navigationController?.navigationBar.isHidden = true
    }
    override func selectedImage(chooseImage: UIImage) {
        arrImages.append(chooseImage)
        collectionHeight.constant = 128.0
        collectionView.reloadData()
    }
}
// MARK: - Action Method
extension AddNewProductVC {
    @IBAction func action_AddPicture(_ sender: UIButton) {
        openOptions()
    }
    @IBAction func action_Submit(_ sender: UIButton) {
    }
    @IBAction func action_Back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func action_CrossButton(_ sender: UIButton) {
        if arrImages.count == 1 {
            collectionHeight.constant = 0
        }
        arrImages.remove(at: sender.tag)
        collectionView.reloadData()
    }
    @IBAction func action_ChooseLocation(_ sender: UIControl) {
        let aboutVC = StoryBoard.Home.instantiateViewController(withIdentifier: "LocationVC") as! LocationVC
        aboutVC.home = self.home
        aboutVC.AddNewProductVC = self
        guard let getNav = UIApplication.topViewController()?.navigationController else {
            return
        }
        let rootNavView = UINavigationController(rootViewController: aboutVC)
        getNav.present( rootNavView, animated: true, completion: nil)
    }
    @IBAction func action_SelectCategory(_ sender: UIControl) {
        let aboutVC = StoryBoard.Home.instantiateViewController(withIdentifier: "SelectCategoryVC") as! SelectCategoryVC
        guard let getNav = UIApplication.topViewController()?.navigationController else {
            return
        }
        let rootNavView = UINavigationController(rootViewController: aboutVC)
        getNav.present( rootNavView, animated: true, completion: nil)
    }
}
// MARK: - CollectionView DataSource
extension AddNewProductVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddProductCollectionCell", for: indexPath) as! AddProductCollectionCell
        cell.btnCross.tag = indexPath.row
        cell.imgView.image = arrImages[indexPath.row]
        return cell
    }
}

// MARK: - TextField Deleate
extension AddNewProductVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
        if(newLength > 0) {
            if txtCategory == textField {
                lblselectCategoryHeight.constant = 12
            } else if txtProductName == textField {
                lblNameProductHeight.constant = 12
            } else if txtPhone == textField {
                lblPhoneHeight.constant = 12
            } else if txtLocation == textField {
                lblLocationHeight.constant = 12
            } else if txtDescription == textField {
                lblDescriptionHeight.constant = 12
            }
            getTextField()
        } else {
            if txtCategory == textField {
                lblselectCategoryHeight.constant = 0
            } else if txtProductName == textField {
                lblNameProductHeight.constant = 0
            } else if txtPhone == textField {
                lblPhoneHeight.constant = 0
            } else if txtLocation == textField {
                lblLocationHeight.constant = 0
            } else if txtDescription == textField {
                lblDescriptionHeight.constant = 0
            }
            btnSubmit.backgroundColor = #colorLiteral(red: 0.5333333333, green: 0.5294117647, blue: 0.5294117647, alpha: 1)
            btnSubmit.isUserInteractionEnabled = false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        getTextField()
    }
    func textFieldDelegate() {
        txtCategory.delegate = self
        txtProductName.delegate = self
        txtPhone.delegate = self
        txtLocation.delegate = self
        txtDescription.delegate = self
        lblselectCategoryHeight.constant = 0
        lblPhoneHeight.constant = 0
        lblNameProductHeight.constant = 0
        lblLocationHeight.constant = 0
        lblDescriptionHeight.constant = 0
        collectionHeight.constant = 0
    }
    func getTextField() {
        if txtCategory.text == "" {
            return
        } else if txtProductName.text == ""{
            return
        } else if txtPhone.text == "" {
            return
        } else if txtLocation.text == "" {
            return
        } else if txtDescription.text == ""{
            return
        }
        btnSubmit.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
        btnSubmit.isUserInteractionEnabled = true
    }
}
// MARK: - collectionView cell class
class AddProductCollectionCell: UICollectionViewCell {
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var imgView: UIImageView!
}
