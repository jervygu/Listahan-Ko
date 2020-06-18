//
//  ListahanVC.swift
//  Listahan Ko
//
//  Created by Jaypee Umandap on 6/18/20.
//  Copyright © 2020 Jervy Umandap. All rights reserved.
//

import UIKit

class ListahanVC: UITableViewController {
    
    
    let itemArray = [
        "Find Her",
        "Cook Noodles",
        "Play Pubgm",
        "Sleep!"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Listahan"
        
    }
    
    
    
    //MARK: - TableView DataSource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listahanCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
    
    
    
}

