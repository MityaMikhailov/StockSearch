//
//  QuoteModel.swift
//  StockSearch
//
//  Created by Dmitriy Mikhailov on 09.07.2024.
//

import Foundation

// MARK: - QuoteModel
struct QuoteModel: Codable {
    let c, d, dp, h: Double?
    let l, o, pc: Double?
    let t: Int?
}
