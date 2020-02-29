//
//  ViewController.swift
//  Flashcards
//
//  Created by Xcode User on 2/15/20.
//  Copyright © 2020 Jillian Huizenga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var btnOptionOne: UIButton!
    @IBOutlet weak var btnOptionTwo: UIButton!
    @IBOutlet weak var btnOptionThree: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        card.layer.cornerRadius = 20.0
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.2
        
        frontLabel.layer.cornerRadius = 20.0
        backLabel.layer.cornerRadius = 20.0
        frontLabel.clipsToBounds = true
        backLabel.clipsToBounds = true
        
        btnOptionOne.layer.cornerRadius = 20.0
        btnOptionOne.layer.borderWidth = 3.0
        btnOptionOne.layer.borderColor = #colorLiteral(red: 0, green: 0.7081542015, blue: 0.4575010538, alpha: 1)
        
        btnOptionTwo.layer.cornerRadius = 20.0
        btnOptionTwo.layer.borderWidth = 3.0
        btnOptionTwo.layer.borderColor = #colorLiteral(red: 0, green: 0.7081542015, blue: 0.4575010538, alpha: 1)
        
        btnOptionThree.layer.cornerRadius = 20.0
        btnOptionThree.layer.borderWidth = 3.0
        btnOptionThree.layer.borderColor = #colorLiteral(red: 0, green: 0.7081542015, blue: 0.4575010538, alpha: 1)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        creationController.flashcardsController = self
        
        if segue.identifier == "EditSegue" {
            creationController.initialQuestion = frontLabel.text
            creationController.initialAnswerTwo = backLabel.text
        
            creationController.initialAnswerOne = btnOptionOne.title(for: .normal)
            creationController.initialAnswerThree = btnOptionThree.title(for: .normal)
        }
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        
        if (frontLabel.isHidden){
            frontLabel.isHidden = false
        }else{
            frontLabel.isHidden = true
        }
        
    }
    
    func updateFlashcard(question: String, answer1: String, answer2: String, answer3: String) {
        frontLabel.text = question
        backLabel.text = answer2
        
        btnOptionOne.setTitle(answer1, for: .normal)
        btnOptionTwo.setTitle(answer2, for: .normal)
        btnOptionThree.setTitle(answer3, for: .normal)
    }
    
    @IBAction func didTapOptionOne(_ sender: Any) {
        btnOptionOne.isHidden = true
    }
    
    @IBAction func didTapOptionTwo(_ sender: Any) {
        frontLabel.isHidden = true
    }
    
    @IBAction func didTapOptionThree(_ sender: Any) {
        btnOptionThree.isHidden = true
    }
}

