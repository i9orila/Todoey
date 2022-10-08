//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by I9orila T on 15.08.2022.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    let realm = try! Realm()
    var toDoItems: Results<Item>?
    
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(dataFilePath)
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    
    //MARK: - Tableview Datasorse Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            // Ternary operator ==>
            // value = condition ? valueTrue : valueFalse
            //item.done ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    //MARK: - Add new items
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title:"Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write() {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error savingnew items,\(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - Model Manipulation Method
    
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //        toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done
        //
        //        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        //    }
        //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //        if editingStyle == .delete {
        //            print("Deleted")
        //            let commit = toDoItems[indexPath.row]
        //            context.delete(commit)
        //            self.toDoItems.remove(at: indexPath.row)
        //            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        //            self.saveItems()
    }
}



