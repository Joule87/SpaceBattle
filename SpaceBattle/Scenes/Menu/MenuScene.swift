//
//  MenuScene.swift
//  SpaceBattle
//
//  Created by Julio Collado on 12/17/19.
//  Copyright © 2019 Julio Collado. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var starField : SKEmitterNode!
    
    var newGameButtonNode: SKSpriteNode!
    var difficultyButtonNode: SKSpriteNode!
    var difficultyLabelNode: SKLabelNode!
    
    let newGameButtonName = "newGameButton"
    let difficultyButtonName = "difficultyButton"
    
    let userDefaults = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        setupStartField()
        setupNewGameButtonNode()
        setupDifficultLabelNode()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        guard let location = touch?.location(in: self) else { return }
        let nodesArray = self.nodes(at: location)
        if nodesArray.first?.name == newGameButtonName {
            let transition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameScene = GameScene(size: self.size)
            self.view?.presentScene(gameScene, transition: transition)
        } else if nodesArray.first?.name == difficultyButtonName {
            changeDifficulty()
        }
        
    }
    
    private func setupNewGameButtonNode() {
        newGameButtonNode = self.childNode(withName: newGameButtonName) as? SKSpriteNode
    }
    
    private func setupStartField() {
        starField = self.childNode(withName: "starField") as? SKEmitterNode
        starField.advanceSimulationTime(10)
    }
    
    private func setupDifficultLabelNode() {
        difficultyButtonNode = self.childNode(withName: difficultyButtonName) as? SKSpriteNode
        difficultyButtonNode.texture = SKTexture(imageNamed: difficultyButtonName)
        
        difficultyLabelNode = self.childNode(withName: "difficultyLabel") as? SKLabelNode
        
        if let gameDifficulty = userDefaults.value(forKey: Constants.UserDefaultKeys.GameDifficulty) as? String {
            difficultyLabelNode.text = gameDifficulty
        } else {
            difficultyLabelNode.text = DifficultyOptions.Easy.description
        }
    }
    
    func changeDifficulty() {
        guard let difficulty = DifficultyOptions(rawValue: difficultyLabelNode.text!) else { return }
        switch difficulty {
        case .Easy:
            difficultyLabelNode.text = DifficultyOptions.Medium.description
            userDefaults.set(DifficultyOptions.Medium.description, forKey: Constants.UserDefaultKeys.GameDifficulty)
        case .Medium:
            difficultyLabelNode.text = DifficultyOptions.Hard.description
            userDefaults.set(DifficultyOptions.Hard.description, forKey: Constants.UserDefaultKeys.GameDifficulty)
        case .Hard:
            difficultyLabelNode.text = DifficultyOptions.Easy.description
            userDefaults.set(DifficultyOptions.Easy.description, forKey: Constants.UserDefaultKeys.GameDifficulty)
        }
    }
    
    
}

