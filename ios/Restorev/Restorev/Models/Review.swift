//
//  Review.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 01/08/21.
//

import Foundation

struct Review: Codable {
    let restaurantId: String
    let visitedDate: Int
    let rating: Int
    let ownerComment: String?
    let id: String
    let review: String
    let reviewer: User
}
