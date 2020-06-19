//
//  ListahanVC.swift
//  Listahan Ko
//
//  Created by Jaypee Umandap on 6/18/20.
//  Copyright © 2020 Jervy Umandap. All rights reserved.
//

import UIKit

class ListahanVC: UITableViewController {
    
    // array of Dummy items
//    var itemArray = [
//        "Find Her",
//        "Cook Noodles",
//        "Play Pubgm",
//        "Sleep!"
//    ]
    
    
    var itemArray = [Item]()
    
    // replaced by custom plist
//    let defaults = UserDefaults.standard
    

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Listahan.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(dataFilePath)
        
        // hardcoded item in array
//        let newItem = Item()
//        newItem.title = "Find Her"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Find Cat"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Find natasha"
//        itemArray.append(newItem3)
        
        // userDefaults
//        if let items = defaults.array(forKey: "ListahanArray") as? [Item] {
//            itemArray = items
//        }
        
        // replaced the userDefaults method
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
        
        // for item in array to toggle true or false the done property when tapped/selected by user
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        print("\(itemArray[indexPath.row].title) - \(itemArray[indexPath.row].done)")
        
//        save to Listahan.plist
        saveItems()
        
        // to reload data in table when user tapped a cell
        // already inside the saveItem() method
//        tableView.reloadData()
        
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
            
            let newItem = Item()
            newItem.title = textField.text!
            
            //append the added item by user
//            self.itemArray.append(textField.text!)
            self.itemArray.append(newItem)
            
            // save to Listahan.plist
            self.saveItems()
            
            // delete for removal of custom plist
//            self.defaults.set(self.itemArray, forKey: "ListahanArray")
            
            
            // moved to saveItem() method
//            let encoder = PropertyListEncoder()
//
//            do {
//                let data = try encoder.encode(self.itemArray)
//                try data.write(to: self.dataFilePath!)
//            } catch {
//                print("Error encoding item array, \(error)")
//            }
//
//            // reload the data from array to screen
//            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type something here.."
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        // reload the data from array to screen
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
}

