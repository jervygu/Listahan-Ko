//
//  Category.swift
//  Listahan Ko
//
//  Created by Jaypee Umandap on 6/25/20.
//  Copyright © 2020 Jervy Umandap. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    // items is the array of item
    let items = List<Item>()
}
