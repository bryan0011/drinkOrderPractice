//
//  DrinkOption.swift
//  drinkOrderPractice
//
//  Created by Bryan Kuo on 2022/5/23.
//

import Foundation

struct DrinkOption {
    let optionChoice: OptionChoice
    let names:[String]
}

enum OptionChoice: String {
    case sweet = "甜度選擇"
    case ice = "冰熱選擇"
    case size = "尺寸選擇"
    case pearl = "加白玉或水玉"
    
}
