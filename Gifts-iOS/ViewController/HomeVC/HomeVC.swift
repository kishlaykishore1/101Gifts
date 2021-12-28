//
//  HomeVC.swift
//  Gifts-iOS
//
//  Created by angrej singh on 23/09/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit
import SideMenu
import AlamofireImage
import GooglePlaces
class HomeVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblAddressName: UILabel!
    // MARK: - Properties
    var arrName = ["Clothes", "Kitchen Appliances", "Electronics", "Baby Essentials", "Home Appliances", "Furniture", "Pets and Essentials", "Toys", "Other Appliances"]
    var arrImg = [ #imageLiteral(resourceName: "clothe"), #imageLiteral(resourceName: "mixer"), #imageLiteral(resourceName: "washing"), #imageLiteral(resourceName: "basinet"), #imageLiteral(resourceName: "cleaning"), #imageLiteral(resourceName: "furniture"), #imageLiteral(resourceName: "dog"), #imageLiteral(resourceName: "Page-1"), #imageLiteral(resourceName: "fan")]
    var categoryData: CategoryModel?
    var userProfileData: UserProfileModel?
    var updateLocData: UpdateLocation?
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.searchBar.isTranslucent = true
        self.searchBar.searchTextField.backgroundColor = UIColor.clear
        self.searchBar.searchTextField.borderStyle = .none
        apiCategoryList()
        apiUserProfile()
    }
    @IBAction func actionAddressPickup(_ sender: UIView) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))!
        autocompleteController.placeFields = fields
        // Display the autocomplete view controller.
        self.present(autocompleteController, animated: true, completion: nil)}
    @IBAction func action_MenuShow(_ sender: UIButton) {
        openSideMenu()
    }
    func openSideMenu() {
        let viewController = StoryBoard.Home.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        viewController.home = self
        viewController.userProfileData = self.userProfileData
        let menu = SideMenuNavigationController(rootViewController: viewController )
        menu.presentationStyle = .menuSlideIn
        menu.statusBarEndAlpha = 0
        menu.leftSide = true
        // menu.settings.blurEffectStyle = .dark
        menu.presentationStyle.presentingEndAlpha = 0.5
        menu.settings.enableTapToDismissGesture = true
        menu.menuWidth = UIScreen.main.bounds.size.width * 0.75
        present(menu, animated: true, completion: nil)
    }
}
// MARK: - Google Place Autocomplete
extension HomeVC:GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        apiUpdateLocation(lat: place.coordinate.latitude, long: place.coordinate.longitude, Address: place.name ?? "")
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - Collection DataSource
extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData?.category.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.lblName.text = categoryData?.category[indexPath.row].name
        if let url = URL(string: categoryData?.category[indexPath.row].image ?? "") {
            cell.imgView.af_setImage(withURL: url)
        }
        return cell
    }
}
// MARK: - Collection Delegate
extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = StoryBoard.Home.instantiateViewController(identifier: "ProductDetailVC") as! ProductDetailVC
        vc.pTitle = categoryData?.category[indexPath.row].name ?? ""
        vc.categoryID = categoryData?.category[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - Collection Delegate FlowLayout
extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        return CGSize(width: collectionWidth/3 - 3, height: 140.0)
    }
}
// MARK: - Collection Cell Class
class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
}
// MARK: - API Calling
extension HomeVC {
    func apiCategoryList() {
        let param: [String : Any] = ["type": getLanguage()]
        if let getRequest = API.CATEGORYSELECT.request(method: .post, with: param, forJsonEncoding: true) {
            Global.showLoadingSpinner()
            getRequest.responseJSON { response in
                Global.dismissLoadingSpinner()
                API.CATEGORYSELECT.validatedResponse(response, completionHandler: { (jsonObject, error) in
                    guard error == nil, let getData = jsonObject?["data"] as? [String: Any] else {
                        Common.showAlertMessage(message: jsonObject?["message"] as! String , alertType: .error)
                        return
                    }
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        self.categoryData = try decoder.decode(CategoryModel.self, from: jsonData)
                        self.collectionView.reloadData()
                    } catch let err {
                        print("Err", err)
                    }
                })
            }
        }
    }
  // MARK: - APi Update Location....
    func apiUpdateLocation(lat:Double,long:Double,Address:String) {
        let param: [String : Any] = ["user_id": MemberModel.getMemberModel()?.userID ?? 0  ,"address":Address,"longitude":lat,"latitude":long]
        if let getRequest = API.UPDATELOCATION.request(method: .post, with: param, forJsonEncoding: true) {
            Global.showLoadingSpinner()
            getRequest.responseJSON { response in
                Global.dismissLoadingSpinner()
                API.UPDATELOCATION.validatedResponse(response, completionHandler: { (jsonObject, error) in
                    guard error == nil, let getData = jsonObject?["data"] as? [String: Any] else {
                        Common.showAlertMessage(message: jsonObject?["message"] as! String , alertType: .error)
                        return
                    }
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        self.updateLocData = try decoder.decode(UpdateLocation.self, from: jsonData)
                        self.lblAddressName.text = self.updateLocData?.address
                    } catch let err {
                        print("Err", err)
                    }
                })
            }
        }
    }
    // MARK: - UserProfile Get
    func apiUserProfile() {
        let param: [String : Any] = ["user_id": MemberModel.getMemberModel()?.userID ?? 0 ]
        if let getRequest = API.USERPROFILE.request(method: .get, with: param, forJsonEncoding: true) {
            Global.showLoadingSpinner()
            getRequest.responseJSON { response in
                Global.dismissLoadingSpinner()
                API.USERPROFILE.validatedResponse(response, completionHandler: { (jsonObject, error) in
                    guard error == nil, let getData = jsonObject?["data"] as? [String: Any] else {
                        Common.showAlertMessage(message: jsonObject?["message"] as? String ?? "", alertType: .error)
                        return
                    }
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        self.userProfileData = try decoder.decode(UserProfileModel.self, from: jsonData)
                        self.lblAddressName.text = self.userProfileData?.address ?? ""
                    } catch let err {
                        print("Err", err)
                    }
                })
            }
        }
    }
}
