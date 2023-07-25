//
//  ProductJSON.swift
//  SecondStore
//
//  Created by Carlos Rafael Reyes Magadán on 2/26/23.
//

import Foundation
import SwiftUI

struct ProductJSON: Codable, Hashable {
    let id: Int?
    let title: String?
    let price: Double?
    let category: String?
    let description: String?
    let image: String?
}
