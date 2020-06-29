//
//  CategoryVC.swift
//  Listahan Ko
//
//  Created by Jaypee Umandap on 6/24/20.
//  Copyright © 2020 Jervy Umandap. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryVC: SwipeTableVC {
    
    // Results<> is collection type
    var listahanCategories : Results<Category>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategories()
//        tableView.separatorStyle = .none
        
    }
    
    //MARK: - TableView DataSource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Nil coalescing operator
        // if != nil return count, if == nil return 1
        return listahanCategories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = super.tableView(tableView, cellForRowAt: indexPath)
        
        let category = listahanCategories?[indexPath.row]
        
        let selectedColor = category?.categoryColour  ?? "1D9BF6"
        
        cell.textLabel?.text = category?.name ?? "No Categories added yet"
        
        cell.backgroundColor = UIColor(hexString: selectedColor)

        // optional chaining
        if let colour = UIColor(hexString: selectedColor){
            cell.backgroundColor = colour
            cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
        }
        
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
            newCategory.categoryColour = UIColor.randomFlat().hexValue()
            
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type new category here."
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
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
    
    //MARK: - delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        // update model

        if let categoryForDeletion = self.listahanCategories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting catogory, \(error)")
            }
        }
    }
}
