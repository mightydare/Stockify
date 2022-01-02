//
//  Constants.swift
//  Stockify
//
//  Created by Darko Stojanov on 27.12.21.
//

import Foundation


struct API {
    struct Parametars {
        static let hostUrl =  "https://financialmodelingprep.com/api/v3/"
        static let apiKey = "d64d179adb2bcbf73edd76abd7e9e477"
        static let newsEndpoint = "stock_news?"
        static let stockScreener = "stock-screener"
    }
    
    struct ParametarKeys {
        static let marketCapMoreThanKey = "marketCapMoreThan"
        static let volumeMoreThanKey = "volumeMoreThan"
        static let sectorKey = "sector"
        static let exchangeKey = "exchange"
        static let limitKey = "limit"
        static let apiKey = "apikey"
        static let tickers = "tickers"
        static let limit = "limit"
    }
    struct ParametarValues {
        static let marketCapMoreThan = "1000000000"
        static let volumeMoreThan = "10000"
        static let sector = "Technology"
        static let exchange = "NASDAQ"
        static let limit = "100"
    }
    
    
}



