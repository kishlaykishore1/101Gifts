//
//  UpdateLocation.swift
//  Gifts-iOS
//
//  Created by kishlay kishore on 09/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import Foundation
// MARK: - UpdateLocation
struct UpdateLocation: Codable {
    let userID, address, latitude, longitude: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case address, latitude, longitude
    }
}
