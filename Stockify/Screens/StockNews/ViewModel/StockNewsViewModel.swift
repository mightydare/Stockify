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
    
    var stocks = StocksNews()
    
    init(stockService: StocksServicesProtocol = ApiService()) {
        self.stocksService = stockService
    }
    
//    func getStocks() {
//        stocksService.getStocks { success, model, error in
//            if success , let stocks = model  {
//                self.fetchData(stocks: stocks)
//            } else {
//                if let error = error {
//                    print(error)
//                }
//            }
//        }
//    }
    
    var stockNewsCellViewModel = [stockNewsCellViewModel]() {
           didSet {
               reloadTableView?()
           }
       }
    
//    func fetchData(stocks: StockNews) {
//           self.stocks = stocks // Cache
//           var vms = [StocksCellViewModel]()
//           for stock in stocks {
//               vms.append(createCellModel(stock: stock))
//           }
//            stockCellViewModel = vms
//       }
    
    func createCellModel(stock: StockNews) -> StockNewsCellViewModel {
            let title = stock.title
            let image = stock.image
           
           return StockNewsCellViewModel(title: title, image: image)
       }
    
    func getCellViewModel(at indexPath: IndexPath) -> StocksCellViewModel {
            return stockNewsCellViewModel[indexPath.row]
        }
    
}
