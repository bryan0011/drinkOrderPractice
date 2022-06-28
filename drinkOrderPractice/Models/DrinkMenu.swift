//
//  DrinkMenu.swift
//  drinkOrderPractice
//
//  Created by Bryan Kuo on 2022/5/20.
//

import Foundation

struct DrinkMenu: Decodable {
    let records: [Record]
}

struct Record: Decodable {
    let fields: Field
}

struct Field: Decodable {
    let description: String
    let drinkName: String
    let mediumPrice: String
    let drinkImage: [DrinkImage]
    let largePrice: String?
}

struct DrinkImage: Decodable {
    let url: URL
}
