//
//  ViewController.swift
//  ToDoApp
//
//  Created by Tiana Nguyen on 9/30/17.
//  Copyright © 2017 Tiana Nguyen. All rights reserved.
//

import UIKit

// The class ViewController inherits from a UIViewController, UITableViewDataSource, and UITableViewDelegate
class ViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    // The table view from Main.storyboard. IBOutlet is linked to the storyboard 
    @IBOutlet weak var tableView: UITableView!
    
    // Storing description and whether task is completed or not to the To Do List App
    struct toDoItem {
        var title: String
        var done: Bool
    }
    
    // The array of items that make the todo list
    var todoData: [toDoItem] = []
    
    // Make layout and setup from viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad() // Setup for UIViewController
        
        // Link the tableView to class
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Function calls didSelectRow when the user taps on a table row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Deselect the row
        
        if indexPath.row < todoData.count { //If the row represents valid data
            todoData[indexPath.row].done = !todoData[indexPath.row].done
            
            tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: .fade) // Update the view
        }
    }
    
    // Layout the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a variable representing a cell in your table
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        
        //If valid, get the item in array of tasks and set the label to represent the item
        if indexPath.row < todoData.count {
            let item = todoData[indexPath.row]
            cell.textLabel?.text = item.title
            
            // If task is complete, set accessory to a check mark
            if item.done {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        return cell // Return the cell
    }
    
    // we only want 1 section in this tableView, but there can be more
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // the number of rows in our table is the number of items in our array of todos
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        return todoData.count
    }
    
    // set if the table cells can be edittied, in this case if they can be removed or not
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Function to delete rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //If editing stylde is deleting, begin updating tableView, remove item from array, delete row in table, and stop updating tableView
        if editingStyle == .delete {
            tableView.beginUpdates()
            todoData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
            tableView.endUpdates()
        }
    }
    
    
    // Add an item to the todo list
    @IBAction func addItem(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "Add Item", message: "Add an item to your To-Do list", preferredStyle: .alert) // Create a view for a pop-up
        
        // Add a text field to read in the task
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "Item to add"
        }
        
        // Create action to cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (action) in
        }
        
        alert.addAction(cancelAction) // Add the action to the alert
        
        // Create a confirmation action and handle adding something to the table
        let confirmAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) { (action) in
            let itemField = alert.textFields![0] as UITextField // get the textfield we added to the alert
            // If the alert has text, create a toDoItem with task, start updating the tableView, add item to the list, insert new item in the table, and stop updating the tableView
            if itemField.text != "" {
                let itemToAdd = toDoItem(title: itemField.text!, done: false)
                self.tableView.beginUpdates()
                self.todoData.append(itemToAdd)
                
                self.tableView.insertRows(at: [IndexPath(row: self.todoData.count-1, section: 0)], with: .top)
                self.tableView.endUpdates()
            }
        }
        
        alert.addAction(confirmAction) // Add action to the alert
        
        self.present(alert, animated: true, completion: nil) // Present the alert to the user
    }
    
    
    // Used to handle memory issues
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


