//
//  EntryViewController.swift
//  Tasks
//
//  Created by Manpreet Sokhi on 8/26/20.
//  Copyright © 2020 Manpreet Sokhi. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var field: UITextField!
    
    var update: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self

        // selector is a way to reference a function in this class that we want to call once the acutal button is clicked
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
    
    
    // function called when user hits the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        saveTask()
        
        return true
    }
    
    // @objc allows this functions to be used as a selector
    @objc func saveTask() {
        
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        // user defaults to save tasks - count might come back as nothing so guard against being nil
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        
        let newCount = count + 1
        
        UserDefaults().set(newCount, forKey: "count")
        UserDefaults().set(text, forKey: "task_\(newCount)")
        
        // ? is if the function exists call it
        update?()
        
        // once the update function is called get rid of the viewcontroller
        navigationController?.popViewController(animated: true)
        
    }
    

}
