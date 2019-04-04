//
//  CarrotSessionViewController.swift
//  CarrotiOS
//
//  Created by Stephen Syrnyk on 2019-04-04.
//  Copyright © 2019 Stephen Syrnyk. All rights reserved.
//

import UIKit
import CoreData

class CarrotSessionViewController: UIViewController {

    var userCarrots : Int?
    
    var timeLeft = 24.0;
    var timer = Timer();
    var sessionCompleted: Bool = false
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var universalButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var carrotLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        runTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        carrotLabel.text = "Carrots: "  + String(userCarrots ?? 0)
        
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(CarrotSessionViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if(self.timeLeft > 0) {
            self.timeLeft -= 1
            
            let minutes = floor(timeLeft / 60)
            let seconds = timeLeft.truncatingRemainder(dividingBy: 60)
            
            var mString: String
            var sString: String
            
            if(minutes < 10) {
                mString = "0" + String(Int(minutes))
            } else {
                mString = String(Int(minutes))
            }
            
            if(seconds < 10) {
                sString = "0" + String(Int(seconds))
            } else {
                sString = String(Int(seconds))
            }
            
            timerLabel.text = mString + ":" + sString
        } else {
            timer.invalidate()
            self.sessionCompleted = true
            universalButton.setTitle("Finish", for: .normal)
        }
    }

    @IBAction func buttonTapped(_ sender: Any) {
        
        let session: Session = Session(context: self.context)
        
        session.sessionDate = Date()
        
        if (!sessionCompleted) {
            
            session.completed = false
            self.saveSessions()
            dismiss(animated: true, completion: nil)
        } else {
            session.completed = true
            self.saveSessions()
            dismiss(animated: true, completion: nil)        }
    }
    
    func saveSessions() {
        // wrap our try statement below in a do/catch block so we can handle any errors
        do {
            // save our context
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
