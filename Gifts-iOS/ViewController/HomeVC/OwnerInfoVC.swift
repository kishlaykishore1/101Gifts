//
//  OwnerInfoVC.swift
//  Gifts-iOS
//
//  Created by angrej singh on 07/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit

class OwnerInfoVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var ownerPhone: UILabel!
    @IBOutlet weak var comments: UILabel!
    // MARK: - Properties
    var Name = ""
    var ownerContact = ""
    var comment = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        ownerName.text = Name
        ownerPhone.text = ownerContact
        comments.text = comment
    }
}
// MARK: - Action Method
extension OwnerInfoVC {
    @IBAction func action_Back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
