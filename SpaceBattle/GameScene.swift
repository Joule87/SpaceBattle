//
//  GameScene.swift
//  SpaceBattle
//
//  Created by Julio Collado on 12/16/19.
//  Copyright © 2019 Julio Collado. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    var starField: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    let torpedoSoundAction: SKAction = SKAction.playSoundFileNamed("torpedo.mp3", waitForCompletion: false)
    var gameTimer: Timer!
    var attackers = ["meteor","alien"]
    
    let alienCategory: UInt32 = 0x1 << 1
    let torpedoCategory: UInt32 = 0x1 << 0
    
    let motionManager = CMMotionManager()
    var xAcceleration: CGFloat = 0
    
    
    override func didMove(to view: SKView) {
        setupStarField()
        setupPlayer()
        setupPhisicsWord()
        setupScoreLabel()
        setupAliensAndAsteroids()
        setupCoreMotion()
    }
    
    func setupCoreMotion() {
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data: CMAccelerometerData?, error: Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
            }
            
        }
    }
    
    func setupPhisicsWord() {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    func setupStarField() {
        starField = SKEmitterNode(fileNamed: "Starfield")
        
        starField.position = CGPoint(x: 0, y: self.frame.maxY)
        starField.advanceSimulationTime(10)
        addChild(starField)
        starField.zPosition = -1
    }
    
    func setupPlayer() {
        player = SKSpriteNode(imageNamed: "spaceship")
        player.size = CGSize(width: 80, height: 80)
        player.position = CGPoint(x: frame.size.width / 2, y: player.size.height / 2 + 20)
        addChild(player)
    }
    
    func setupScoreLabel() {
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: frame.size.width - 100, y: frame.size.height - 70)
        scoreLabel.fontSize = 25
        scoreLabel.fontName = "AmericanTypewriter-Bold"
        scoreLabel.color = .white
        addChild(scoreLabel)
    }
    
    func setupAliensAndAsteroids() {
        gameTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(addAliensAndAsteroids), userInfo: nil, repeats: true)
    }
    
    @objc func addAliensAndAsteroids() {
        //Shuffled array of attackers
        attackers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: attackers) as! [String]
        let attaker = SKSpriteNode(imageNamed: attackers[0])
        let attakerPosition = GKRandomDistribution(lowestValue: 0, highestValue: Int(frame.size.width))
        let position = CGFloat(attakerPosition.nextInt())
        attaker.size = CGSize(width: 60, height: 60)
        attaker.position = CGPoint(x: position, y: frame.size.height + attaker.size.height)
        attaker.physicsBody = SKPhysicsBody(circleOfRadius: attaker.size.width/2)
        
        attaker.physicsBody?.categoryBitMask = alienCategory
        attaker.physicsBody?.contactTestBitMask = torpedoCategory
        attaker.physicsBody?.collisionBitMask = 0
        
        addChild(attaker)
        
        let animationDuration: TimeInterval = 6
        
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -attaker.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        attaker.run(SKAction.sequence(actionArray))
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireTorpedo()
    }
    
    func fireTorpedo() {
        let torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        torpedoNode.position = player.position
        torpedoNode.position.y += 5
        torpedoNode.size = CGSize(width: 30, height: 30)
        torpedoNode.physicsBody = SKPhysicsBody(circleOfRadius: torpedoNode.size.width/2)
        
        torpedoNode.physicsBody?.categoryBitMask = torpedoCategory
        torpedoNode.physicsBody?.contactTestBitMask = alienCategory
        torpedoNode.physicsBody?.collisionBitMask = 0
        torpedoNode.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(torpedoNode)
        
        let animationDuration = 1.0
        
        var actionArray = [SKAction]()
        actionArray.append(torpedoSoundAction)
        actionArray.append(SKAction.move(to: CGPoint(x: player.position.x, y: frame.size.height + torpedoNode.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        torpedoNode.run(SKAction.sequence(actionArray))
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var torpedoBody: SKPhysicsBody
        var alienBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            torpedoBody = contact.bodyA
            alienBody = contact.bodyB
        } else {
            torpedoBody =  contact.bodyB
            alienBody = contact.bodyA
        }
        if (torpedoBody.categoryBitMask & torpedoCategory) != 0 && (alienBody.categoryBitMask & alienCategory) != 0 {
            torpedoDidCollideWithAlien(torpedoNode: torpedoBody.node as! SKSpriteNode, alienNode: alienBody.node as! SKSpriteNode)
        }
        
    }
    
    func torpedoDidCollideWithAlien(torpedoNode: SKSpriteNode, alienNode: SKSpriteNode) {
        let explosion = SKEmitterNode(fileNamed: "Explosion")!
        explosion.position = alienNode.position
        addChild(explosion)
        
        run(SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false))
        
        torpedoNode.removeFromParent()
        alienNode.removeFromParent()
        
        run(SKAction.wait(forDuration: 1)) {
            explosion.removeFromParent()
        }
        score += 5
    }
    
    override func didSimulatePhysics() {
        player.position.x += xAcceleration * 50
        if player.position.x < -40 {
            player.position = CGPoint(x: CGFloat(frame.size.width), y: player.position.y)
        } else if player.position.x > frame.size.width  + 40 {
            player.position = CGPoint(x: -CGFloat(40), y: player.position.y)
        }
    }
}
