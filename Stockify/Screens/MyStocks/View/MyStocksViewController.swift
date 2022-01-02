//
//  MyStocksViewController.swift
//  Stockify
//
//  Created by Darko Stojanov on 29.12.21.
//

import UIKit
import CoreData

class MyStocksViewController: UIViewController {
    
    @IBOutlet var tableView : UITableView!
    
    var moc:NSManagedObjectContext!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var viewModel = {
        MyStocksViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()
        
    }
    
    func initView() {
            //Customize TableView
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = .white
            tableView.separatorColor = .black
            tableView.separatorStyle = .singleLine
            tableView.tableFooterView = UIView()
            tableView.allowsSelection = true
            tableView.register(StocksCell.nib, forCellReuseIdentifier: StocksCell.identifier)
        }
    
    func initViewModel() {
        viewModel.getMyStocks()
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }

        }
    }
    
}


extension MyStocksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

// MARK: - UITableViewDataSource

extension MyStocksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.stocks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StocksCell.identifier, for: indexPath) as? StocksCell else { fatalError() }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        cell.btnAddToMyList.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.deleteCellAt(indexPath , editingStyle, tableView: tableView)
    }
}

extension  MyStocksViewController : NSFetchedResultsControllerDelegate {}


