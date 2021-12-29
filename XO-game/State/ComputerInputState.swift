//
//  GameComputerState.swift
//  XO-game
//
//  Created by Vitaliy Talalay on 29.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class ComputerInputState: GameState {
    public private(set) var isCompleted = false
    public let markViewPrototype: MarkView
    
    public let player: Player
    private var nextPosition: GameboardPosition?
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    
    init(player: Player,
         markViewPrototype: MarkView,
         gameViewController: GameViewController,
         gameboard: Gameboard,
         gameboardView: GameboardView) {
        self.player = player
        self.markViewPrototype = markViewPrototype
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }
    
    public func begin() {
        switch player {
        case .first:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        gameViewController?.winnerLabel.isHidden = true
        
        guard let position = getNextFreePosition() else { return }
        nextPosition = position
        gameboardView?.onSelectPosition?(position)
    }
    
    func addMark(at position: GameboardPosition) {
        guard let position = nextPosition else { return }
        Log(.playerInput(player: player, position: position))
        gameboard?.setPlayer(player, at: position)
        gameboardView?.placeMarkView(markViewPrototype.copy(), at: position)
        isCompleted = true
    }
    
    private func getNextFreePosition() -> GameboardPosition? {
        guard let gameboardView = gameboardView else { return nil }
        for column in 0 ..< GameboardSize.columns {
            for row in 0 ..< GameboardSize.rows {
                let position = GameboardPosition(column: column, row: row)
                if gameboardView.canPlaceMarkView(at: position) {
                    return position
                }
            }
        }
        return nil
    }
}
