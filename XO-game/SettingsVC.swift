//
//  SettingsVC.swift
//  XO-game
//
//  Created by Vitaliy Talalay on 29.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var gameModeSegment: UISegmentedControl!
    
    public var settingsDelegate: GameConfigDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeGameMode(_ sender: Any) {
        let gameMode: GameMode
        switch gameModeSegment.selectedSegmentIndex {
        case 0:
            gameMode = .TwoPlayers
        case 1:
            gameMode = .againstTheComputer
        case 2:
            gameMode = .fiveMarks
        default:
            gameMode = .TwoPlayers
        }
        settingsDelegate?.setNewMode(newMode: gameMode)
    }
}
