//
//  MyStocksViewModel.swift
//  Stockify
//
//  Created by Darko Stojanov on 29.12.21.
//

import Foundation
import CoreData
import UIKit


class MyStocksViewModel : NSObject, NSFetchedResultsControllerDelegate {
    
    var reloadTableView: (() -> Void)?
    
    var stocks = Stocks()
    
    var moc:NSManagedObjectContext!

    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    private let persistentContainer = NSPersistentContainer(name: "MyStocksDataModel")
    
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<StockCore> = {

        let fetchRequest: NSFetchRequest<StockCore> = StockCore.fetchRequest()

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "symbol", ascending: true)]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
    

    var stockCellViewModel = [StocksCellViewModel]() {
           didSet {
               reloadTableView?()
           }
       }
    
    func getMyStocks() {
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
                if let error = error {
                    print("Unable to Load Persistent Store")
                    print("\(error), \(error.localizedDescription)")

                } else {

                    do {
                        try self.fetchedResultsController.performFetch()
                    } catch {
                        let fetchError = error as NSError
                        print("Unable to Perform Fetch Request")
                        print("\(fetchError), \(fetchError.localizedDescription)")
                    }
                }
            }
        guard var coreStocks = fetchedResultsController.fetchedObjects else { return }
//        stocks.forEach { stock in
//            let listItemList = coreStocks.flatMap({Stock(})
//            stocks.append(listItemList)
//        }
        
        self.fetchData(stocks: stocks)
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
        return StocksCellViewModel(symbol: symbol, companyName: companyName, price: price, marketCap: marketCap)
       }
    
    func getCellViewModel(at indexPath: IndexPath) -> StocksCellViewModel {
            return stockCellViewModel[indexPath.row]
        }
    
//    func deleteCellAt(_ indexPath: IndexPath , _ editingStyle : UITableViewCell.EditingStyle , tableView : UITableView) {
//        if editingStyle == .delete {
//            let commit = stocks[indexPath.row]
//            stocks.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//
//        }
//    }
    
}
