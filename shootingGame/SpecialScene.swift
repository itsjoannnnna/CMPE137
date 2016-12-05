//
//  GameScene.swift
//  shootingGame
//
//  Created by Jo-Anna Marie Reyes on 10/14/16.
//  Copyright © 2016 Jo-Anna Marie Reyes. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

struct SpecialScenePhysicsCategory{
    static let Aliens: UInt32 = 1 //lets the last bit equal to 1
    static let Bullet: UInt32 = 2 // lets the last bits equal to 2
    static let Player: UInt32 = 3 //lets the last bits equal to 3
}

class SpecialScene: SKScene, SKPhysicsContactDelegate {
    
    var HighScore = Int()
    var Score = Int()
    var Level = Int()
    
    var timeIntervalForBullet : TimeInterval = 0.2
    var timeIntervalForAliens : TimeInterval = 0.1
    var timeIntervalForShootingAliens :TimeInterval = 8.0
    
    var pauseButton: SKSpriteNode?
    var playButton: SKSpriteNode?
    let backgroundMusic = SKAudioNode(fileNamed: "NewYork.mp3")
    
    var Player = SKSpriteNode(imageNamed: "rocket1.png")
    
    var ScoreLabel = UILabel()
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        self.scene?.backgroundColor = UIColor.black
        
        //Adding Stars
        if let stars = SKEmitterNode(fileNamed: "movingStars") {
            stars.position = CGPoint(x: frame.size.width / 2, y: frame.size.height)
            stars.zPosition = -1
            addChild(stars)
        }
        
        //Background Music
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        playButton = childNode(withName: "playButton") as? SKSpriteNode
        playButton?.isHidden = true
        pauseButton = childNode(withName: "pauseButton") as? SKSpriteNode
        
        let HighscoreDefault = UserDefaults.standard
        if (HighscoreDefault.value(forKey: "Highscore") != nil){
            HighScore = HighscoreDefault.value(forKey: "Highscore") as! Int //as! NSInteger
        }
        else{
            HighScore = 0
        }
        
        physicsWorld.contactDelegate = self
        
        //positioning of the player in the field. makes it stay at the bottom of the string
        Player.position = CGPoint(x: self.size.width/12, y: self.frame.size.height/7.5)
        Player.physicsBody = SKPhysicsBody(rectangleOf: Player.size)
        Player.physicsBody?.affectedByGravity = false
        
        Player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        Player.physicsBody?.contactTestBitMask = PhysicsCategory.Aliens
        Player.physicsBody?.isDynamic = false
        
        //increasing the amount of time the bullets will come out of the rocket ship
        _ = Timer.scheduledTimer(timeInterval: timeIntervalForAliens, target: self, selector: #selector(self.shootBullets), userInfo: nil, repeats: true)
        
        //increase more enemies at any certain time, decrease time intervals < 1.0
        _ = Timer.scheduledTimer(timeInterval: timeIntervalForBullet, target: self, selector: #selector(self.shootAlienEnemies), userInfo: nil, repeats: true)
        self.addChild(Player)
        
        //adds the score label to the top of the screen
        ScoreLabel.text = "\(Score)"
        ScoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        ScoreLabel.textColor = UIColor.red
        ScoreLabel.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.3)
        ScoreLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        self.view?.addSubview(ScoreLabel)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody = contact.bodyA //takes first body that hits and do stuff with it
        let secondBody: SKPhysicsBody = contact.bodyB //takes second body that hits
        
        //checks if the bullets have hit the aliens or aliens hit bullets
        if((firstBody.categoryBitMask == PhysicsCategory.Aliens && secondBody.categoryBitMask == PhysicsCategory.Bullet) || (firstBody.categoryBitMask == PhysicsCategory.Bullet && secondBody.categoryBitMask == PhysicsCategory.Aliens)){
            
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            Score+=1
            if Score % 20 == 0{
                timeIntervalForBullet = timeIntervalForBullet + 0.1
                timeIntervalForAliens = timeIntervalForAliens - 0.1
                timeIntervalForShootingAliens = timeIntervalForShootingAliens - 0.5
            }
            updateLevelLabel()
            ScoreLabel.text = "Score: \(Score)"
        }
            
            //checks if the alien hit the players, or player hits an alien
        else if((firstBody.categoryBitMask == PhysicsCategory.Aliens && secondBody.categoryBitMask == PhysicsCategory.Player) || (firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.Aliens)){
            
            let scoreDefault = UserDefaults.standard
            scoreDefault.set(Score, forKey: "Score")
            scoreDefault.synchronize()
            if(Score > HighScore){
                let HighscoreDefault = UserDefaults.standard
                HighscoreDefault.set(Score, forKey: "Highscore")
            }
            
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            self.view?.presentScene(EndScene())
            ScoreLabel.removeFromSuperview()
            playButton?.removeFromParent()
            pauseButton?.removeFromParent()
            
            //            play.removeFromParent()
            //            pause.removeFromParent()
        }
    }
    
    //updates the levels on the top of the playing field
    func updateLevelLabel(){
        if(Score >= 0 && Score <= 20){
            Level = 1
        }
        if(Score > 20 && Score <= 40){
            Level = 2
        }
        if(Score > 40 && Score <= 60){
            Level = 3
        }
        if(Score > 60 && Score <= 80){
            Level = 4
        }
        if(Score > 80 && Score <= 100){
            Level = 5
        }
        if(Score > 100 && Score <= 120){
            Level = 6
        }
        if(Score > 120 && Score <= 140){
            Level = 7
        }
        if(Score > 140 && Score <= 160){
            Level = 8
        }
        if(Score > 160 && Score <= 180){
            Level = 9
        }
        if(Score > 180 && Score <= 200){
            Level = 10
        }
        if(Score > 200 && Score <= 220){
            Level = 11
        }
        if(Score > 220 && Score <= 240){
            Level = 12
        }
    }
    
    //function to shoot the bullets from behind the rocketship
    func shootBullets(){
        let Bullet = SKSpriteNode(imageNamed: "new_bullet.png")
        Bullet.zPosition = -5
        Bullet.position = CGPoint(x: Player.position.x, y: Player.position.y)
        
        let shooting = SKAction.moveTo(y: self.size.height + 30, duration: 1.0)
        let shootingDone = SKAction.removeFromParent()
        Bullet.run(SKAction.sequence([shooting, shootingDone]))
        
        Bullet.physicsBody = SKPhysicsBody(rectangleOf: Bullet.size)
        Bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        Bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Aliens
        Bullet.physicsBody?.affectedByGravity = false
        Bullet.physicsBody?.isDynamic = false
        self.addChild(Bullet)
    }
    
    //function where aliens are falling from the sky
    func shootAlienEnemies(){
        let Aliens = SKSpriteNode(imageNamed: "alien.png")
        let minValue = self.size.width/(-20)
        NSLog("Min: \(minValue)")
        let maxValue = self.size.width - 50
        NSLog("Max: \(maxValue)")
        
        let spawnPoint = UInt32(maxValue - minValue)
        Aliens.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)), y: self.size.height)
        
        //for the levels, we can decrease the duration to make it faster
        //Regular level
        let fallFromSky = SKAction.moveTo(y: -self.frame.size.height, duration: timeIntervalForShootingAliens)
        Aliens.run(SKAction.repeatForever(fallFromSky))
        
        Aliens.physicsBody = SKPhysicsBody(rectangleOf: Aliens.size)
        Aliens.physicsBody?.categoryBitMask = PhysicsCategory.Aliens
        Aliens.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
        Aliens.physicsBody?.affectedByGravity = false
        Aliens.physicsBody?.isDynamic = true
        
        let fallFromSkyDone = SKAction.removeFromParent()
        Aliens.run(SKAction.sequence([fallFromSky, fallFromSkyDone]))
        
        self.addChild(Aliens)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let location = touch.location(in: self)
            Player.position.x = location.x
        }
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        //print(touchLocation)
        
        //play and pause
        //        let nodes = self.atPoint(touchLocation)
        //        if nodes.name == "pause"{
        //            let showPlayButtonAction = SKAction.run(showPlayButton)
        //            let pauseGameAction = SKAction.run(pauseGame)
        //            let pauseSequence = SKAction.sequence([showPlayButtonAction, pauseGameAction])
        //            run(pauseSequence)
        //
        //        }
        //        else if nodes.name == "play"{
        //            self.resumeGame()
        //        }
        
        let nodes = self.atPoint(touchLocation)
        if nodes.name == "pauseButton" {
            let showPlayButtonAction = SKAction.run(showPlayButton)
            let pauseGameAction = SKAction.run(pauseGame)
            let pauseSequence = SKAction.sequence([showPlayButtonAction, pauseGameAction])
            run(pauseSequence)
            
        }
        else if nodes.name == "playButton"{
            self.resumeGame()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let location = touch.location(in: self)
            Player.position.x = location.x
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func pauseGame() {
        self.view!.isPaused = true
    }
    
    func resumeGame() {
        //        play.isHidden = true
        //        pause.isHidden = false
        //        self.view?.isPaused = false
        playButton!.isHidden = true
        pauseButton!.isHidden = false
        self.view?.isPaused = false
    }
    
    func showPlayButton() {
        //        pause.isHidden = true
        //        play.isHidden = false
        pauseButton!.isHidden = true
        playButton!.isHidden = false
    }
}
