//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let eggTimes : [String : Int] = ["Soft": 3,
                                     "Medium": 4,
                                     "Hard": 7]
    var timer = Timer()
    var totalTime = 0
    var secondsPassed = 0
    
    var player: AVAudioPlayer?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timerBar: UIProgressView!
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        timer.invalidate()
        
        let hardness = sender.currentTitle!
        
        titleLabel.text = "Cooking..."
        
        totalTime = eggTimes[hardness]!
        secondsPassed = 0
        timerBar.progress = 0.0
        
        startOtpTimer(eggTypeTime: totalTime)
        
    }

    private func startOtpTimer(eggTypeTime: Int) {
            self.totalTime = eggTypeTime
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
            if secondsPassed < totalTime {
                
                secondsPassed += 1
                
                print("\(self.secondsPassed) seconds.")
                
            } else {
                timer.invalidate()
                titleLabel.text = "Done!"
                playSound()
            }
        
            let percentageProgress = Float(secondsPassed)/Float(totalTime)
            timerBar.progress = percentageProgress
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
