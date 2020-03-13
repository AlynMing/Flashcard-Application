//
//  ViewController.swift
//  Flashcards
//
//  Created by Xcode User on 2/15/20.
//  Copyright © 2020 Jillian Huizenga. All rights reserved.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
    var possibleAnswers: [String]
}

class ViewController: UIViewController {

    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var card: UIView!
    
    // Array to hold our flashcards
    var flashcards = [Flashcard]()
    
    // Current Flashcard index
    var currentIndex = 0
    
    @IBOutlet weak var btnOptionOne: UIButton!
    @IBOutlet weak var btnOptionTwo: UIButton!
    @IBOutlet weak var btnOptionThree: UIButton!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
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
        
        // Read saved flashcards
        readSavedFlashcards()
        
        // Adding our initial flashcard if needed
        if flashcards.count == 0 {
            updateFlashcard(question: "How many writings systems does Japanese have?", answer1: "One", answer2: "Three", answer3: "Two", isExisting: false)
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
    
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
        
        if frontLabel.isHidden {
            frontLabel.isHidden = false
        }else{
            frontLabel.isHidden = true
        }
        
    }
    
    func updateFlashcard(question: String, answer1: String, answer2: String, answer3: String, isExisting: Bool) {
        
        let flashcard = Flashcard(question: question, answer: answer2, possibleAnswers: [answer1, answer2, answer3])
        
        if isExisting {
            
            // Replace existing flashcard
            flashcards[currentIndex] = flashcard
            
        } else {
            
            // Adding flashcard in the flashcards array
            flashcards.append(flashcard)
            
            // Logging to the console
            print("Added new flashcard")
            print("We now have \(flashcards.count) flashcards")
            
            // Update current index
            currentIndex = flashcards.count - 1
            print("Our current index is \(currentIndex)")
        }
        
        // Update buttons
        updateNextPrevButtons()
        
        // Update labels
        updateLabels()
        
        // Save flashcards
        saveAllFlashcardsToDisk()
    }
    
    func updateNextPrevButtons(){
        
        // Disable next button if at the end
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        // Disable prev button if at the beginning
        if currentIndex == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    
    func updateLabels(){
        
        // Get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        // Update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
        btnOptionOne.setTitle(currentFlashcard.possibleAnswers[0], for: .normal)
        btnOptionTwo.setTitle(currentFlashcard.possibleAnswers[1], for: .normal)
        btnOptionThree.setTitle(currentFlashcard.possibleAnswers[2], for: .normal)
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
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        
        // Decrease current index
        currentIndex -= 1
        
        // Update labels
        updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
        
        btnOptionOne.isHidden = false
        btnOptionThree.isHidden = false
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        
        // Increase current index
        currentIndex += 1
        
        // Update labels
        updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
        
        btnOptionOne.isHidden = false
        btnOptionThree.isHidden = false
    }
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        
        // Show confirmation
        let alert = UIAlertController(title: "Delete flashcard", message: "Are you sure you want to delete this flashcard?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in self.deleteCurrentFlashcard()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func deleteCurrentFlashcard(){
        
        // Delete current
        flashcards.remove(at: currentIndex)
        
        // Special case: Check if last card was deleted
        if currentIndex > flashcards.count - 1 {
            currentIndex = flashcards.count - 1
        }
        
        if currentIndex == -1 {
            createPlaceholder()
        }
        
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
    }
    
    func createPlaceholder(){
        let placeholder = Flashcard(question: "Question", answer: "Answer2", possibleAnswers: ["Answer1", "Answer2", "Answer3"])
        
        flashcards.append(placeholder)
        
        currentIndex = flashcards.count - 1
        
    }
    
    func saveAllFlashcardsToDisk(){
        
        // From flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String: String] in return ["question": card.question, "answer": card.answer, "anwer1": card.possibleAnswers[0], "answer2": card.possibleAnswers[1], "answer3": card.possibleAnswers[2]]
            
        }
        
        // Save array on disk using UserDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        // Log it
        print("Flashcards saved to UserDefaults")
    }
    
    func readSavedFlashcards(){
        
        // read dictionary array from disk (if any)
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards")
            as? [[String: String]] {
            
            // In here we know for sure we have a dictionary array
            let savedCards = dictionaryArray.map {dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!, possibleAnswers: [dictionary["anwer1"]!, dictionary["answer2"]!, dictionary["answer3"]!])}
            
            // Put all these cards in our flashcards array
            flashcards.append(contentsOf: savedCards)
        }
        
    }
    
    
}

