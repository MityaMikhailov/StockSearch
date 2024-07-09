//
//  UserDefaultManager.swift
//  StockSearch
//
//  Created by Dmitriy Mikhailov on 09.07.2024.
//

import Foundation

class UserDefaultManager {
    
    func loadFullCompanyInfo() -> [FullCompanyInfo]? {
        if let savedData = UserDefaults.standard.data(forKey: "fullCompanyInfo") {
            let decoder = JSONDecoder()
            if let loadedResults = try? decoder.decode([FullCompanyInfo].self, from: savedData) {
                return loadedResults
            }
        }
        return nil
    }
    
    func addFullCompanyInfo(_ info: FullCompanyInfo) {
        var results = loadFullCompanyInfo() ?? []
        results.append(info)
        saveFullCompanyInfo(results)
    }
    
    func saveFullCompanyInfo(_ results: [FullCompanyInfo]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(results) {
            UserDefaults.standard.set(encoded, forKey: "fullCompanyInfo")
        }
    }
    
    func removeFullCompanyInfo(symbol: String) {
            var results = loadFullCompanyInfo() ?? []
            if let index = results.firstIndex(where: { $0.symbol == symbol }) {
                results.remove(at: index)
                saveFullCompanyInfo(results)
            }
        }
    
    func printUserDefaults() {
        let defaultsDict = UserDefaults.standard.dictionaryRepresentation()
        if !defaultsDict.isEmpty {
            print("Содержимое UserDefaults:")
            for (key, value) in defaultsDict {
                print("\(key): \(value)")
            }
        } else {
            print("UserDefaults пуст или не удалось получить данные.")
        }
    }
}

