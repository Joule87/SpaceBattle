//
//  GameOver.swift
//  SpaceBattle
//
//  Created by Julio Collado on 12/18/19.
//  Copyright © 2019 Julio Collado. All rights reserved.
//

import SpriteKit

class GameOver: SKScene {
    
    var starField: SKEmitterNode!
    var scoreNumberLabel: SKLabelNode!
    var newGameButtonNode: SKSpriteNode!
    
    var score: Int = 0
    
    override func didMove(to view: SKView) {
        setupStarField()
        setupScoreNumberLabel()
        setupNewGameButton()
    }
    
    func setupStarField() {
        starField = self.childNode(withName: "starField") as? SKEmitterNode
        starField.advanceSimulationTime(10)
    }
    
    func setupScoreNumberLabel() {
        scoreNumberLabel = self.childNode(withName: "scoreNumberLabel") as? SKLabelNode
        scoreNumberLabel.text = "\(score)"
    }
    
    func setupNewGameButton() {
        newGameButtonNode = self.childNode(withName: "newGameButton") as? SKSpriteNode
        newGameButtonNode.texture = SKTexture(imageNamed: "newGameButton")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self) else { return }
        let node = nodes(at: location)
        if node[0].name == "newGameButton" {
            let transition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameScene = GameScene(size: self.size)
            self.view?.presentScene(gameScene, transition: transition)
        }
    }
    
}
