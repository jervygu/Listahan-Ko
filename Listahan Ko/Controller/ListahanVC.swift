//
//  ListahanVC.swift
//  Listahan Ko
//
//  Created by Jaypee Umandap on 6/18/20.
//  Copyright © 2020 Jervy Umandap. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ListahanVC: SwipeTableVC {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard let hexColour = selectedCategory?.categoryColour else {fatalError()}
        updateNavBar(withHexCode: hexColour)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK: - nav Bar setup code methods
    
    func updateNavBar(withHexCode hexColour: String) {
        guard let navbar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist.")
        }
        
        guard let navBarColour = UIColor(hexString: hexColour) else { fatalError() }
        navbar.barTintColor = navBarColour
        navbar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        searchBar.barTintColor = navBarColour
        
    }
    
    
    //MARK: - TableView DataSource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listahanItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = listahanItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            // currently on row 5
            // theres a total of 10 times in listahanItems
            let selectedColor = selectedCategory?.categoryColour
            
            // optional chaining
            if let colour = UIColor(hexString: selectedColor!)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(listahanItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
                 
            // value = condition ? valueIfTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added."
        }
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //////////////////////////////////////////////////////////////////////
        // delete item using realm,
        
        //        if let item = listahanItems?[indexPath.row] {
        //            do {
        //                try realm.write {
        //                    realm.delete(item)
        //                }
        //            } catch {
        //                print("Error saving done status \(error)")
        //            }
        //        }
        
        //////////////////////////////////////////////////////////////////////
        
        
        // Update done or not done using realm
        
        // toggle item.done true or false
        if let item = listahanItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        
        // for item in array to toggle true or false the done property when tapped/selected by user
        //        listahanItems[indexPath.row].done = !listahanItems[indexPath.row].done
        
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
                        //newItem.done doesnt need to specify anymore because it has already have default Bool value
                        newItem.dateCreated = Date()
                        
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
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    //  with - external ... request - internal param ... = Item.fetchRequest() - default value
    
    func loadItems() {
        listahanItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        // update model
        
        if let itemForDeletion = listahanItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
    
}

//MARK: - Search Bar Methods / Delegate Methods

extension ListahanVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // filter items and sort it in date of creation
        listahanItems = listahanItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
        
    }
    
    // back to original state searchBar
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
