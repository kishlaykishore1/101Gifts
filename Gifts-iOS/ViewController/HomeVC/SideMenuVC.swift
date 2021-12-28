//
//  SideMenuVC.swift
//  Gifts-iOS
//
//  Created by angrej singh on 24/09/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit
import AlamofireImage

class SideMenuVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    var viewController: UIViewController?
    // MARK: - Properties
    var userProfileData: UserProfileModel?
    var home: HomeVC?
    var menuImage = [ #imageLiteral(resourceName: "home"), #imageLiteral(resourceName: "favorite"), #imageLiteral(resourceName: "cardboard"), #imageLiteral(resourceName: "smile"), #imageLiteral(resourceName: "bell"), #imageLiteral(resourceName: "round")]
    var menuName = ["Home", "My Favourites", "My Posts", "My Profile", "Notifications", "Help"]
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        headerConfiguration()
        footerConfiguration()
        userDataSet()
    }
}
// MARK: - Action And Functions
extension SideMenuVC {
    @IBAction func action_AddProduct(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.dismiss(animated: true,completion: {
                let aboutVC = StoryBoard.Home.instantiateViewController(withIdentifier: "AddNewProductVC") as! AddNewProductVC
                aboutVC.home = self.home
                guard let getNav = UIApplication.topViewController()?.navigationController else {
                    return
                }
                let rootNavView = UINavigationController(rootViewController: aboutVC)
                getNav.present( rootNavView, animated: true, completion: nil)
            })
        }
    }
    @IBAction func action_LogOut(_ sender: UIControl) {
        self.dismiss(animated: true) { [self] in
            let alert = UIAlertController(title: "Logout?", message: "Are you sure you want to logout..?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
                self.apiLogout()
            }))
            home?.present(alert, animated: true)
        }
    }
    func userDataSet() {
        if let url = URL(string: userProfileData?.image ?? "") {
            userProfile.af_setImage(withURL: url)
        }
        lblUserName.text = userProfileData?.fullName ?? ""
        lblAddress.text = userProfileData?.address ?? ""
    }
}
// MARK: - TableView DataSource
extension SideMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuImage.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
        cell.imgView.image = menuImage[indexPath.row]
        cell.lblName.text = menuName[indexPath.row]
        return cell
    }
}
// MARK: - TableView delegate
extension SideMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.dismiss(animated: true, completion: nil)
        case 1:
            self.dismiss(animated: true,completion: {
                let aboutVC = StoryBoard.Home.instantiateViewController(withIdentifier: "FavouritesVC") as! FavouritesVC
                guard let getNav = UIApplication.topViewController()?.navigationController else {
                    return
                }
                let rootNavView = UINavigationController(rootViewController: aboutVC)
                getNav.present( rootNavView, animated: true, completion: nil)
            })
        case 2:
            self.dismiss(animated: true,completion: {
                let aboutVC = StoryBoard.Home.instantiateViewController(withIdentifier: "MyPostsVC") as! MyPostsVC
                guard let getNav = UIApplication.topViewController()?.navigationController else {
                    return
                }
                let rootNavView = UINavigationController(rootViewController: aboutVC)
                getNav.present( rootNavView, animated: true, completion: nil)
            })
        case 3:
            self.dismiss(animated: true,completion: {
                let aboutVC = StoryBoard.Home.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
                aboutVC.userProfileData = self.userProfileData
                aboutVC.home = self.home
                guard let getNav = UIApplication.topViewController()?.navigationController else {
                    return
                }
                let rootNavView = UINavigationController(rootViewController: aboutVC)
                getNav.present( rootNavView, animated: true, completion: nil)
            })
        case 4:
            self.dismiss(animated: true,completion: {
                let aboutVC = StoryBoard.Home.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
                guard let getNav = UIApplication.topViewController()?.navigationController else {
                    return
                }
                let rootNavView = UINavigationController(rootViewController: aboutVC)
                getNav.present( rootNavView, animated: true, completion: nil)
            })
        case 5:
            self.dismiss(animated: true,completion: {
                let aboutVC = StoryBoard.Home.instantiateViewController(withIdentifier: "HelpVC") as! HelpVC
                guard let getNav = UIApplication.topViewController()?.navigationController else {
                    return
                }
                let rootNavView = UINavigationController(rootViewController: aboutVC)
                getNav.present( rootNavView, animated: true, completion: nil)
            })
        default:
            break
        }
    }
}
// MARK: - TableView Header
extension SideMenuVC {
    func headerConfiguration() {
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerView.frame.height)
        tableView.tableHeaderView = headerView
        tableView.tableHeaderView?.frame =  headerView.frame
    }
    func footerConfiguration() {
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: footerView.frame.height)
        tableView.tableFooterView =  footerView
        tableView.tableFooterView?.frame =  footerView.frame
    }
}
// MARK: - Api Call Logout
extension SideMenuVC {
    func apiLogout() {
        let param: [String : Any] = ["user_id": MemberModel.getMemberModel()?.userID ?? 0 ]
        if let getRequest = API.LOGOUT.request(method: .post, with: param, forJsonEncoding: true) {
            Global.showLoadingSpinner()
            getRequest.responseJSON { response in
                Global.dismissLoadingSpinner()
                API.LOGOUT.validatedResponse(response, completionHandler: { (jsonObject, error) in
                    guard error == nil else {
                        Common.showAlertMessage(message: jsonObject?["message"] as? String ?? "" , alertType: .error)
                        return
                    }
                    Common.showAlertMessage(message: jsonObject?["message"] as! String , alertType: .success)
                    Global.clearAllAppUserDefaults()
                    if #available(iOS 13.0, *) {
                        let scene = UIApplication.shared.connectedScenes.first
                        if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                            sd.isUserLogin(false)
                        }
                    } else {
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.isUserLogin(false)
                    }
                })
            }
        }
    }
}
// MARK: - Table View Cell Class
class TableCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
}
