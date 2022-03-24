//
//  AdminViewScoreViewController.swift
//  TestBankApp
//
//  Created by admin on 3/23/22.
//

import UIKit
import SQLite3

class AdminViewScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var viewScoresBtnOutlet: UIButton!
    @IBOutlet weak var userEmailTF: UITextField!
    @IBOutlet weak var scoresTableView: UITableView!
    
    var databaseHelper = DBHelper()
    var scoreList = [Scores]()
    var scoresArray : [String] = [""]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let f1 = databaseHelper.prepareDatabaseFile()
         
        // print("Data base phat is :", f1)
        // var url = URL(string: f1)
         //Open the Data base or create it
     
         if sqlite3_open(f1, &DBHelper.dataBase) != SQLITE_OK{
             print("Can not open data base")
         }
    }
    

 

    @IBAction func viewScores(_ sender: Any) {
        
        let email = userEmailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
         var userToView = User(id: 0, name: "", password: "", subscribed: "", ranking: "", email: "", blocked: "")
         
         //allows us to pull user list from database helper
         databaseHelper.fetchUserByEmail(emailToFetch: email)
         
         for list in databaseHelper.usersList{
             userToView = User(id: list.id, name: list.name, password: list.password, subscribed: list.subscribed, ranking: list.ranking, email: list.email, blocked: list.blocked)
            }
             
             databaseHelper.viewUserScores(userID: userToView.id)
             
             scoreList = databaseHelper.scoresList
             
             for list in scoreList{
                 scoresArray.append("User ID: \(list.userID) Quiz ID: \(list.quizID)  Date Taken: \(list.dateTaken) Score: \(list.score)")
             }
             
             for n in scoresArray{
                 print("\(scoresArray)")
             }
             
             //userScoresDisplayLabel.text = scoresArray.joined(separator: ",")
             
         }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
