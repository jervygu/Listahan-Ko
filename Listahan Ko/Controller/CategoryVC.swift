//
//  CategoryVC.swift
//  Listahan Ko
//
//  Created by Jaypee Umandap on 6/24/20.
//  Copyright © 2020 Jervy Umandap. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryVC: UITableViewController {
    
    // Results<> is collection type
    var listahanCategories : Results<Category>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
        
    }
    
    //MARK: - TableView DataSource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Nil coalescing operator
        // if != nil return count, if == nil return 1
        return listahanCategories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = listahanCategories?[indexPath.row].name ?? "No Categories added yet"
        
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            //            will happen once the user clicks Add item button on UIAlert
            print("Success adding category \(String(describing: textField.text!))")
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type new category here."
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ListahanVC
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = listahanCategories?[indexPath.row] 
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    //  with - external ... request - internal param ... = Item.fetchRequest() - default value
    
    func loadCategories() {
        listahanCategories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
}
