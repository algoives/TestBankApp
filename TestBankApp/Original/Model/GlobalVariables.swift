//
//  GlobalVariables.swift
//  TestBankApp
//
//  Created by Ives Murillo on 3/21/22.
//

import Foundation

class GlobalVariables {
    static var userLoguedIn : User = User(id: 0, name: "", password: "", subscribed: "", ranking: "", email: "", blocked: "false")
    
    static var quizzSelected : Quizz = Quizz(id: 0, tech: "")
    
    
    static var answer1Score = 0
    static var answer2Score = 0
    static var answer3Score = 0
    
    static var globalQuizzScore : Int = 0
    static var quizzAttempts : Int = 0
    
    //static var at
    
    
}
