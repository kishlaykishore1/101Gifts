//
//  HelpVC.swift
//  Gifts-iOS
//
//  Created by angrej singh on 06/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit

class HelpVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Properties
    var data = [DataIsExpendable(isExpendable: false), DataIsExpendable(isExpendable: false), DataIsExpendable(isExpendable: false), DataIsExpendable(isExpendable: false), DataIsExpendable(isExpendable: false)]
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func action_Back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - TableView DataSource
extension HelpVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpCell", for: indexPath) as! HelpCell
        if data[indexPath.row].isExpendable {
            cell.lblTitle.textColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
        } else {
            cell.lblTitle.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        }
        return cell
    }
}
// MARK: - TableView Delegate
extension HelpVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (data[indexPath.row].isExpendable) ? UITableView.automaticDimension : 72
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        data[indexPath.row].isExpendable = !( data[indexPath.row].isExpendable)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
}
// MARK: - TableView Cell Class
class HelpCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
}
class DataIsExpendable {
    var isExpendable: Bool = false
    init(isExpendable: Bool) {
        self.isExpendable = isExpendable
    }
}
