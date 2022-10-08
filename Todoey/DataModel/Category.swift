//
//  Category.swift
//  Todoey
//
//  Created by I9orila T on 07.10.2022.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
     
}
