//
//  DatabaseTableViewController.swift
//  CarrotiOS
//
//  Created by Stephen Syrnyk on 2019-04-04.
//  Copyright © 2019 Stephen Syrnyk. All rights reserved.
//

import UIKit
import CoreData

class DatabaseTableViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var sessions = [Session]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Session History"
        self.getSessions()
        print(sessions.count)
        print("Sessions")
        
    }
    
    
    func getSessions(){
        
        let sortByDate = NSSortDescriptor(key: "sessionDate", ascending: false)
        
        let fetchRequest: NSFetchRequest<Session> = Session.fetchRequest()
        
        fetchRequest.sortDescriptors = [sortByDate]
        // wrap our try statement below in a do/catch block so we can handle any errors
        do {
            // fetch our items using our fetch request, save them in our items array
            sessions = try context.fetch(fetchRequest)
        } catch {
            print("Error fetching items: \(error)")
        }
        
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "sessionCell")
        //let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        
        let session = sessions[indexPath.row]
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "EEE, MMM dd yyyy HH:mma"
        
        let date = dateFormatterGet.string(from: session.sessionDate ?? Date())
        
        cell.textLabel?.textColor = session.completed ? UIColor.green : UIColor.red
        
        cell.textLabel?.text = session.completed ? "Completed Session" : "Abandoned Session"
        cell.detailTextLabel?.text = date
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    
}
