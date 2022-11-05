//
//  Item.swift
//  Todoey
//
//  Created by I9orila T on 07.10.2022.
//

import Foundation
import RealmSwift
class Item: Object {
   @objc dynamic var title: String = ""
   @objc dynamic var done: Bool = false
   @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
