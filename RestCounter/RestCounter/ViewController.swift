//
//  ViewController.swift
//  RestCounter
//
//  Created by Dejan Tomic on 21/04/2020.
//  Copyright © 2020 Dejan Tomic. All rights reserved.
//

import UIKit
import AVFoundation

var player: AVAudioPlayer?


class ViewController: UIViewController {
    
    @IBOutlet weak var minutesTensLabel: UILabel!
    @IBOutlet weak var minutesUnitLabel: UILabel!
    
    @IBOutlet weak var secondsTensLabel: UILabel!
    @IBOutlet weak var secondsUnitLabel: UILabel!
    
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
        
    @IBOutlet weak var settingsUIView: UIView!
    
    @IBOutlet weak var addMinutesButton: UIButton!
    @IBOutlet weak var minusMinutesButton: UIButton!
    @IBOutlet weak var addSecondsButton: UIButton!
    @IBOutlet weak var minusSecondsButton: UIButton!
    @IBOutlet weak var minutesSettingsLabel: UILabel!
    @IBOutlet weak var secondsSettingsLabel: UILabel!
    @IBOutlet weak var exitSettingsButton: UIButton!
    @IBOutlet weak var muteSoundButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    
    var seconds = 0
    var TimerLabelsecondsUnits = 0
    var TimerLabelsecondsTens = 0
    var TimerLabelMinutesUnits = 0
    var TimerLabelMinutesTens = 0
    
    var timer = Timer()
    var timerHasStarted = false
    var round = 0
    var minutesRestDuration = 2.0

    var soundIsMuted = false
    let soundOffImage = UIImage(named: "soundOff.png")
    let soundOnImage = UIImage(named: "soundOn.png")

    var secondsUserDefault = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        settings(AreHidden: true)
        startStopButton.layer.cornerRadius = 10
        displayRestDuration()
    }

    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        settings(AreHidden: false)
        startStopButton.isEnabled = false
        roundLabel.text = "rest duration"
        displayRestDuration()
    }
    
    
    @IBAction func exitSettingsButtonPressed(_ sender: UIButton) { 
        settings(AreHidden: true)
        startStopButton.isEnabled = true
        roundLabel.text = "round \(round)"
    }
    
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        round = 0
        minutesRestDuration = 1
        secondsUserDefault.set(minutesRestDuration, forKey: "minutesRestDurationUserDefaults")

        displayRestDuration()
    }
    
    @IBAction func addTimeButtonPressed(_ sender: UIButton) {
        var timeIncrement = 0.0
        
        switch sender.tag {
        case 1: if minutesRestDuration < 59.5 { timeIncrement = 1 }
            
        case 2: if minutesRestDuration > 0.9 { timeIncrement = -1 }
            
        case 3: if minutesRestDuration < 60 { timeIncrement = 0.5 }
            
        case 4: if minutesRestDuration > 0.4 { timeIncrement = -0.5 }
            
        default: timeIncrement = 0

        }
            minutesRestDuration += timeIncrement
            secondsUserDefault.set(minutesRestDuration, forKey: "minutesRestDurationUserDefaults")
            displayRestDuration()
    }
    
    func displayRestDuration() {
        minutesRestDuration = secondsUserDefault.double(forKey: "minutesRestDurationUserDefaults")
        
        print("\(minutesRestDuration)")
        
        minutesTensLabel.text = "\(Int((minutesRestDuration/10)))"
        secondsTensLabel.text = "0"

        if minutesRestDuration.truncatingRemainder(dividingBy: 1) == 0 {
            // There are no seconds, just minutes
            if minutesRestDuration < 10 {
               minutesTensLabel.text = "0"
               minutesUnitLabel.text = "\(Int((minutesRestDuration)))"
               secondsTensLabel.text = "0"
            } else if minutesRestDuration < 20 {
                minutesUnitLabel.text = "\(Int((minutesRestDuration - 10)))"
                                } else if minutesRestDuration < 30 {
                                    minutesUnitLabel.text = "\(Int((minutesRestDuration - 20)))"
                                } else if minutesRestDuration < 40 {
                                    minutesUnitLabel.text = "\(Int((minutesRestDuration - 30)))"
                                } else if minutesRestDuration < 50 {
                                    minutesUnitLabel.text = "\(Int((minutesRestDuration - 40)))"
                                } else if minutesRestDuration < 60 {
                                    minutesUnitLabel.text = "\(Int((minutesRestDuration - 50)))"
                                } else {
                                    minutesUnitLabel.text = "\(Int((minutesRestDuration - 50)))"
                                    minutesUnitLabel.text = "0"
                            }

        } else {
            secondsTensLabel.text = "3"

            if minutesRestDuration < 10 {
               minutesTensLabel.text = "0"
               minutesUnitLabel.text = "\(Int((minutesRestDuration)))"
            } else if minutesRestDuration < 20 {
                minutesUnitLabel.text = "\(Int((minutesRestDuration - 10)))"
                                } else if minutesRestDuration < 30 {
                                    minutesUnitLabel.text = "\(Int((minutesRestDuration - 20)))"
                                } else if minutesRestDuration < 40 {
                                    minutesUnitLabel.text = "\(Int((minutesRestDuration - 30)))"
                                } else if minutesRestDuration < 50 {
                                    minutesUnitLabel.text = "\(Int((minutesRestDuration - 40)))"
                                } else if minutesRestDuration < 60 {
                                    minutesUnitLabel.text = "\(Int((minutesRestDuration - 50)))"
                                } else {
                                    minutesUnitLabel.text = "\(Int((minutesRestDuration - 50)))"
                                    minutesUnitLabel.text = "0"
                            }
        }
    }
        
    
    @IBAction func startStopButtonPressed(_ sender: UIButton) {

        if timerHasStarted == false {
            resetTimer()
            timerHasStarted = true
            runTimer()
            round += 1
            roundLabel.text = "round \(round)"
            startStopButton.setTitle("stop", for: .normal)

        } else {
            timerHasStarted = false
            resetTimer()
            timer.invalidate()
            startStopButton.setTitle("start", for: .normal)
        }
    }
    
    

    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
            }
    
     
    @objc func updateTimer() {
        if seconds < Int((60 * minutesRestDuration))  {
            seconds += 1
        
        if seconds.isMultiple(of: 600) {
            updateMinutesTens()
            updateMinutesUnits()
            updateSecondsTens()
            updateSecondsUnits()
            
        } else if seconds.isMultiple(of: 60) {
            updateMinutesUnits()
            updateSecondsTens()
            updateSecondsUnits()
                        
        } else if seconds.isMultiple(of: 10) {
            updateSecondsTens()
            updateSecondsUnits()
        } else {
            updateSecondsUnits()
        }

        } else {
            timerHasStarted = false
            resetTimer()
            timer.invalidate()
            playAlarm()
            startStopButton.setTitle("start", for: .normal)
        }
    }
    
    
    func updateMinutesTens() {
        if TimerLabelMinutesTens <= 4 {
        TimerLabelMinutesTens += 1
        } else {
            TimerLabelMinutesTens = 0
        }
        minutesTensLabel.text = "\(TimerLabelMinutesTens)"
    }
    
    
    func updateMinutesUnits() {
        if TimerLabelMinutesUnits <= 8 {
        TimerLabelMinutesUnits += 1
        } else {
            TimerLabelMinutesUnits = 0
        }
        minutesUnitLabel.text = "\(TimerLabelMinutesUnits)"
    }
    
    
    func updateSecondsTens() {
        if TimerLabelsecondsTens <= 4 {
        TimerLabelsecondsTens += 1
        } else {
            TimerLabelsecondsTens = 0
        }
        secondsTensLabel.text = "\(TimerLabelsecondsTens)"
    }
    
    
    func updateSecondsUnits() {
        if TimerLabelsecondsUnits <= 8 {
        TimerLabelsecondsUnits += 1
        } else {
            TimerLabelsecondsUnits = 0
        }
        secondsUnitLabel.text = "\(TimerLabelsecondsUnits)"
    }
    

    func resetTimer() {
        seconds = 0
        TimerLabelMinutesTens = 0
        TimerLabelMinutesUnits = 0
        TimerLabelsecondsTens = 0
        TimerLabelsecondsUnits = 0
        
        minutesUnitLabel.text = "\(TimerLabelMinutesUnits)"
        minutesTensLabel.text = "\(TimerLabelMinutesTens)"
        secondsTensLabel.text = "\(TimerLabelsecondsTens)"
        secondsUnitLabel.text = "\(TimerLabelsecondsUnits)" 
    }

    
    func settings(AreHidden: Bool) {
        settingsUIView.layer.cornerRadius = 15
        addMinutesButton.layer.cornerRadius = 15
        minusMinutesButton.layer.cornerRadius = 15
        addSecondsButton.layer.cornerRadius = 15
        minusSecondsButton.layer.cornerRadius = 15
        exitSettingsButton.layer.cornerRadius = 15
        resetButton.layer.cornerRadius = 15
        
        if AreHidden == true {
            settingsUIView.isHidden = true
            exitSettingsButton.isHidden = true
    
        } else {
            settingsUIView.isHidden = false
            exitSettingsButton.isHidden = false
        }
    }
    
    
    @IBAction func muteSoundButtonPressed(_ sender: UIButton) {
        if soundIsMuted == false {
        soundIsMuted = true
        print("Sound is muted")
        muteSoundButton.setImage(UIImage (named: "soundOff.png"), for: .normal)

        } else {
            soundIsMuted = false
            muteSoundButton.setImage(UIImage (named: "soundOn.png"), for: .normal)
            print("Sound is NOT muted")
        }
    }
    
    
    func playAlarm() {
        if soundIsMuted == false {
        let path = Bundle.main.path(forResource: "alarm.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
        } catch {
            // couldn't load file :(
            print("Problem during playback")
        }
            
        } else {
            print("Sound is muted")
        }
    }
   
    
}
           
    
