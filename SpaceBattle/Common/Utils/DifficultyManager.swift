//
//  DifficultyManager.swift
//  SpaceBattle
//
//  Created by Julio Collado on 12/17/19.
//  Copyright © 2019 Julio Collado. All rights reserved.
//

import Foundation

class DifficultyManager {
    
    var difficulty: DifficultyOptions {
        if let difficulty = UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.GameDifficulty) as? String, let difficultyOption = DifficultyOptions(rawValue: difficulty) {
            return difficultyOption
        } else {
            return .Easy
        }
    }
    
    func getAlienAparitionInterval() -> TimeInterval {
        switch difficulty {
        case .Easy:
            return 0.75
        case .Medium:
            return 0.50
        case .Hard:
            return 0.30
        }
    }
    
    func getAlienAnimationDutationInterval() -> TimeInterval {
        switch difficulty {
        case .Easy:
            return 6
        case .Medium:
            return 4.50
        case .Hard:
            return 3
        }
    }
    
}
