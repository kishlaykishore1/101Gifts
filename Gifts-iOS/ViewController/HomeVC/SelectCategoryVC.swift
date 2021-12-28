//
//  SelectCategoryVC.swift
//  Gifts-iOS
//
//  Created by angrej singh on 06/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit
import AlamofireImage

class SelectCategoryVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    // MARK: - Properties
    var categoryData: CategoryModel?
    var AddNewProductVC: AddNewProductVC?
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        apiSelectCategory()
    }
    @IBAction func action_Back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - Collection DataSource
extension SelectCategoryVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData?.category.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectCategoryCell", for: indexPath) as! SelectCategoryCell
        cell.lblName.text = categoryData?.category[indexPath.row].name
        if let url = URL(string: categoryData?.category[indexPath.row].image ?? "") {
            cell.imgView.af_setImage(withURL: url)
        }
        return cell
    }
}
// MARK: - Collection Delegate
extension SelectCategoryVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
// MARK: - Collection Delegate FlowLayout
extension SelectCategoryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        return CGSize(width: collectionWidth/3 - 3, height: 140.0)
    }
}
// MARK: - API Calling
extension SelectCategoryVC {
    func apiSelectCategory() {
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
}
// MARK: - Collection Cell Class
class SelectCategoryCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
}
