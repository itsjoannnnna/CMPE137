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

struct PhysicsCategory{
    static let Aliens: UInt32 = 1 //lets the last bit equal to 1
    static let Bullet: UInt32 = 2 // lets the last bits equal to 2
    static let Player: UInt32 = 3 //lets the last bits equal to 3
}

class GameScene1: SKScene, SKPhysicsContactDelegate {
    
    var HighScore = Int()
    var LevelLabel = UILabel!
    var Score = Int()
    var Level = Int()
//    var pauseButton: SKSpriteNode?
    var pause = SKSpriteNode(imageNamed:"pause.jpg")
    var play = SKSpriteNode(imageNamed: "play.jpg")
//    var playButton: SKSpriteNode?
    let backgroundMusic = SKAudioNode(fileNamed: "NewYork.mp3")
    
    var Player = SKSpriteNode(imageNamed: "rocket1.png")
    
    var ScoreLabel = UILabel()
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        //Background Music
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
//        playButton = childNode(withName: "playButton") as? SKSpriteNode
//        playButton?.isHidden = true
//        pauseButton = childNode(withName: "pauseButton") as? SKSpriteNode
        
        let HighscoreDefault = UserDefaults.standard
        if (HighscoreDefault.value(forKey: "Highscore") != nil){
            HighScore = HighscoreDefault.value(forKey: "Highscore") as! Int //as! NSInteger
        }
        else{
            HighScore = 0
        }
        
        physicsWorld.contactDelegate = self
        
        //play/pause button position
        play.position = CGPoint(x: self.size.width/12, y:self.frame.size.height/7)
        play.isHidden = true
        pause.position = CGPoint(x: self.size.width/12, y:self.frame.size.height/7)
        
        //background color for the playing field
        self.scene?.backgroundColor = UIColor.white
        
        //positioning of the player in the field. makes it stay at the bottom of the string
        Player.position = CGPoint(x: self.size.width/12, y: self.frame.size.height/7.5)
        Player.physicsBody = SKPhysicsBody(rectangleOf: Player.size)
        Player.physicsBody?.affectedByGravity = false
        
        Player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        Player.physicsBody?.contactTestBitMask = PhysicsCategory.Aliens
        Player.physicsBody?.isDynamic = false
        
        //increasing the amount of time the bullets will come out of the rocket ship
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.shootBullets), userInfo: nil, repeats: true)
        
        if(Score <= 40){
            _ = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.shootBullets), userInfo: nil, repeats: true)
        }
        
        if(Score <= 100){
            _ = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(self.shootBullets), userInfo: nil, repeats: true)
        }
        if(Score <= 160){
            _ = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(self.shootBullets), userInfo: nil, repeats: true)
        }
        
        if(Score <= 220){
            _ = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(self.shootBullets), userInfo: nil, repeats: true)
        }
        
        //increase more enemies at any certain time, decrease time intervals < 1.0
        _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.shootAlienEnemies), userInfo: nil, repeats: true)
        self.addChild(Player)
        
        //adds the score label to the top of the screen
        ScoreLabel.text = "\(Score)"
        ScoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        ScoreLabel.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.3)
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
            ScoreLabel.text = "Score: \(Score)"
//            playButton?.removeFromParent()
//            pauseButton?.removeFromParent()
            
            play.removeFromParent()
            pause.removeFromParent()

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
//            playButton?.removeFromParent()
//            pauseButton?.removeFromParent()
            
            play.removeFromParent()
            pause.removeFromParent()
        }
    }
    
    //function to shoot the bullets from behind the rocketship
    func shootBullets(){
        let Bullet = SKSpriteNode(imageNamed: "bullet.png")
        Bullet.zPosition = -5
        Bullet.position = CGPoint(x: Player.position.x, y: Player.position.y)
        
        let shooting = SKAction.moveTo(y: self.size.height + 30, duration: 1.0)
        let shootingDone = SKAction.removeFromParent()
        Bullet.run(SKAction.sequence([shooting, shootingDone]))
        //Bullet.run(SKAction.repeatForever(shooting))
        
        Bullet.physicsBody = SKPhysicsBody(rectangleOf: Bullet.size)
        Bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        Bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Aliens //bullets go away from the
        Bullet.physicsBody?.affectedByGravity = false // so the bullets don't fly off
        Bullet.physicsBody?.isDynamic = false
        self.addChild(Bullet)
    }
    
    func goToNextLevel(){
        if(Score > 0 && Score < 19){
            Level = 1
        }
        if(Score <= 20){
            Level = 2
        }
        if(Score <= 40){
            Level = 3
        }
        if(Score <= 60){
            Level = 4
        }
        if(Score <= 80){
            Level = 5
        }
        if(Score <= 100){
            Level = 6
        }
        if(Score <= 120){
            Level = 7
        }
        if(Score <= 140){
            Level = 8
        }
        if(Score <= 160){
            Level = 9
        }
        if(Score <= 180){
            Level = 10
        }
        if(Score <= 200){
            Level = 11
        }
        if(Score <= 220){
            Level = 12
        }
        
        LevelLabel = UILabel(frame:CGRect(x: 0, y:0, width: view!.frame.size.width/2, height: 30))
        LevelLabel?.textColor = UIColor.red
        LevelLabel.font = UIFont.boldSystemFont(ofSize: 32.0)
        LevelLabel.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/5)
        LevelLabel.text = "Level \(Level)"
        self.view?.addSubview(GameOverLabel)
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
        //LEVEL 2
        if (Score >= 20){
            let fallFromSky = SKAction.moveTo(y: -self.frame.size.height, duration: 7.5)
            Aliens.run(SKAction.repeatForever(fallFromSky))
        }
        if(Score >= 40){
            let fallFromSky = SKAction.moveTo(y: -self.frame.size.height, duration: 7.0)
            Aliens.run(SKAction.repeatForever(fallFromSky))
        }
        if (Score >= 60){
            let fallFromSky = SKAction.moveTo(y: -self.frame.size.height, duration: 6.5)
            Aliens.run(SKAction.repeatForever(fallFromSky))
        }
        if(Score >= 80){
            let fallFromSky = SKAction.moveTo(y: -self.frame.size.height, duration: 6.0)
            Aliens.run(SKAction.repeatForever(fallFromSky))
        }
        //LEVEL 6
        if (Score >= 100){
            let fallFromSky = SKAction.moveTo(y: -self.frame.size.height, duration: 5.5)
            Aliens.run(SKAction.repeatForever(fallFromSky))
        }
        if(Score >= 120){
            let fallFromSky = SKAction.moveTo(y: -self.frame.size.height, duration: 5.0)
            Aliens.run(SKAction.repeatForever(fallFromSky))
        }
        if (Score >= 140){
            let fallFromSky = SKAction.moveTo(y: -self.frame.size.height, duration: 4.5)
            Aliens.run(SKAction.repeatForever(fallFromSky))
        }
        if(Score >= 160){
            let fallFromSky = SKAction.moveTo(y: -self.frame.size.height, duration: 4.0)
            Aliens.run(SKAction.repeatForever(fallFromSky))
        }
        if(Score >= 180){
            let fallFromSky = SKAction.moveTo(y: -self.frame.size.height, duration: 3.5)
            Aliens.run(SKAction.repeatForever(fallFromSky))
        }
        if (Score >= 200){
            let fallFromSky = SKAction.moveTo(y: -self.frame.size.height, duration: 3.0)
            Aliens.run(SKAction.repeatForever(fallFromSky))
        }
        //LEVEL 12
        if(Score >= 220){
            let fallFromSky = SKAction.moveTo(y: -self.frame.size.height, duration: 2.5)
            Aliens.run(SKAction.repeatForever(fallFromSky))
        }
        //Regular level
        let fallFromSky = SKAction.moveTo(y: -self.frame.size.height, duration: 8.0)
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
        let nodes = self.atPoint(touchLocation)
        if nodes.name == "pause"{
            let showPlayButtonAction = SKAction.run(showPlayButton)
            let pauseGameAction = SKAction.run(pauseGame)
            let pauseSequence = SKAction.sequence([showPlayButtonAction, pauseGameAction])
            run(pauseSequence)
            
        }
        else if nodes.name == "play"{
            self.resumeGame()
        }

//        let nodes = self.atPoint(touchLocation)
//        if nodes.name == "pauseButton" {
//            let showPlayButtonAction = SKAction.run(showPlayButton)
//            let pauseGameAction = SKAction.run(pauseGame)
//            let pauseSequence = SKAction.sequence([showPlayButtonAction, pauseGameAction])
//            run(pauseSequence)
//            
//        }
//        else if nodes.name == "playButton"{
//            self.resumeGame()
//        }
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
        play.isHidden = true
        pause.isHidden = false
        self.view?.isPaused = false
//        playButton!.isHidden = true
//        pauseButton!.isHidden = false
//        self.view?.isPaused = false
    }
    
    func showPlayButton() {
        pause.isHidden = true
        play.isHidden = false
//        pauseButton!.isHidden = true
//        playButton!.isHidden = false
    }
}
