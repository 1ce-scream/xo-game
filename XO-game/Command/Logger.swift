//
//  Logger.swift
//  XO-game
//
//  Created by Vitaliy Talalay on 29.12.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

final class Logger {
    func writeMessageToLog(_ message: String) {
        /// Здесь должна быть реализация записи сообщения в лог.
        /// Для простоты примера паттерна не вдаемся в эту реализацию,
        /// а просто печатаем текст в консоль.
        print(message)
    }
}
