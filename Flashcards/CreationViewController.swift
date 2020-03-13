//
//  CreationViewController.swift
//  Flashcards
//
//  Created by Xcode User on 2/29/20.
//  Copyright © 2020 Jillian Huizenga. All rights reserved.
//

import UIKit

class CreationViewController: UIViewController {
    
    var flashcardsController: ViewController!
    
    @IBOutlet weak var questionTextField: UITextField!
    
    @IBOutlet weak var answerOneTextField: UITextField!
    
    @IBOutlet weak var answerTwoTextField: UITextField!
    
    @IBOutlet weak var answerThreeTextField: UITextField!
    
    var initialQuestion: String?
    var initialAnswerTwo: String?
    
    var initialAnswerOne: String?
    var initialAnswerThree: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
        questionTextField.text = initialQuestion
        answerTwoTextField.text = initialAnswerTwo
        
        answerOneTextField.text = initialAnswerOne
        answerThreeTextField.text = initialAnswerThree
        
    }
    
    @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func didTapOnDone(_ sender: Any) {
        
        let questionText = questionTextField.text
        
        let answerOneText = answerOneTextField.text
        
        let answerTwoText = answerTwoTextField.text
        
        let answerThreeText = answerThreeTextField.text
        
        if (questionText == nil || answerOneText == nil || answerTwoText == nil || answerThreeText == nil || questionText!.isEmpty || answerOneText!.isEmpty || answerTwoText!.isEmpty || answerThreeText!.isEmpty){
            
            let alert = UIAlertController(title: "Missing Text!", message: "You need to fill all fields.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(OKAction)
            
            present(alert, animated: true)
            
        }else{
            
            // See if it's existing
            var isExisting = false
            if initialQuestion != nil {
                isExisting = true
            }
            
            flashcardsController.updateFlashcard(question: questionText!, answer1: answerOneText!, answer2: answerTwoText!, answer3: answerThreeText!, isExisting: isExisting)
            
            dismiss(animated: true)
        }
    
        
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
