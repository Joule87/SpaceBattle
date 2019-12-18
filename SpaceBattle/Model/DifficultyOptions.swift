//
//  DifficultyOptions.swift
//  SpaceBattle
//
//  Created by Julio Collado on 12/17/19.
//  Copyright © 2019 Julio Collado. All rights reserved.
//

import Foundation

enum DifficultyOptions: String, CaseIterable {
    case Easy, Medium, Hard
    
    var description: String {
        switch self {
        case .Easy:
            return "Easy"
        case .Medium:
            return "Medium"
        case .Hard:
            return "Hard"
        }
    }
}
