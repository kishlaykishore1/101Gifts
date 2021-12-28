//
//  LocationVC.swift
//  Gifts-iOS
//
//  Created by angrej singh on 06/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Properties
    var home: HomeVC?
    var AddNewProductVC: AddNewProductVC?
    let locationManager = CLLocationManager()
    var dataSource: GetLocationModel?
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.apiGetLocation()
        self.navigationController?.navigationBar.isHidden = true
    }
}
// MARK: - Action Method
extension LocationVC {
    @IBAction func action_Back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - TableView DataSource
extension LocationVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return dataSource?.location.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            cell.lblLocation.text = home?.userProfileData?.address ?? ""
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            cell.lblLocation.text = dataSource?.location[indexPath.row].location ?? ""
            return cell
        }
    }
}
// MARK: - TableView Delegate
extension LocationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        if section == 0 {
            let label = UILabel(frame: CGRect(x:16, y:28, width:tableView.frame.size.width, height:18))
            label.font = UIFont(name: "Poppins-Medium", size: 14.0)
            label.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            label.text = "Current Location"
            headerView.addSubview(label)
        } else {
            let label = UILabel(frame: CGRect(x:16, y:28, width:tableView.frame.size.width, height:18))
            label.font = UIFont(name: "Poppins-Medium", size: 14.0)
            label.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            label.text = "Recent Location"
            headerView.addSubview(label)
        }
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            // Specify the place data types to return.
            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))!
            autocompleteController.placeFields = fields
            // Display the autocomplete view controller.
            self.present(autocompleteController, animated: true, completion: nil)
        } else {
            self.dismiss(animated: true) {
                self.AddNewProductVC?.txtLocation.text = self.dataSource?.location[indexPath.row].location
                self.AddNewProductVC?.lat = Double(self.dataSource?.location[indexPath.row].latitude ?? "")
                self.AddNewProductVC?.Long = Double(self.dataSource?.location[indexPath.row].longitude ?? "")
            }
        }
    }
}
// MARK: - Google Place Autocomplete
extension LocationVC:GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let plc = place.name
        dismiss(animated: true) {
            self.dismiss(animated: true) {
                self.AddNewProductVC?.txtLocation.text = plc
                self.AddNewProductVC?.lat = place.coordinate.latitude
                self.AddNewProductVC?.Long = place.coordinate.longitude
            }
        }
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - API Calling
extension LocationVC {
    func apiGetLocation() {
        let param: [String : Any] = ["user_id": "238"]
        if let getRequest = API.GETLOCATION.request(method: .post, with: param, forJsonEncoding: true) {
            Global.showLoadingSpinner()
            getRequest.responseJSON { response in
                Global.dismissLoadingSpinner()
                API.GETLOCATION.validatedResponse(response, completionHandler: { (jsonObject, error) in
                    guard error == nil, let getData = jsonObject?["data"] as? [String: Any] else {
                        Common.showAlertMessage(message: jsonObject?["message"] as! String , alertType: .error)
                        return
                    }
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                        let decoder = JSONDecoder()
                        self.dataSource = try decoder.decode(GetLocationModel.self, from: jsonData)
                        self.tableView.reloadData()
                    } catch let err {
                        print("Err", err)
                    }
                })
            }
        }
    }
}
// MARK: - TableView Cell Class
class LocationCell: UITableViewCell {
    @IBOutlet weak var lblLocation: UILabel!
}
