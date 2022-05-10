//
//  QuizzViewController.swift
//  TestBankApp
//
//  Created by Ives Murillo on 3/21/22.
//

import UIKit
import SQLite3

class QuizzViewController: UIViewController {
    
    
    //MARK: IB Outlets
    
    //Information labels
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionScore: UILabel!
    @IBOutlet weak var questionCount: UILabel!
    @IBOutlet weak var quizScoreLabel: UILabel!
    
    //Question label

    @IBOutlet weak var questionLabel: UILabel!
    
    //Answers labels
    
    @IBOutlet weak var answerOneLabel: UILabel!
    
    @IBOutlet weak var answerTwoLabel: UILabel!
    
    @IBOutlet weak var answerThreeLabel: UILabel!

    
    //Answer buttons
    
    @IBOutlet weak var answerOneButton: UIButton!
    
    @IBOutlet weak var answerTwoButton: UIButton!
    
    
    @IBOutlet weak var answerThreeButton: UIButton!
    
    //Submit button
    
    @IBOutlet weak var submitQuizzButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    //MARK: Declaring variables
    
    //timer
    var seconds = 30
    var timerr = Timer()
    
    //TODO: Setting global variables
    var userLoggedIn = GlobalVariables.userLoguedIn
    var quizSelectedID = GlobalVariables.quizzSelected.id
    
    
    //TODO: Data model
    var databaseHelper = DBHelper()
    var database = DBHelper.dataBase
    
    //List of Questions
    var questionsList = [Question] ()
    
    //counter of the question per quizz taken
    var questionsCount = 0
    
    //Right answer of actual question
    var rightanswer = " "
    
    //Score of the quESTION
    //If the answer if right increment the count of score in 1
    var quizzScore = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // Do any additional setup after loading the view.
        
        //styling labels
        Utilities.styleLabel(answerOneLabel)
        Utilities.styleLabel(answerTwoLabel)
        Utilities.styleLabel(answerThreeLabel)
        
        
        //styling buttons
        Utilities.styleHollowButton(answerOneButton)
        Utilities.styleHollowButton(answerTwoButton)
        Utilities.styleHollowButton(answerThreeButton)
        Utilities.styleFilledButton(submitQuizzButton)
        Utilities.styleFilledButton(nextButton)
        
        //labels information
        questionScore.text = "0"
        questionCount.text = "1"
        quizScoreLabel.text = "0"
        
        //cretae a timer
        
        
        
        //Open database
       let f1 = databaseHelper.prepareDatabaseFile()
        
        print("Data base phat is :", f1)
       // var url = URL(string: f1)
        //Open the Data base or create it
    
        if sqlite3_open(f1, &DBHelper.dataBase) != SQLITE_OK{
            print("Can not open data base")
        }
        
        print("quizz to present whit id \(quizSelectedID)")
        
        databaseHelper.Questions(quizId: quizSelectedID)
        
        questionsList = databaseHelper.questionsList
       
        //print(questionsList)
        
        displayQuizz(questionNumber: 0)
        
        //Hide subbmit button
        submitQuizzButton.isHidden = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       timerr = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(QuizzViewController.counter), userInfo: nil, repeats: true)
    }
    
    //TODO: Display a quiz when a collection item is selected
    func displayQuizz(questionNumber: Int){
        
        questionLabel.text = questionsList[questionNumber].question
        answerOneLabel.text = questionsList[questionNumber].option1
        answerTwoLabel.text = questionsList[questionNumber].option2
        answerThreeLabel.text = questionsList[questionNumber].option3
        
        rightanswer = questionsList[questionNumber].answer
        
    }
    
    //Metho display the counter
    //display submit button and hide next button
    @objc func counter(){
        seconds -= 1    
        timerLabel.text = String(seconds)
        if(seconds == 0){
            timerr.invalidate()
            submitQuizzButton.isHidden = false
            nextButton.isHidden = true
        }
    }
    
    
    
    
    
    
    //TODO: functions for the logic of answer questions mjfg
    var amountToUpdate = 0
    
    fileprivate func updateScore() {
        amountToUpdate = 1
        quizzScore += amountToUpdate
       
        
    }
    
    fileprivate func checkRightAnswer(_ option: String) {
        
        if option == rightanswer && amountToUpdate == 0{
            
            updateScore()
            
            //display score
           
            
            print("Right answer \(option) you get one more point and your new score for the quizz is \(quizzScore)")
        }else if option != rightanswer && amountToUpdate == 1 {
            quizzScore = quizzScore - amountToUpdate
            amountToUpdate = 0
            print("wrong answer \(option) you dont get any point and your new score is \(quizzScore)")
        }else{
            print("wrong answer \(option) you dont get any point and your new score is \(quizzScore)")        }
    }
    
    @IBAction func answerOneButtonPressed(_ sender: Any) {
        
        let option = "opt1"
        checkRightAnswer(option)
        selectButton(answerOneButton, answerTwoButton, answerThreeButton)
        questionScore.text = String(quizzScore)
    }
    
    
    @IBAction func answerTwoButtonPressed(_ sender: Any) {
        let option = "opt2"
        
        checkRightAnswer(option)
        selectButton(answerTwoButton, answerOneButton, answerThreeButton)
        questionScore.text = String(quizzScore)
        
    }
    
    
    
    @IBAction func answerThreeButtonPressed(_ sender: Any) {
        
        let option = "opt3"
        
        checkRightAnswer(option)
        selectButton(answerThreeButton, answerTwoButton, answerOneButton)
        questionScore.text = String(quizzScore)
        
    }
    
    //Navigation
    //when user pressed next button
    //bug whit the count of questions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        
        
        //decide if is the last question to show the submit button
        if questionsCount == 3{
            submitQuizzButton.isHidden = false
            nextButton.isHidden = true
        }
        
        if questionsCount < 4 {
        questionsCount += 1
        resetButtons(answerOneButton, answerTwoButton, answerThreeButton)
        displayQuizz(questionNumber: questionsCount)
            print("question number ",questionsCount)
            
            GlobalVariables.globalQuizzScore += quizzScore
            print(GlobalVariables.globalQuizzScore)
            quizScoreLabel.text = String(GlobalVariables.globalQuizzScore)
            questionCount.text = String(questionsCount + 1)
            
        }
        
        
        
    }
    
    
    //When user press submit button
    
    @IBAction func submitQuizzPressedAction(_ sender: Any) {
        
     //   GlobalVariables.globalQuizzScore += quizzScore
        print("the score of the quizz just taken is : ",GlobalVariables.globalQuizzScore)
        
        
        var date = Date()
        
        databaseHelper.addQuizzTaken(userId: GlobalVariables.userLoguedIn.id, quizzId: quizSelectedID, dateTaked: date.description, score: GlobalVariables.globalQuizzScore)
        
        
        
    }
    
    
    
    
    //Select a butto amswer
    fileprivate func selectButton(_ selected : UIButton,_ unselected1 : UIButton,_ unselected2: UIButton
    ) {
        //Style selected
        Utilities.styleFilledButton(selected)
        
        //Style unselected 1
        Utilities.styleHollowButton(unselected1)
        
        //Style unselected 2
        Utilities.styleHollowButton(unselected2)
    }
    
    //Reset answer buttons when a next question is display
    
    fileprivate func resetButtons(_ selected : UIButton,_ unselected1 : UIButton,_ unselected2: UIButton
    ) {
        //Style selected
        Utilities.styleHollowButton(selected)
        
        //Style unselected 1
        Utilities.styleHollowButton(unselected1)
        
        //Style unselected 2
        Utilities.styleHollowButton(unselected2)
    }
    
    //funcntion to check if the button selected is the right answer
    
    func chechAnswer(){
        let answer = questionsList[questionsCount].answer
    }
    
    
    
    //function to go back selection quiz
    

}
