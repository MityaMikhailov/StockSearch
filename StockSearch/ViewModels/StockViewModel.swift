//
//  StockViewModel.swift
//  StockSearch
//
//  Created by Dmitriy Mikhailov on 09.07.2024.
//

import Foundation

class StockViewModel {
    
    private let baseURL = "https://finnhub.io/api/v1"
    private let apiKey = "cq0hvkhr01qkg1bespegcq0hvkhr01qkg1bespf0"
    
    private var listOfSymbols: StockSymbolsModel! {
        didSet {
            fetchCompanies()
        }
    }
    
    private var listOfCompanies: [CompanyType]! {
        didSet {
            printCompanies()
        }
    }
    
    private var listOfCompaniesQote: [CompanyWithQoute]! {
        didSet {
            printQoute()
        }
    }
    
    var listOfFullCompanies = Dynamic([FullCompanyInfo]()) {
        didSet {
            printFullCompanies()
        }
    }
    
    var loadStatus = Dynamic("")
    
    func fetchSymbols() {
        let networkManager = NetworkManager<StockSymbolsModel>(baseURL: baseURL,
                                            apiKey: apiKey,
                                            endPoint: "/stock/symbol",
                                            parametrs: ["exchange": "US",
                                                        "token": apiKey])
        
        networkManager.fetchData { [weak self] response in
            switch response {
            case .success(let success):
                self?.listOfSymbols = success
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func fetchCompanies() {
        print("Begin")
        let endIndex = 100
        let dispatchGroup = DispatchGroup()
        let dispatchGroupTwo = DispatchGroup()
        let dispatchGroupThree = DispatchGroup()
        
//        let endIndex = listOfSymbols.count - 1
        
        DispatchQueue.global().async { [weak self] in
            var arrayOfCompanies = [CompanyType]()
            var arrayOfQoute = [CompanyWithQoute]()
            var arrayOfFullCompanies = [FullCompanyInfo]()
            for i in 0...endIndex {
                
                if i % 30 == 0 && i != 0 {
                    let percentage = Double(i) / Double(endIndex) * 100
                    DispatchQueue.main.async {
                        self?.loadStatus.value = String(format: "Загрузка компаний %.1f%%", percentage)
                    }
                    sleep(1)
                }
                
                guard let symbol = self?.listOfSymbols[i].symbol else { return }
                
                let networkManager = NetworkManager<CompanyInfoModel>(baseURL: self?.baseURL ?? "",
                                                                       apiKey: self?.apiKey ?? "",
                                                                       endPoint: "/stock/profile2",
                                                                       parametrs: ["symbol": symbol,
                                                                                   "token": self?.apiKey ?? ""])
                
                dispatchGroup.enter()
                networkManager.fetchData { response in
                    defer {
                        dispatchGroup.leave()
                    }
                    switch response {
                    case .success(let companyInfo):
                        let infoOfCompany = companyInfo
                        guard let companyName = infoOfCompany.name,
                              let logoURL = infoOfCompany.logo else { return }
                        
                        
                        
                        let networkManagerTwo = NetworkManager<QuoteModel>(baseURL: self?.baseURL ?? "",
                                                                           apiKey: self?.apiKey ?? "",
                                                                           endPoint: "/quote",
                                                                           parametrs: ["symbol": symbol,
                                                                                       "token": self?.apiKey ?? ""])
                        dispatchGroupTwo.enter()
                        networkManagerTwo.fetchData { response in
                            defer {
                                dispatchGroupTwo.leave()
                            }
                            switch response {
                            case .success(let qoute):
                                let qouteCompany = qoute
                                
                                guard let currentPrice = qouteCompany.c,
                                      let changeValue = qouteCompany.d,
                                      let percentChange = qouteCompany.dp else { return }
                                
                                let companyWithQoute = CompanyWithQoute(symbol: symbol, companyName: companyName, logoURL: logoURL, currentPrice: currentPrice, changeValue: changeValue, percentChange: percentChange)
                                arrayOfQoute.append(companyWithQoute)
                                
                                let networkManagerForImages = NetworkManager<QuoteModel>(baseURL: self?.baseURL ?? "",
                                                                                         apiKey: self?.apiKey ?? "",
                                                                                         endPoint: "/quote",
                                                                                         parametrs: ["symbol": symbol,
                                                                                                     "token": self?.apiKey ?? ""])
                                
                                dispatchGroupThree.enter()
                                networkManagerForImages.loadImage(from: logoURL) { imageData in
                                    
                                    defer {
                                        dispatchGroupThree.leave()
                                    }
                                    guard let image = imageData else { return }
                                    let fullcompany = FullCompanyInfo(symbol: symbol, companyName: companyName, logoURL: logoURL, currentPrice: currentPrice, changeValue: changeValue, percentChange: percentChange, imageData: image)
                                    arrayOfFullCompanies.append(fullcompany)
                                    
                                }
                                
                            case .failure(let failure):
                                print(failure.localizedDescription)
                            }
                        }
                        //здесь нужно чекать прайс компании и внутри прайса скачивать картинку
                        
                        let company = CompanyType(symbol: symbol, companyName: companyName, logoURL: logoURL)
                        arrayOfCompanies.append(company)
                        
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
                

            }
            
            dispatchGroup.notify(queue: .global()) {
                DispatchQueue.main.async {
                    self?.listOfCompanies = arrayOfCompanies
                }
            }
            
            dispatchGroupTwo.notify(queue: .global()) {
                DispatchQueue.main.async {
                    self?.listOfCompaniesQote = arrayOfQoute
                }
            }
            
            dispatchGroupThree.notify(queue: .global()) {
                DispatchQueue.main.async {
                    self?.listOfFullCompanies.value = arrayOfFullCompanies
                }
            }
            
        }
    }
    
    private func printCompanies() {
        
        print("Количество компаний",listOfCompanies.count)
    }
    
    private func printQoute() {
        print("Количество компаний с ценами",listOfCompaniesQote.count)
    }
    
    private func printFullCompanies() {
        print("Количество полных компаний",listOfFullCompanies.value.count)
    }
    
}
