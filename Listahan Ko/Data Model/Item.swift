//
//  Item.swift
//  Listahan Ko
//
//  Created by Jaypee Umandap on 6/25/20.
//  Copyright © 2020 Jervy Umandap. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    // linking the category type to items
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
