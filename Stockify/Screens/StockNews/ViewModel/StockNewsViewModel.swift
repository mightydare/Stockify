//
//  StockNewsViewModel.swift
//  Stockify
//
//  Created by Darko Stojanov on 2.1.22.
//

import Foundation
import CoreData
import UIKit

class StockNewsViewModel : NSObject {
    
    private var stocksService : StocksServicesProtocol

    var reloadTableView: (() -> Void)?

    var stockNews = SotcksNews()
    var stockSymbol : String?

    init(stockService: StocksServicesProtocol = ApiService()) {
        self.stocksService = stockService
        stockSymbol = "SPWH"
    }

    func getStockNews() {
        stocksService.getStockNews(stockSymbol!) { success, model, error in
            if success , let stocks = model  {
                self.fetchData(stocks: stocks)
    
            } else {
                if let error = error {
                    print(error)
                }
            }
        }
    }

    var stockNewsCellViewModel = [StockNewsCellViewModel]() {
           didSet {
               reloadTableView?()
           }
       }

    func fetchData(stocks: SotcksNews) {
           self.stockNews = stocks // Cache
           var vms = [StockNewsCellViewModel]()
           for stock in stockNews {
               vms.append(createCellModel(stock: stock))
           }
            stockNewsCellViewModel = vms
       }

    func createCellModel(stock: StockNews) -> StockNewsCellViewModel {
            let title = stock.title
            let image = stock.image

           return StockNewsCellViewModel(title: title, image: image)
       }

    func getCellViewModel(at indexPath: IndexPath) -> StockNewsCellViewModel {
            return stockNewsCellViewModel[indexPath.row]
        }
}
