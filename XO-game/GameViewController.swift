//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

protocol GameConfigDelegate {
    func setNewMode(newMode: GameMode)
}

class GameViewController: UIViewController {
    
    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    private let gameboard = Gameboard()
    private var currentState: GameState! {
        didSet {
            self.currentState.begin()
        }
    }
    private lazy var referee = Referee(gameboard: self.gameboard)
    private var gameMode = GameMode.TwoPlayers {
        didSet {
            goToFirstState()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.goToFirstState()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.currentState.addMark(at: position)
            if self.currentState.isCompleted {
                self.goToNextState()
            }
        }
    }
    
    private func goToFirstState() {
        let player = Player.first
        switch gameMode {
        case .TwoPlayers, .againstTheComputer:
            currentState = PlayerInputState(player: .first,
                                            markViewPrototype: player.markViewPrototype,
                                            gameViewController: self,
                                            gameboard: gameboard,
                                            gameboardView: gameboardView)
        case .fiveMarks:
            currentState = GameFiveMarksState(player: .first,
                                              markViewPrototype: player.markViewPrototype,
                                              gameViewController: self,
                                              gameboard: gameboard,
                                              gameboardView: gameboardView)
        }
    }
    
    private func goToNextState() {
        if let winner = referee.determineWinner() {
            currentState = GameEndedState(winner: winner,
                                          gameViewController: self)
            return
        }
        
        var player = Player.first
        if let playerInputState = currentState as? PlayerInputState {
            player = playerInputState.player.next
        }
        if let playerComputerState = currentState as? ComputerInputState {
            player = playerComputerState.player.next
        }
        if let playerFiveMarksState = currentState as? GameFiveMarksState {
            player = playerFiveMarksState.player.next
        }
        
        switch gameMode {
        case .TwoPlayers:
            currentState = PlayerInputState(player: player,
                                            markViewPrototype: player.markViewPrototype,
                                            gameViewController: self,
                                            gameboard: gameboard,
                                            gameboardView: gameboardView)
        case .againstTheComputer:
            switch player {
            case .first:
                currentState = PlayerInputState(player: .first,
                                                markViewPrototype: player.markViewPrototype,
                                                gameViewController: self,
                                                gameboard: gameboard,
                                                gameboardView: gameboardView)
            case .second:
                currentState = ComputerInputState(player: .second,
                                                 markViewPrototype: player.markViewPrototype,
                                                 gameViewController: self,
                                                 gameboard: gameboard,
                                                 gameboardView: gameboardView)
            }
        case .fiveMarks:
            currentState = GameFiveMarksState(player: player, markViewPrototype:
                                                player.markViewPrototype,
                                              gameViewController: self,
                                              gameboard: gameboard,
                                              gameboardView: gameboardView)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        guard
            let settingsVC = segue.destination as? SettingsVC
        else { return }
        settingsVC.settingsDelegate = self
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        Log(.restartGame)
        
        gameboard.clear()
        gameboardView.clear()
        gameMode = .TwoPlayers
        goToFirstState()
    }
}

extension GameViewController: GameConfigDelegate {
    func setNewMode(newMode: GameMode) {
        gameMode = newMode
    }
}
