//
//  ViewController.swift
//  TriviaGameInSwift
//
//  Created by @Yohann305 Eyeball Digital on 4/11/15.
//  Copyright (c) 2015 www.iOSOnlineCourses.com. All rights reserved.
//

import UIKit
import AVFoundation // audio


class ViewController: UIViewController {

    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    
    
    @IBOutlet weak var labelQuestion: UILabel!
    
    @IBOutlet weak var labelScore: UILabel!
    
    @IBOutlet weak var labelFeedback: UILabel!
    
    @IBOutlet weak var buttonNext: UIButton!
    
    @IBOutlet weak var BackgroundImageView: UIImageView!
    
    var score :Int! = 0
    var allEntries : NSArray!
    
    
    var currentCorrectAnswerIndex : Int = 0
    
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        LoadAllQuestionsAndAnswers()
        
        let randomNumber = Int(arc4random_uniform(UInt32(allEntries.count)))
        LoadQuestion(randomNumber)
        LoadScore()
        
        AdjustInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func LoadScore()
    {
       let defaults = UserDefaults.standard
        score = defaults.integer(forKey: "score")
        labelScore.text = "score: \(score)"
    }
    
    
    func SaveScore()
    {
        let defaults = UserDefaults.standard
        defaults.set(score, forKey: "score")
    }
    
    
    func LoadAllQuestionsAndAnswers()
    {
        let path = Bundle.main.path(forResource: "content", ofType: "json")
        let jsonData : Data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        allEntries = (try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSArray
        //println(allEntries)
        
    }
    
    
    func LoadQuestion(_ index : Int)
    {
        let entry : NSDictionary = allEntries.object(at: index) as! NSDictionary
        let question : NSString = entry.object(forKey: "question") as! NSString
        let arr : NSMutableArray = entry.object(forKey: "answers") as! NSMutableArray
        
        //println(question)
        //println(arr)
        
        labelQuestion.text = question as String
        
        let indices : [Int] = [0,1,2,3]
        //let newSequence = shuffle(indices)
        let newSequence = indices.shuffle()
        var i : Int = 0
        while(i < newSequence.count)
        {
            let index = newSequence[i]
            if(index == 0)
            {
                // we need to store the correct answer index
                currentCorrectAnswerIndex =  i
                
            }
            
            let answer = arr.object(at: index) as! NSString
            switch(i)
            {
            case 0:
                buttonA.setTitle(answer as String, for: UIControlState())
                break;
                
            case 1:
                buttonB.setTitle(answer as String, for: UIControlState())
                break;
                
            case 2:
                buttonC.setTitle(answer as String, for: UIControlState())
                break;
                
            case 3:
                buttonD.setTitle(answer as String, for: UIControlState())
                break;
                
            default:
                break;
            }
            
            
            i += 1
        }
        buttonNext.isHidden = true
        // we will need to reset the buttons to reenable them
        ResetAnswerButtons()
        
    }
    
    /*func shuffle<C: MutableCollectionType where C.Index == Int>(var list: C) -> C {
        let total = list.count
        for i in 0..<(total - 1) {
            let j = Int(arc4random_uniform(UInt32(total - i))) + i
            swap(&list[i], &list[j])
        }
        return list
    }*/
    
    func ResetAnswerButtons()
    {
        buttonA.alpha = 1.0
        buttonB.alpha = 1.0
        buttonC.alpha = 1.0
        buttonD.alpha = 1.0
        buttonA.isEnabled = true
        buttonB.isEnabled = true
        buttonC.isEnabled = true
        buttonD.isEnabled = true
    }
    

    @IBAction func PressedButtonA(_ sender: UIButton) {
        print("button A pressed")
        buttonB.alpha = 0.3
        buttonC.alpha = 0.3
        buttonD.alpha = 0.3
        
        buttonA.isEnabled = false
        buttonB.isEnabled = false
        buttonC.isEnabled = false
        buttonD.isEnabled = false
         CheckAnswer(0)
    }

    @IBAction func PressedButtonB(_ sender: UIButton) {
        print("button B pressed")
        buttonA.alpha = 0.3
        buttonC.alpha = 0.3
        buttonD.alpha = 0.3
        
        buttonA.isEnabled = false
        buttonB.isEnabled = false
        buttonC.isEnabled = false
        buttonD.isEnabled = false
        CheckAnswer(1)
    }
    
    @IBAction func PressedButtonC(_ sender: UIButton) {
        print("button C pressed")
        buttonA.alpha = 0.3
        buttonB.alpha = 0.3
        buttonD.alpha = 0.3
        
        buttonA.isEnabled = false
        buttonB.isEnabled = false
        buttonC.isEnabled = false
        buttonD.isEnabled = false
        CheckAnswer(2)
    }
    
    @IBAction func PressedButtonD(_ sender: UIButton) {
        print("button D pressed")
        buttonA.alpha = 0.3
        buttonB.alpha = 0.3
        buttonC.alpha = 0.3
        
        buttonA.isEnabled = false
        buttonB.isEnabled = false
        buttonC.isEnabled = false
        buttonD.isEnabled = false
        CheckAnswer(3)
    }
    
    @IBAction func PressedButtonNext(_ sender: UIButton) {
        print("button Next pressed")
        let randomNumber = Int(arc4random_uniform(UInt32(allEntries.count)))
        LoadQuestion(randomNumber)
        // we need to play a sound effect for the next question coming
        PlaySoundButton()
        
    }
    
    func CheckAnswer( _ answerNumber : Int)
    {
        if(answerNumber == currentCorrectAnswerIndex)
        {
            // we have the correct answer
            labelFeedback.text = "Correct! +1"
            labelFeedback.textColor = UIColor.green
            score = score + 1
            labelScore.text = "score: \(score)"
            SaveScore()
            // later we want to play a "correct" sound effect
            PlaySoundCorrect()
            
        }
        else
        {
            // we have the wrong answer
            labelFeedback.text = "Wrong answer"
            labelFeedback.textColor = UIColor.red
            // we want to play a "incorrect" sound effect
            PlaySoundWrong()
        }
        
        buttonNext.isEnabled = true
        buttonNext.isHidden = false
    }
    
    func PlaySoundCorrect()
    {
       let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: "correct", ofType: "mp3")!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: alertSound)
        } catch {
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        
        
    }
    
    func PlaySoundWrong()
    {
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: "wrong", ofType: "wav")!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: alertSound)
        } catch  {
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    
    func PlaySoundButton()
    {
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: "button", ofType: "wav")!)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: alertSound)
        } catch {
        }
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    
    func AdjustInterface()
    {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        buttonA.center = CGPoint(x: screenWidth / 2, y: buttonA.center.y)
        buttonB.center = CGPoint(x: screenWidth / 2, y: buttonB.center.y)
        buttonC.center = CGPoint(x: screenWidth / 2, y: buttonC.center.y)
        buttonD.center = CGPoint(x: screenWidth / 2, y: buttonD.center.y)
        buttonNext.center = CGPoint(x: screenWidth / 2, y: buttonNext.center.y)
        labelQuestion.center = CGPoint(x: screenWidth / 2, y: labelQuestion.center.y)
        
        BackgroundImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        
    }
    
}



extension Collection where Index == Int {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        var i : Int = 0
        let cnt: Int = count as! Int
        while(i < cnt - 1) {
            let j = Int(arc4random_uniform(UInt32(cnt - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
            i += 1
        }
    }
}
































