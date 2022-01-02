//
//  StocksCell.swift
//  Stockify
//
//  Created by Darko Stojanov on 27.12.21.
//

import UIKit

protocol StocksDelegate: AnyObject {
  func stocksTableViewCell(_ stocksCell: StocksCell, addToCoreButtonTappedFor stock: String)
}

class StocksCell: UITableViewCell {
    @IBOutlet var symbolLabel : UILabel!
    @IBOutlet var companyNameLabel : UILabel!
    @IBOutlet var priceLabel : UILabel!
    @IBOutlet var btnAddToMyList : UIButton!
    weak var delegate: StocksDelegate?
    
    var cellViewModel : StocksCellViewModel? {
        didSet {
            symbolLabel.text = cellViewModel?.symbol
            companyNameLabel.text = cellViewModel?.companyName
            priceLabel.text = cellViewModel?.price
        }
    }
    
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
        self.btnAddToMyList.addTarget(self, action: #selector(addStock(_:)), for: .touchUpInside)
    }
    
    
    func initView() {
        backgroundColor = .clear
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = nil
        companyNameLabel.text = nil
        priceLabel.text = nil
        
    }
    
    @IBAction func addStock(_ sender: UIButton) {
        
        if let symbol = symbolLabel.text , let delegate = delegate {
                self.delegate?.stocksTableViewCell(self, addToCoreButtonTappedFor: symbol)
            }
    }
    
   
    
}
