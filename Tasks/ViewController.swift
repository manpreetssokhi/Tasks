//
//  ViewController.swift
//  Tasks
//
//  Created by Manpreet Sokhi on 8/26/20.
//  Copyright © 2020 Manpreet Sokhi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var tasks = [String]() // will hold all the tasks the user inputs

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Tasks"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup
        
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }
        
        // Get all current saved tasks
        updateTasks()
    }
    
    func updateTasks() {
        
        // to not show duplicates
        tasks.removeAll()
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        // iterate inclusive of count and get all the tasks and add it to task array
        for x in 0..<count {
            if let task = UserDefaults().value(forKey: "task_\(x+1)") as? String {
                tasks.append(task)
            }
        }
        
        // need to reload tableView show the stuff in tasks shows up
        tableView.reloadData()
        
    }
    
    @IBAction func didTapAdd() {
        
        // instantiate viewcontroller and now that it has title we present it
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        vc.title = "New Task"
        vc.update = {
            // making sure we prioritize updating
            DispatchQueue.main.async {
                self.updateTasks()
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
        
    }


}

// Handling taps on cell
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // to get rid of highlight that pops up
        
        // instantiate viewcontroller and now that it has title we present it
        let vc = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
        vc.title = "New Task"
        vc.task = tasks[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count // will be empty in the beginning
    }
    
    // function will only be called for how many cells are in the numberOfRowsInSection
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // here we need to dequeue a cell - basically using the cell over and over to get instance of cell - text of task is swapped out
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row]
        
        return cell
        
    }
    
    
}
