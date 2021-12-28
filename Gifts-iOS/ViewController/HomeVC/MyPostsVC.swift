//
//  MyPostsVC.swift
//  Gifts-iOS
//
//  Created by angrej singh on 02/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit

class MyPostsVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
}
// MARK: - Action Method
extension MyPostsVC {
    @IBAction func action_BackTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func action_EditPost(_ sender: UIButton) {
        let aboutVC = StoryBoard.Home.instantiateViewController(withIdentifier: "AddNewProductVC") as! AddNewProductVC
        guard let getNav = UIApplication.topViewController()?.navigationController else {
            return
        }
        let rootNavView = UINavigationController(rootViewController: aboutVC)
        getNav.present( rootNavView, animated: true, completion: nil)
    }
    @IBAction func action_DeletePost(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Permanently", message: "Are you sure you want to delete this product and it’s information ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
        }))
        self.present(alert, animated: true)
    }
    @IBAction func action_MarkGifted(_ sender: UIButton) {
    }
}
// MARK: - TableView DataSource
extension MyPostsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPostsCell", for: indexPath) as! MyPostsCell
        cell.btnEdit.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.btnMarkGift.tag = indexPath.row
        return cell
    }
}
// MARK: - TableView Cell Class
class MyPostsCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnMarkGift: UIButton!
}
