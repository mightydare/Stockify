//
//  StockNewsViewController.swift
//  Stockify
//
//  Created by Darko Stojanov on 1.1.22.
//

import UIKit

class StockNewsViewController: UIViewController {
    
    @IBOutlet var tableView : UITableView!
    
    lazy var viewModel = {
        StockNewsViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initViewModel()

    }
    
    func initView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorColor = .black
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = true
        tableView.register(StockNewsCell.nib, forCellReuseIdentifier: StockNewsCell.identifier)
    }
    
    func initViewModel() {
        viewModel.getStockNews()
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

}


extension StockNewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

// MARK: - UITableViewDataSource

extension StockNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.stockNews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockNewsCell.identifier, for: indexPath) as? StockNewsCell else { fatalError() }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.cellViewModel = cellVM
        return cell
    }
}
