//
//  CompanyInfoModel.swift
//  StockSearch
//
//  Created by Dmitriy Mikhailov on 09.07.2024.
//

import Foundation

// MARK: - CompanyInfoModel
struct CompanyInfoModel: Codable {
    let country, currency, estimateCurrency, exchange: String?
    let finnhubIndustry, ipo: String?
    let logo: String?
    let marketCapitalization: Double?
    let name, phone: String?
    let shareOutstanding: Double?
    let ticker: String?
    let weburl: String?
}
