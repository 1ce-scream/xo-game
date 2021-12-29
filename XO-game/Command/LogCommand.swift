//
//  LogCommand.swift
//  XO-game
//
//  Created by Vitaliy Talalay on 29.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

final class LogCommand {
    let action: LogAction
    
    init(action: LogAction) {
        self.action = action
    }
    
    var logMessage: String {
        switch action {
        case let .playerInput(player, position):
            return "\(player) placed mark at \(position)"
        case let .gameFinished(winner):
            if let winner = winner {
                return "\(winner) win game"
            } else {
                return "game finished with no winner"
            }
        case .restartGame:
            return "game restarted"
        }
    }
}
