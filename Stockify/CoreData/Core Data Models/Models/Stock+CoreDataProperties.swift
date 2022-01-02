//
//  Stock+CoreDataProperties.swift
//  Stockify
//
//  Created by Darko Stojanov on 29.12.21.
//
//

import Foundation
import CoreData


extension Stock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stock> {
        return NSFetchRequest<Stock>(entityName: "Stock")
    }

    @NSManaged public var symbol: String?
    @NSManaged public var companyName: String?
    @NSManaged public var price: Double

}

extension Stock : Identifiable {

}
