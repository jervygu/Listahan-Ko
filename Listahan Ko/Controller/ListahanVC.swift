//
//  ListahanVC.swift
//  Listahan Ko
//
//  Created by Jaypee Umandap on 6/18/20.
//  Copyright © 2020 Jervy Umandap. All rights reserved.
//

import UIKit
import RealmSwift

class ListahanVC: UITableViewController {
    
    var listahanItems : Results<Item>?
    let realm = try! Realm()
    
    //    for passing the category selected
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        if let safeSelectedCategory = selectedCategory {
            navigationItem.title = safeSelectedCategory.name
        }
        
        
    }
    
    
    //MARK: - TableView DataSource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listahanItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listahanCell", for: indexPath)
        
        if let item = listahanItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            // ternary operator, shorthand for above statements
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added."
        }
        
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // for edit
        //        itemArray[indexPath.row].setValue("Completed!", forKey: "title")
        
        
        // for item in array to toggle true or false the done property when tapped/selected by user
//        listahanItems[indexPath.row].done = !listahanItems[indexPath.row].done
        
        
        
        
//        print("\(String(describing: itemArray[indexPath.row].parentCategory!.name!)) - \(String(describing: itemArray[indexPath.row].title!)) - \(itemArray[indexPath.row].done)")
        
        // delete item
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        
        
//        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //            will happen once the user clicks Add item button on UIAlert
            print("Success adding item \(String(describing: textField.text!))")
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving context \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type new item here."
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
//    func saveItems() {
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context \(error)")
//        }
//
//        // reload the data from array to screen
//        tableView.reloadData()
//    }
    
    //  with - external ... request - internal param ... = Item.fetchRequest() - default value
    
    func loadItems() {
        
        listahanItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
}

//MARK: - Search Bar Methods / Delegate Methods

//extension ListahanVC: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        print(searchBar.text!)
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
//
//    }
//
//    // back to original state searchBar
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            DispatchQueue.main.async {
//                // go to original state before the searchBar activated
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//
//
//}
