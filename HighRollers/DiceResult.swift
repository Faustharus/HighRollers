//
//  DiceResult.swift
//  HighRollers
//
//  Created by Damien Chailloleau on 06/08/2024.
//

import Foundation

struct DiceResult: Identifiable, Codable {
    
    var id = UUID()
    var type: Int
    var numbers: Int
    var rolls = [Int]()
    
    init(type: Int, numbers: Int) {
        self.type = type
        self.numbers = numbers
        
        for _ in 0 ..< numbers {
            let roll = Int.random(in: 1...type)
            rolls.append(roll)
        }
    }
    
    #if DEBUG
    static let example: DiceResult = DiceResult(type: 4, numbers: 1)
    #endif
}
