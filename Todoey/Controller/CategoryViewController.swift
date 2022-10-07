//
//  CategoryViewController.swift
//  Todoey
//
//  Created by I9orila T on 16.09.2022.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  //crud data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategory()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        //cell.textLabel?.font
     
        
        return cell
    }
    
    
    //MARK: - Data Manipulation Methods.
    //Save and load data (CRUD)
    func saveCategory() {
        do{
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        // Reload tableView after adding item
        self.tableView.reloadData()
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title:"Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            
            self.categories.append(newCategory)
            
            self.saveCategory()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            let commit = categories[indexPath.row]
            context.delete(commit)
            self.categories.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.saveCategory()
        }
    }
}
