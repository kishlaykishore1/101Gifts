//
//  NotificationVC.swift
//  Gifts-iOS
//
//  Created by angrej singh on 06/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
}
// MARK: - Action Method
extension NotificationVC {
    @IBAction func action_Back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - TableView DataSource
extension NotificationVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        return cell
    }
}
// MARK: - TableView Cell Class
class NotificationCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
}
