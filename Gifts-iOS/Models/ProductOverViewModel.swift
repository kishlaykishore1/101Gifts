//
//  ProductOverViewModel.swift
//  Gifts-iOS
//
//  Created by angrej singh on 13/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import Foundation
// MARK: - UserProfileModel
struct ProductOverViewModel: Codable {
    let id: Int?
    let userComment, catName: String?
    let favoriteStatus: Int?
    let userName: String?
    let isGifted: Int?
    let name, productDescription, mobile, address: String?
    let latitude, longitude: String?
    let image: [Image]
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userComment = "user_comment"
        case catName = "cat_name"
        case favoriteStatus = "favorite_status"
        case userName = "user_name"
        case isGifted = "is_gifted"
        case name
        case productDescription = "description"
        case mobile, address, latitude, longitude, image
        case createdAt = "created_at"
    }
}

// MARK: - Image
struct Image: Codable {
    let id: String?
    let image: String?
}
