//
//  OrderList.swift
//  drinkOrderPractice
//
//  Created by Bryan Kuo on 2022/5/24.
//

import Foundation

struct OrderList: Codable {
    let records: [Type]
}

struct Type: Codable {
    let id: String?
    let fields: Option
}

struct Option: Codable {
    let name: String
    let drinkName: String
    let temperature: String
    let sweet: String
    let topping: String
    let finalPrice: String?
    let cupSize: String
}
