//
//  UserProfileModel.swift
//  Gifts-iOS
//
//  Created by angrej singh on 12/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import Foundation
// MARK: - UserProfileModel
struct UserProfileModel: Codable {
    let userID, fullName, email, mobile: String
    let gender, languageType, address, token: String?
    let image: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case fullName = "full_name"
        case email, mobile, gender
        case languageType = "language_type"
        case address, token, image
    }
}
