//
//  CurrencyConverter.swift
//  Shopping
//
//  Created by ahmed on 01/02/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import Foundation

func CurrencyConverter(_ number:Double) -> String {
    
    let currencyFormater = NumberFormatter()
    currencyFormater.usesGroupingSeparator = true
    currencyFormater.numberStyle = .currency
    currencyFormater.locale = Locale.current
    return currencyFormater.string(from: NSNumber(value: number))!
    
}
