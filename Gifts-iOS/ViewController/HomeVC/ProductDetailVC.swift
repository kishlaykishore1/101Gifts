//
//  ProductDetailVC.swift
//  Gifts-iOS
//
//  Created by angrej singh on 30/09/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit
import AlamofireImage

class ProductDetailVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lvlNoProduct: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    // MARK: - properties
    var pTitle = ""
    var dataSource: ProductDetailsModel?
    var categoryID: Int?
    var favouriteStatus: Int?
    var productID: Int?
    var isFav = false
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = pTitle
    }
    override func viewWillAppear(_ animated: Bool) {
        apiProductDetails()
    }
}
// MARK: - Action Method
extension ProductDetailVC {
    @IBAction func action_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func action_ProductFav(_ sender: UIButton) {
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
extension ProductDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.product.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionCell", for: indexPath) as! ProductCollectionCell
        DispatchQueue.main.async {
            cell.imgView.roundCorners([.topLeft, .topRight], radius: 10)
        }
        let data = dataSource?.product[indexPath.row]
        cell.btnFavProduct.tag = indexPath.row
        cell.lblProductName.text = data?.name ?? ""
        if let url = URL(string: data?.image ?? "") {
            cell.imgView.af_setImage(withURL: url)
        }
        if data?.favoriteStatus == 0 {
            cell.btnFavProduct.setImage(#imageLiteral(resourceName: "FavStarUnfill"), for: .normal)
        } else {
            cell.btnFavProduct.setImage(#imageLiteral(resourceName: "FavoriteFill"), for: .normal)
        }
        return cell
    }
}
// MARK: - Collection View Delegate
extension ProductDetailVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = StoryBoard.Home.instantiateViewController(identifier: "ProductOverViewVC") as! ProductOverViewVC
        vc.productID = dataSource?.product[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: - Collection Delegate FlowLayout
extension ProductDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2 - 10, height: 208.0)
    }
}
// MARK: - Api Calling Product details
extension ProductDetailVC {
    func apiProductDetails() {
        let param: [String : Any] = ["user_id": MemberModel.getMemberModel()?.userID ?? 0, "type": getLanguage(), "category_id": categoryID ?? 0]
        if let getRequest = API.PRODUCTLIST.request(method: .post, with: param, forJsonEncoding: true) {
            Global.showLoadingSpinner()
            getRequest.responseJSON { response in
                Global.dismissLoadingSpinner()
                API.PRODUCTLIST.validatedResponse(response, completionHandler: { (jsonObject, error) in
                    guard error == nil, let getData = jsonObject?["data"] as? [String: Any] else {
                        Common.showAlertMessage(message: jsonObject?["message"] as? String ?? "", alertType: .error)
                        return
                    }
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        self.dataSource = try decoder.decode(ProductDetailsModel.self, from: jsonData)
                        if self.dataSource?.productCount == 0 {
                            self.collectionView.isHidden = true
                            self.lvlNoProduct.isHidden = false
                        } else {
                            self.collectionView.isHidden = false
                            self.lvlNoProduct.isHidden = true
                        }
                        self.collectionView.reloadData()
                    } catch let err {
                        print("Err", err)
                    }
                })
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
                    self.apiProductDetails()
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }
    }
}
// MARK: - Collection Cell Class
class ProductCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var btnFavProduct: UIButton!
}
