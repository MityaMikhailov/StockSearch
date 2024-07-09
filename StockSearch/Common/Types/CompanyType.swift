//
//  CompanyType.swift
//  StockSearch
//
//  Created by Dmitriy Mikhailov on 09.07.2024.
//

import Foundation

class CompanyType {
    let symbol: String
    let companyName: String
    let logoURL: String
    
    init(symbol: String, companyName: String, logoURL: String) {
        self.symbol = symbol
        self.companyName = companyName
        self.logoURL = logoURL
    }
    
}
