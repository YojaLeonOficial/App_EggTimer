//
//  ViewController.swift
//  EggTimer
//
//  Created by Yojairo Jose Leon Escobar on 16/11/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    
    var eggTimes = ["Soft": 300, "Medium": 420, "Hard": 720]
    var timer = Timer()
    
    var totalTime: Float = 0
    var secondsPassed: Float = 0
    var player: AVAudioPlayer?
    var click = 0
    
    @IBOutlet weak var myTitleLabel: UILabel!
    @IBOutlet weak var myTimerLabel: UILabel!
    @IBOutlet weak var myProgressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        if click < 1 {
            timer.invalidate()
            click += 1
            let hardness = sender.currentTitle!
            totalTime = Float(eggTimes[hardness]!)
            myProgressView.progress = 0.001
            secondsPassed = 0
            myTitleLabel.text = hardness
            print(eggTimes[hardness]!)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        } else {
            showAlert(message: "You have an active cook already \n What do you wanna do??")
        }
    }
    
    
    @objc func updateCounter() {
        
        if secondsPassed < totalTime {
            secondsPassed += 1
            let percentageprogress = secondsPassed / totalTime
            myTimerLabel.text = "\(Int(percentageprogress * 100)) % of cooking."
            myProgressView.progress = percentageprogress
            
            
        } else {
            timer.invalidate()
            myTitleLabel.text = "Enjoy your Eggs!!"
            myTimerLabel.text = "DONE!"
            click = 0
            playSound()
            //Code should execute after 4 second delay.
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.myTitleLabel.text = "How do you like your eggs?"
                self.myTimerLabel.text = ""
                self.myProgressView.progress = 0.001
            }
        }
    }
    
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }
        
        do {
            // play the sound even the phone is on silent
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //POP UP
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "WAIT!!", message: message, preferredStyle: .alert)
        
        let submitButtonA = UIAlertAction(title: "Continue", style: .default, handler: nil)
        
        let submitButtonB = UIAlertAction(title: "Start Over", style: .default) { (action) in
            self.timer.invalidate()
            self.myTitleLabel.text = "How do you like your eggs?"
            self.myTimerLabel.text = ""
            self.myProgressView.progress = 0.001
            self.secondsPassed = 0
            self.click = 0
            
        }
        
        // Add button
        alert.addAction(submitButtonA)
        alert.addAction(submitButtonB)
        
        //show Alert
        self.present(alert, animated: true, completion: nil)
    }
}
