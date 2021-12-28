//
//  SelectCategoryModel.swift
//  Gifts-iOS
//
//  Created by kishlay kishore on 09/10/20.
//  Copyright © 2020 com.gifts.ios. All rights reserved.
//

import Foundation
// MARK: - CategoryModel
struct CategoryModel: Codable {
    let category: [Category]
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let name, slug: String
    let image: String
    let subCategory: [Int]?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, image
        case subCategory = "sub_category"
    }
}
