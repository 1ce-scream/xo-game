//
//  PlayerCommand.swift
//  XO-game
//
//  Created by Vitaliy Talalay on 29.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class PlayerCommand {
    private var gameboardView: GameboardView
    private var gameboard: Gameboard
    private var position: GameboardPosition
    private var player: Player
    
    init(gameboardView: GameboardView,
         gameboard: Gameboard,
         position: GameboardPosition,
         player: Player) {
        self.gameboardView = gameboardView
        self.gameboard = gameboard
        self.position = position
        self.player = player
    }
    
    func execute() {
        if gameboardView.canPlaceMarkView(at: position) {
            gameboard.setPlayer(player, at: position)
            gameboardView.placeMarkView(getMarkView(), at: position)
        }
    }
    
    private func getMarkView() -> MarkView {
        switch player {
        case .first:
            return XView()
        case .second:
            return OView()
        }
    }
}
