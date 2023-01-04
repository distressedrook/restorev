//
//  PendingReview.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 02/08/21.
//

import Foundation

struct PendingRestaurants: Codable {
    let restaurantName: String
    var pendingReviews: [Review]
}
