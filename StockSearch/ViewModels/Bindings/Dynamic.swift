//
//  Dynamic.swift
//  StockSearch
//
//  Created by Dmitriy Mikhailov on 09.07.2024.
//

import Foundation

class Dynamic<T> {
    
    private var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    
}

extension Dynamic {
    typealias Listener = (T) -> Void
}
