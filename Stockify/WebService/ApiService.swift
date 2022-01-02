//
//  ApiService.swift
//  Stockify
//
//  Created by Darko Stojanov on 27.12.21.
//

import Foundation

protocol StocksServicesProtocol {
    func getStocks(completion: @escaping (_ success: Bool, _ results: Stocks?, _ error: String?) -> ())
    func getNewsForStock(_ stockSymbol : String ,completion: @escaping (_ success: Bool, _ results: StockNews?, _ error: String?) -> ())
}



class ApiService : StocksServicesProtocol {
    
    func getStocks(completion: @escaping (Bool, Stocks?, String?) -> ()) {

        
        let params = [API.ParametarKeys.marketCapMoreThanKey : "1000000000",
                      API.ParametarKeys.volumeMoreThanKey : "10000",
                      API.ParametarKeys.sectorKey : "Technology" ,
                      API.ParametarKeys.exchangeKey: "NASDAQ",
                      API.ParametarKeys.limitKey : "100" ,
                      API.ParametarKeys.apiKey : API.Parametars.apiKey
        ]
        
        let stocksUrl = API.Parametars.hostUrl + API.Parametars.stockScreener
        HttpRequestHelper().GET(url: stocksUrl, params: params) { success, data in
            if success {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(Stocks.self, from: data!)
                    DispatchQueue.main.async {
                        completion(true , model , nil)
                    }
                }
                catch let error {
                    completion(false, nil, "Error: Trying to parse Stocks to model \(error.localizedDescription)")
                }
            }
            else {
                completion(false, nil, "Error in GET Request")
            }
        }
    }
    
    func getNewsForStock( _ stockSymbol : String , completion: @escaping (Bool, StockNews?, String?) -> ()) {
        let params = [API.ParametarKeys.tickers : stockSymbol,
                      API.ParametarKeys.limit : "1000",
                      API.ParametarKeys.apiKey : API.Parametars.apiKey
        ]
        
        let stocksUrl = API.Parametars.hostUrl + API.Parametars.newsEndpoint
        
        HttpRequestHelper().GET(url: stocksUrl, params: params) { success, data in
            if success {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(StockNews.self, from: data!)
                    DispatchQueue.main.async {
                        completion(true , model , nil)
                    }
                }
                catch let error {
                    completion(false, nil, "Error: Trying to parse StockNews to model \(error.localizedDescription)")
                }
            }
            else {
                completion(false, nil, "Error in GET Request")
            }
        }
    }
   
}
