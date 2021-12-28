//
//  GetLocation.swift
//  Gifts-iOS
//
//  Created by angrej singh on 13/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import Foundation

// MARK: - GetLocationModel
struct GetLocationModel: Codable {
    let location: [Location]
}
// MARK: - Location
struct Location: Codable {
    let id: Int
    let location, latitude, longitude, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, location, latitude, longitude
        case createdAt = "created_at"
    }
}
