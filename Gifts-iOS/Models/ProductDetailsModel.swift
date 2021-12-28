//
//  ProductDetailsModel.swift
//  Gifts-iOS
//
//  Created by angrej singh on 12/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import Foundation
// MARK: - ProductDetailsModel
struct ProductDetailsModel: Codable {
    let productCount: Int?
    var product: [Product]
    enum CodingKeys: String, CodingKey {
        case productCount = "product_count"
        case product
    }
}
// MARK: - Product
struct Product: Codable {
    let id: Int?
    let catName: String?
    let favoriteStatus: Int?
    let userName: String?
    let isGifted: Int?
    let name, mobile, productDescription, address: String?
    let latitude, longitude: String?
    let image: String?
    let createdAt: String?
    enum CodingKeys: String, CodingKey {
        case id
        case catName = "cat_name"
        case favoriteStatus = "favorite_status"
        case userName = "user_name"
        case isGifted = "is_gifted"
        case name, mobile
        case productDescription = "description"
        case address, latitude, longitude, image
        case createdAt = "created_at"
    }
}
