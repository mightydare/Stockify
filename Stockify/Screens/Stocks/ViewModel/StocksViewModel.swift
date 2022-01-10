//
//  StocksViewModel.swift
//  Stockify
//
//  Created by Darko Stojanov on 27.12.21.
//

import Foundation
import CoreData
import UIKit


class StocksViewModel : NSObject {
    private var stocksService : StocksServicesProtocol
    
    var reloadTableView: (() -> Void)?
    
    var stocks = Stocks()
    var filteredStocks = Stocks()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    
    init(stockService: StocksServicesProtocol = ApiService()) {
        self.stocksService = stockService
    }
    
    func getStocks() {
        stocksService.getStocks { success, model, error in
            if success , let stocks = model  {
                self.fetchData(stocks: stocks)
            } else {
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    var stockCellViewModel = [StocksCellViewModel]() {
           didSet {
               reloadTableView?()
           }
       }
    
    func saveStockInCore(_ stocksCell : StocksCell) {
        let entity = NSEntityDescription.entity(forEntityName: "StockCore", in: context)
        let stock = NSManagedObject(entity: entity!, insertInto: context)
        stock.setValue(stocksCell.companyNameLabel.text, forKey: "companyName")
        stock.setValue(stocksCell.symbolLabel.text, forKey: "symbol")
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
        
    }
    
    func fetchData(stocks: Stocks) {
           self.stocks = stocks // Cache
           var vms = [StocksCellViewModel]()
           for stock in stocks {
               vms.append(createCellModel(stock: stock))
           }
            stockCellViewModel = vms
       }
    
    func createCellModel(stock: Stock) -> StocksCellViewModel {
           let symbol = stock.symbol
           let companyName = stock.companyName
           let price = "$ \(stock.price)"
           let marketCap = stock.marketCap
           let country = stock.country
           
        return StocksCellViewModel(symbol: symbol, companyName: companyName, price: price, marketCap: marketCap)
       }
    
    func sort(stocks : Stocks , filterType : String? = nil , filterCountry : [String]? = nil) {
        var sortedStocks = Stocks()
        if filterType == "Alphabetical" {
             sortedStocks = stocks.sorted { $0.symbol < $1.symbol}
        } else if filterType == "Market" {
             sortedStocks = stocks.sorted { $0.marketCap < $1.marketCap}
        }
        else if filterCountry != nil {
            var countryFilteredStocks = Stocks()
            filterCountry?.forEach({ countryFilter in
                stocks.forEach { stockCountry in
                    if stockCountry.country.contains(countryFilter) {
                        countryFilteredStocks.append(stockCountry)
                    }
                }
            })
            sortedStocks = countryFilteredStocks
        }
        self.stocks = sortedStocks
        var vms = [StocksCellViewModel]()
        for stock in self.stocks {
            vms.append(createCellModel(stock: stock))
        }
        stockCellViewModel = vms
        self.reloadTableView?()
 
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> StocksCellViewModel {
            return stockCellViewModel[indexPath.row]
        }
    
    func filterStocks (_ searchText : String) {
        
        if searchText.isEmpty == false {
            filteredStocks = stocks.filter({ stock in
                stock.companyName.lowercased().contains(searchText.lowercased()) })
        }
        stocks = filteredStocks
        var vms = [StocksCellViewModel]()
        for stock in stocks {
            vms.append(createCellModel(stock: stock))
        }
        stockCellViewModel = vms
        reloadTableView?()
        
    }
    
    
    func deleteCellAt(_ indexPath: IndexPath , _ editingStyle : UITableViewCell.EditingStyle , tableView : UITableView) {
        if editingStyle == .delete {
            let commit = stocks[indexPath.row]
            stocks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
    }
    
    
}
