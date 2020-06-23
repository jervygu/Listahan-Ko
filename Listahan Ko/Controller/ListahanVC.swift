//
//  ListahanVC.swift
//  Listahan Ko
//
//  Created by Jaypee Umandap on 6/18/20.
//  Copyright © 2020 Jervy Umandap. All rights reserved.
//

import UIKit
import CoreData

class ListahanVC: UITableViewController {
    
    var itemArray = [Item]()
    

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        searchBar.delegate = self
        
        loadItems()
        
        
    }
    
    
    //MARK: - TableView DataSource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listahanCell", for: indexPath)

        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // ternary operator, shorthand for above statements
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // for edit
//        itemArray[indexPath.row].setValue("Completed!", forKey: "title")
        
        
        // for item in array to toggle true or false the done property when tapped/selected by user
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        print("\(String(describing: itemArray[indexPath.row].title!)) - \(itemArray[indexPath.row].done)")
        
        
        // delete item
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
//            will happen once the user clicks Add item button on UIAlert
            print("Success!")
            print(textField.text!)
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type something here.."
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        // reload the data from array to screen
        self.tableView.reloadData()
    }
    
    
//  with - external ... request - internal param ... = Item.fetchRequest() - default value
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray =  try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
}

//MARK: - Search Bar Methods / Delegate Methods

extension ListahanVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // query items
        let request : NSFetchRequest<Item> = Item.fetchRequest()

        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = predicate

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        request.sortDescriptors = [sortDescriptor]

        loadItems(with: request)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                // go to original state before the searchBar activated
                searchBar.resignFirstResponder()
            }
        }
    }
    
}



