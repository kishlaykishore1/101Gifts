//
//  MemberModel.swift
//  Gifts-iOS
//
//  Created by kishlay kishore on 07/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import Foundation

// MARK: - MemberModel
class MemberModel: Codable {
    let userID, fullName, email, mobile: String
    let gender, address, languageType, token: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case fullName = "full_name"
        case email, mobile, gender, address
        case languageType = "language_type"
        case token, image
    }
    static func storeMemberModel(value: [String: Any]) {
        Constants.kUserDefaults.set(value, forKey: "Member")
    }
    static func getMemberModel() -> MemberModel? {
        if let getData = Constants.kUserDefaults.value(forKey: "Member") as? [String: Any] {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: getData, options: .prettyPrinted)
                do {
                    let decoder = JSONDecoder()
                    return try decoder.decode(MemberModel.self, from: jsonData)
                } catch let err {
                    print("Err", err)
                }
            } catch {
                print(error.localizedDescription)
            }
        }        
        return nil
    }
}
