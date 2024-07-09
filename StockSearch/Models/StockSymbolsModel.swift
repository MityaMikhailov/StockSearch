//
//  StockSymbolsModel.swift
//  StockSearch
//
//  Created by Dmitriy Mikhailov on 09.07.2024.
//

import Foundation

// MARK: - StockSymbolsModelElement
struct StockSymbolsModelElement: Codable {
    let currency: Currency?
    let description, displaySymbol, figi: String?
    let isin: JSONNull?
    let mic: Mic?
    let shareClassFIGI, symbol, symbol2: String?
    let type: TypeEnum?
}

enum Currency: String, Codable {
    case empty = ""
    case usd = "USD"
}

enum Mic: String, Codable {
    case arcx = "ARCX"
    case bats = "BATS"
    case iexg = "IEXG"
    case ootc = "OOTC"
    case xase = "XASE"
    case xnas = "XNAS"
    case xnys = "XNYS"
}

enum TypeEnum: String, Codable {
    case adr = "ADR"
    case cdi = "CDI"
    case closedEndFund = "Closed-End Fund"
    case commonStock = "Common Stock"
    case dutchCERT = "Dutch Cert"
    case empty = ""
    case equityWRT = "Equity WRT"
    case etp = "ETP"
    case foreignSh = "Foreign Sh."
    case gdr = "GDR"
    case ltdPart = "Ltd Part"
    case misc = "Misc."
    case mlp = "MLP"
    case nvdr = "NVDR"
    case nyRegShrs = "NY Reg Shrs"
    case openEndFund = "Open-End Fund"
    case preference = "Preference"
    case privateEquityBacked = "Private-equity backed"
    case receipt = "Receipt"
    case reit = "REIT"
    case royaltyTrst = "Royalty Trst"
    case savingsShare = "Savings Share"
    case sdr = "SDR"
    case stapledSecurity = "Stapled Security"
    case trackingStk = "Tracking Stk"
    case typePRIVATE = "PRIVATE"
    case typePUBLIC = "PUBLIC"
    case typeRight = "Right"
    case unit = "Unit"
}

typealias StockSymbolsModel = [StockSymbolsModelElement]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}


