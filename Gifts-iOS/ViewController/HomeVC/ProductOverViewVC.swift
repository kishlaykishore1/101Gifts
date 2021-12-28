//
//  ProductOverViewVC.swift
//  Gifts-iOS
//
//  Created by angrej singh on 30/09/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit
import AlamofireImage

class ProductOverViewVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblOwnerName: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    // MARK: - Properties
    var dataSource: ProductOverViewModel?
    var productID: Int?
    var favouriteStatus: Int?
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        apiProductOverView()
    }
    @IBAction func action_PageControl(_ sender: UIPageControl) {
        pageControl.currentPage = dataSource?.image.count ?? 0
    }
}
// MARK: - Action Method
extension ProductOverViewVC {
    @IBAction func action_Back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func action_FavItem(_ sender: UIButton) {
        if dataSource?.favoriteStatus == 1 {
            favouriteStatus = 0
        } else {
            favouriteStatus = 1
        }
        apiFavProduct()
    }
    @IBAction func action_ContactOwner(_ sender: UIButton) {
        let aboutVC = StoryBoard.Home.instantiateViewController(withIdentifier: "OwnerInfoVC") as! OwnerInfoVC
        aboutVC.Name = dataSource?.userName ?? ""
        aboutVC.ownerContact = dataSource?.mobile ?? ""
        aboutVC.comment = dataSource?.userComment ?? ""
        guard let getNav = UIApplication.topViewController()?.navigationController else {
            return
        }
        let rootNavView = UINavigationController(rootViewController: aboutVC)
        getNav.present( rootNavView, animated: true, completion: nil)
    }
    func dataSet() {
        if dataSource?.favoriteStatus == 1 {
            btnFav.setImage(#imageLiteral(resourceName: "FavoriteFill"), for: .normal)
        } else {
            btnFav.setImage(#imageLiteral(resourceName: "FavStarUnfill"), for: .normal)
        }
        lblName.text = dataSource?.name ?? ""
        lblOwnerName.text = dataSource?.userName ?? ""
        lblMobile.text = dataSource?.mobile ?? ""
        lblAddress.text = dataSource?.address ?? ""
        lblDescription.text = dataSource?.productDescription ?? ""
    }
}
// MARK: - Api CollectionView DataSource
extension ProductOverViewVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.image.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionCell
        self.pageControl.numberOfPages = dataSource?.image.count ?? 0
        if let url = URL(string: dataSource?.image[indexPath.row].image ?? "") {
            cell.imgView.af_setImage(withURL: url)
        }
        return cell
    }
}
// MARK: - Api CollectionView Delegate
extension ProductOverViewVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        return CGSize(width: collectionWidth/1  , height: collectionView.bounds.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}
// MARK: - Api Calling
extension ProductOverViewVC {
    func apiProductOverView() {
        let param: [String : Any] = ["user_id": MemberModel.getMemberModel()?.userID ?? 0, "product_id": productID ?? 0, "type": getLanguage()]
        if let getRequest = API.PRODUCTDETAILS.request(method: .post, with: param, forJsonEncoding: true) {
            Global.showLoadingSpinner()
            getRequest.responseJSON { response in
                Global.dismissLoadingSpinner()
                API.PRODUCTDETAILS.validatedResponse(response, completionHandler: { (jsonObject, error) in
                    guard error == nil, let getData = jsonObject?["data"] as? [String: Any] else {
                        Common.showAlertMessage(message: jsonObject?["message"] as? String ?? "", alertType: .error)
                        return
                    }
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        self.dataSource = try decoder.decode(ProductOverViewModel.self, from: jsonData)
                        self.collectionView.reloadData()
                        self.dataSet()
                    } catch let err {
                        print("Err", err)
                    }
                })
            }
        }
    }
    func apiFavProduct() {
        //MemberModel.getMemberModel()?.userID ?? 0
        let param: [String : Any] = ["user_id": "238", "product_id": dataSource?.id ?? 0, "favouriteStatus": favouriteStatus ?? 0]
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
                    self.apiProductOverView()
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }
    }
}
// MARK: - CollectionCell
class CollectionCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
}
