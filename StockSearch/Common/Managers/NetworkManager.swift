//
//  NetworkManager.swift
//  StockSearch
//
//  Created by Dmitriy Mikhailov on 09.07.2024.
//

import Foundation
import Alamofire

class NetworkManager<T: Decodable> {
    
    private let baseURL: String
    private  let apiKey: String
    private let endpoint: String
    private let parameters: [String: String]
    
    init(baseURL: String, apiKey: String, endPoint: String, parametrs: [String : String]) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.endpoint = endPoint
        self.parameters = parametrs
    }
    
    func fetchData(completion: @escaping (Result<T,Error>) -> Void) {
        
        let fullPath = baseURL + endpoint
        
        AF.request(fullPath, parameters: parameters).responseDecodable(of: T.self) { response in
            switch response.result {
                case .success(let success):
                    completion(.success(success))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func loadImage(from url: String, completion: @escaping (Data?) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("Error loading image: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
