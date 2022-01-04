//
//  File.swift
//  Stockify
//
//  Created by Darko Stojanov on 1.1.22.
//

import Foundation


// MARK: -


struct StockNews: Codable {
    let publishedDate : String
    let title : String
    let symbol: String
    let image: String
    let site : String
    let text: String
    let url: String
}

typealias SotcksNews = [StockNews]
