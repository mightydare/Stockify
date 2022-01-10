//
//  ViewController.swift
//  Stockify
//
//  Created by Darko Stojanov on 27.12.21.
//

import UIKit

class StocksViewController: UIViewController {
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet var searchBar : UISearchBar!
    @IBOutlet var btnSort : UIButton!
    
    lazy var viewModel = {
        StocksViewModel()
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
            searchBar.delegate = self
        }
    
    func initViewModel() {
        viewModel.getStocks()
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
        }
    }
    @IBAction func sort(_ sender: UIButton) {
        viewModel.sort(stocks: viewModel.stocks)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}


extension StocksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

// MARK: - UITableViewDataSource

extension StocksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.filteredStocks.count != 0 {
            return viewModel.filteredStocks.count
        } else {
            return viewModel.stocks.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StocksCell.identifier, for: indexPath) as? StocksCell else { fatalError() }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView:UITableView , didSelectRowAt indexPath:IndexPath) {
        let cellSelected = tableView.cellForRow(at: indexPath) as? StocksCell
        let stockNewsVC = StockNewsViewController()
        stockNewsVC.viewModel.stockSymbol = cellSelected?.symbolLabel.text
        self.navigationController?.pushViewController(stockNewsVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.deleteCellAt(indexPath , editingStyle, tableView: tableView)
    }
}


extension StocksViewController : UISearchBarDelegate {
        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            viewModel.filterStocks(searchText)
        }
        tableView.reloadData()
    }
    
}


extension StocksViewController : StocksDelegate {
    func stocksTableViewCell(_ stocksCell: StocksCell, addToCoreButtonTappedFor stock: String) {
        viewModel.saveStockInCore(stocksCell)
    }
}
