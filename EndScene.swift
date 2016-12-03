//
//  EndScene.swift
//  shootingGame
//
//  Created by Jo-Anna Marie Reyes on 10/20/16.
//  Copyright © 2016 Jo-Anna Marie Reyes. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import GameplayKit

class EndScene : SKScene {
    
    //var restartBtn : UIButton!
    var homescreenBtn: UIButton!
    var GameOverLabel: UILabel!
    var Highscore : Int!
    var ScoreLabel : UILabel!
    var HighScoreLabel : UILabel!
    
    override func didMove(to view: SKView) {
        //Adding Stars
        if let stars = SKEmitterNode(fileNamed: "movingStars") {
            stars.position = CGPoint(x: frame.size.width / 2, y: frame.size.height)
            stars.zPosition = -1
            addChild(stars)
        }
        //Backgrount color
        scene?.backgroundColor = UIColor.black
        
        GameOverLabel = UILabel(frame:CGRect(x: 40, y:0, width: view.frame.size.width/1.6, height: 30))
        GameOverLabel.textColor = UIColor.red
        GameOverLabel.font = UIFont.boldSystemFont(ofSize: 40.0)
        GameOverLabel.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/5)
        GameOverLabel.text = "Game Over!"
        self.view?.addSubview(GameOverLabel)
        
        
        let gameOverLabel = SKSpriteNode(imageNamed: "gameover.png")
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY+250)
        addChild(gameOverLabel)
        
        homescreenBtn = UIButton (frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        homescreenBtn.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/3)
        
        homescreenBtn.setTitle("Homescreen", for: UIControlState.normal)
        homescreenBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        homescreenBtn.addTarget(self, action: #selector(EndScene.Homescreen), for: UIControlEvents.touchUpInside)
        self.view!.addSubview(homescreenBtn)
        
        let scoreDefault = UserDefaults.standard
        let Score = scoreDefault.value(forKey: "Score") as! Int
        
        let HighscoreDefault = UserDefaults.standard
        Highscore = HighscoreDefault.value(forKey: "Highscore") as! Int
        
        ScoreLabel = UILabel(frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        ScoreLabel.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/1.2)
        ScoreLabel.textColor = UIColor.white
        ScoreLabel.text = "Your score: \(Score)"
        self.view?.addSubview(ScoreLabel)
        
        HighScoreLabel = UILabel(frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        HighScoreLabel.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/1)
        HighScoreLabel.textColor = UIColor.white
        HighScoreLabel.text = "Highscore: \(Highscore!)"
        self.view?.addSubview(HighScoreLabel)
    }
    
    func Homescreen(){
        let scene = GameScene(fileNamed: "GameScene")
        self.view?.presentScene(scene)
        GameOverLabel.removeFromSuperview()
        homescreenBtn.removeFromSuperview()
        //restartBtn.removeFromSuperview()
        HighScoreLabel.removeFromSuperview()
        ScoreLabel.removeFromSuperview()
    }
}
