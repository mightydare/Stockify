//
//  StockNewsCell.swift
//  Stockify
//
//  Created by Darko Stojanov on 2.1.22.
//

import UIKit
import SDWebImage

class StockNewsCell: UITableViewCell {

    @IBOutlet var stockImage : UIImageView!
    @IBOutlet var stockTitle : UILabel!
    
    
    var cellViewModel : StockNewsCellViewModel? {
        didSet {
            stockTitle.text = cellViewModel?.title
            if let cellViewModelImage = cellViewModel?.image {
                stockImage?.sd_setImage(with: NSURL(string: cellViewModelImage) as URL?)
            } else {
                stockImage.sd_setImage(with: API.Images.defaultImage)
            }
           
        }
    }
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
       
    }
    
    
    
    
    func initView() {
        backgroundColor = .clear
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stockTitle.text = nil
        stockImage = nil
        
    }
    
}
