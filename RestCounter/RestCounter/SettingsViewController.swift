//
//  SettingsViewController.swift
//  RestCounter
//
//  Created by Dejan Tomic on 21/04/2020.
//  Copyright © 2020 Dejan Tomic. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    
    @IBOutlet weak var addMinutesButton: UIButton!
    @IBOutlet weak var minusMinutesButton: UIButton!
    @IBOutlet weak var addSecondsButton: UIButton!
    @IBOutlet weak var minusSecondsButton: UIButton!
    @IBOutlet weak var saveSettingsButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timerLabel.text = "\(TimerLabelMinutesTens)\(TimerLabelMinutesUnits):\(TimerLabelsecondsTens)\(TimerLabelsecondsUnits)"
        
        settings(AreHidden: true)
    }
    
    
    
    


}
