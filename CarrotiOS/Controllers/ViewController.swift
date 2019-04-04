//
//  ViewController.swift
//  CarrotiOS
//
//  Created by Stephen Syrnyk on 2019-04-04.
//  Copyright © 2019 Stephen Syrnyk. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var sessionsLeftLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var users = [User]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
        if (users.count == 0) {
            
            self.createUser()
        } else {
            if let username = users[0].name {self.welcomeLabel.text = "Welcome " + username + "!"}
            
            //REMOVE THIS NEXT LINE WHEN IN PRODUCTION
            users[0].sessionsLeft = 3
            
            self.sessionsLeftLabel.text = "Carrots: " + String(users[0].sessionsLeft)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.sessionsLeftLabel.text = "Carrots: " + String(users[0].sessionsLeft)
        
    }
    
    
    func getUsers(){
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        // wrap our try statement below in a do/catch block so we can handle any errors
        do {
            // fetch our items using our fetch request, save them in our items array
            users = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching items: \(error)")
        }
    
    }
    
    func saveUsers() {
        // wrap our try statement below in a do/catch block so we can handle any errors
        do {
            // save our context
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    func createUser() {
        // we need this in order to access the text field data outside of the 'addTextField' scope below
        var tempTextField = UITextField()
        
        // create a UIAlertController object
        let alertController = UIAlertController(title: "Hi! What's your name?", message: "", preferredStyle: .alert)
        
        // create a UIAlertAction object
        let alertAction = UIAlertAction(title: "Done", style: .default) { (action) in
            
            
            
            // if the text field text is not nil
            if let text = tempTextField.text {

                
                let user: User = User(context: self.context)
                
                let now = Date()
                user.lastLoginDate = now
                user.sessionsLeft = 3
                user.name = text
                
                self.users.append(user)
                
                self.welcomeLabel.text = "Welcome " + text + "!"
                self.sessionsLeftLabel.text = "Carrots: 3"
                
                self.saveUsers()
                
            }
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Your name"
            tempTextField = textField
        }
        
        // Add the action we created above to our alert controller
        alertController.addAction(alertAction)
        // show our alert on screen
        present(alertController, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCarrotSession" {
            guard let destinationNC = segue.destination as? UINavigationController,
                let destinationVC = destinationNC.topViewController as? CarrotSessionViewController else {
                    return
                }
            destinationVC.userCarrots = Int(users[0].sessionsLeft)
            
        }
    }
    
    @IBAction func StartSessionTapped(_ sender: Any) {
        if(users[0].sessionsLeft > 0){
            users[0].sessionsLeft -= 1
            self.saveUsers()
            
            performSegue(withIdentifier: "showCarrotSession", sender: self)
        }
    }
    
}

