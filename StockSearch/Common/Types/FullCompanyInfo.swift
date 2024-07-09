//
//  FullCompanyInfo.swift
//  StockSearch
//
//  Created by Dmitriy Mikhailov on 09.07.2024.
//

import Foundation

class FullCompanyInfo: Codable {
    let symbol: String
    let companyName: String
    let logoURL: String
    let currentPrice: Double
    let changeValue: Double
    let percentChange: Double
    let imageData: Data
    
    init(symbol: String, companyName: String, logoURL: String, currentPrice: Double, changeValue: Double, percentChange: Double, imageData: Data) {
        self.symbol = symbol
        self.companyName = companyName
        self.logoURL = logoURL
        self.currentPrice = currentPrice
        self.changeValue = changeValue
        self.percentChange = percentChange
        self.imageData = imageData
    }
    
}
