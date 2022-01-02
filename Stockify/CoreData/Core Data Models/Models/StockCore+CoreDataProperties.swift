//
//  StockCore+CoreDataProperties.swift
//  Stockify
//
//  Created by Darko Stojanov on 29.12.21.
//
//

import Foundation
import CoreData


extension StockCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockCore> {
        return NSFetchRequest<StockCore>(entityName: "StockCore")
    }

    @NSManaged public var symbol: String?
    @NSManaged public var companyName: String?
    @NSManaged public var price: Double

}

extension StockCore : Identifiable {

}
