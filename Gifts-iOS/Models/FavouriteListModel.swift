//
//  FavouriteListModel.swift
//  Gifts-iOS
//
//  Created by angrej singh on 13/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import Foundation
// MARK: - FavouriteListModel
struct FavouriteListModel: Codable {
    let productCount: Int?
    let product: [Productt]
    enum CodingKeys: String, CodingKey {
        case productCount = "product_count"
        case product
    }
}
// MARK: - Product
struct Productt: Codable {
    let id: Int?
    let catName: String?
    let favoriteStatus: Int?
    let userName: String?
    let isGifted: Int?
    let name, categoryID, productDescription, mobile: String?
    let address: String?
    let image: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case catName = "cat_name"
        case favoriteStatus = "favorite_status"
        case userName = "user_name"
        case isGifted = "is_gifted"
        case name
        case categoryID = "category_id"
        case productDescription = "description"
        case mobile, address, image
        case createdAt = "created_at"
    }
}
