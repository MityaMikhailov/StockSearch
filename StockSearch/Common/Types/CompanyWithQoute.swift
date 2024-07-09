//
//  CompanyWithQoute.swift
//  StockSearch
//
//  Created by Dmitriy Mikhailov on 09.07.2024.
//

import Foundation

class CompanyWithQoute {
    let symbol: String
    let companyName: String
    let logoURL: String
    let currentPrice: Double
    let changeValue: Double
    let percentChange: Double
    
    init(symbol: String, companyName: String, logoURL: String, currentPrice: Double, changeValue: Double, percentChange: Double) {
        self.symbol = symbol
        self.companyName = companyName
        self.logoURL = logoURL
        self.currentPrice = currentPrice
        self.changeValue = changeValue
        self.percentChange = percentChange
    }
    
}
