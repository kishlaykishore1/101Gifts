//
//  FavouritesVC.swift
//  Gifts-iOS
//
//  Created by angrej singh on 06/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit
import AlamofireImage

class FavouritesVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblNoProduct: UILabel!
    // MARK: - Properties
    var dataSource: FavouriteListModel?
    var favouriteStatus: Int?
    var productID: Int?
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        apiFavList()
    }
}
// MARK: - Action Method
extension FavouritesVC {
    @IBAction func action_Back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func action_Fav(_ sender: UIButton) {
        productID = dataSource?.product[sender.tag].id
        if dataSource?.product[sender.tag].favoriteStatus == 1 {
            favouriteStatus = 0
        } else {
            favouriteStatus = 1
        }
        apiFavProduct()
    }
}
// MARK: - Collection View DataSource
extension FavouritesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.product.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavCollectionCell", for: indexPath) as! FavCollectionCell
        if let url = URL(string: dataSource?.product[indexPath.row].image ?? "") {
            cell.imgView.af_setImage(withURL: url)
        }
        if dataSource?.product[indexPath.row].favoriteStatus == 0 {
            cell.btnFav.setImage(#imageLiteral(resourceName: "FavStarUnfill"), for: .normal)
        } else {
            cell.btnFav.setImage(#imageLiteral(resourceName: "FavoriteFill"), for: .normal)
        }
        DispatchQueue.main.async {
            cell.imgView.roundCorners([.topLeft, .topRight], radius: 10)
        }
        cell.lblName.text = dataSource?.product[indexPath.row].name ?? ""
        return cell
    }
}
// MARK: - Collection Delegate FlowLayout
extension FavouritesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2 - 10, height: 208.0)
    }
}
// MARK: - Api Calling Product details
extension FavouritesVC {
    func apiFavList() {
        // MemberModel.getMemberModel()?.userID ?? 0
        let param: [String : Any] = ["user_id": MemberModel.getMemberModel()?.userID ?? 0, "type": getLanguage()]
        if let getRequest = API.FAVOURITELIST.request(method: .post, with: param, forJsonEncoding: true) {
            Global.showLoadingSpinner()
            getRequest.responseJSON { response in
                Global.dismissLoadingSpinner()
                switch response.result {
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    guard let response = JSON as? [String: Any] else {
                        return
                    }
                    guard let getResponse = response["response"] as? [String: Any] else {
                        return
                    }
                    guard let getData = getResponse["data"] as? [String: Any] else {
                        return
                    }
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        self.dataSource = try decoder.decode(FavouriteListModel.self, from: jsonData)
                        if self.dataSource?.product.count == 0 {
                            self.collectionView.isHidden = true
                            self.lblNoProduct.isHidden = false
                        } else {
                            self.collectionView.isHidden = false
                            self.lblNoProduct.isHidden = true
                        }
                        self.collectionView.reloadData()
                    } catch let err {
                        print("Err", err)
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }
    }
    func apiFavProduct() {

        let param: [String : Any] = ["user_id": MemberModel.getMemberModel()?.userID ?? 0, "product_id": productID ?? 0, "favouriteStatus": favouriteStatus ?? 0]
        if let getRequest = API.FAVOURITE.request(method: .post, with: param, forJsonEncoding: true) {
            Global.showLoadingSpinner()
            getRequest.responseJSON { response in
                Global.dismissLoadingSpinner()
                switch response.result {
                case .success(let JSON):
                    print("Success with JSON: \(JSON)")
                    guard let response = JSON as? [String: Any] else {
                        return
                    }
                    guard let getResponse = response["response"] as? [String: Any] else {
                        return
                    }
                    print(getResponse)
                    Common.showAlertMessage(message: getResponse["message"] as? String ?? "", alertType: .success)
                    self.apiFavList()
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }
    }
}
// MARK: - Collection View Cell
class FavCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnFav: UIButton!
}
