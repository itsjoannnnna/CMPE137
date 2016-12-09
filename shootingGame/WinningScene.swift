//
//  WinningScene.swift
//  shootingGame
//
//  Created by Jo-Anna Marie Reyes on 12/7/16.
//  Copyright © 2016 Jo-Anna Marie Reyes. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import GameplayKit

class WinningScene : SKScene {
    var homescreenBtn: UIButton!
    var GameOverLabel: UILabel!
    var Highscore : Int!
    var ScoreLabel : UILabel!
    var HighScoreLabel : UILabel!
    
    override func didMove(to view: SKView) {
        
        self.scene?.backgroundColor = UIColor.black
        
        //Adding Stars
        if let stars = SKEmitterNode(fileNamed: "movingStars") {
            stars.position = CGPoint(x: frame.size.width / 2, y: frame.size.height)
            stars.zPosition = -1
            addChild(stars)
        }
        
        let CongratsTitleLabel = SKSpriteNode(imageNamed: "winning1.png")
        CongratsTitleLabel.position = CGPoint(x: frame.midX, y: frame.midY+250)
        addChild(CongratsTitleLabel)
        
        let YouWonTitleLabel = SKSpriteNode(imageNamed: "youwon1.png")
        YouWonTitleLabel.position = CGPoint(x: frame.midX, y: frame.midY+200)
        addChild(YouWonTitleLabel)
        
        homescreenBtn = UIButton (frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        homescreenBtn.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/1.5)
        
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
        ScoreLabel.textColor = UIColor.red
        ScoreLabel.text = "Your score: 335"
        self.view?.addSubview(ScoreLabel)
        
        HighScoreLabel = UILabel(frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        HighScoreLabel.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/1)
        HighScoreLabel.textColor = UIColor.red
        HighScoreLabel.text = "Highscore: \(Highscore!)"
        self.view?.addSubview(HighScoreLabel)
    }
    
    func Homescreen(){
        let scene = GameScene(fileNamed: "GameScene")
        self.view?.presentScene(scene)
        homescreenBtn.removeFromSuperview()
        HighScoreLabel.removeFromSuperview()
        ScoreLabel.removeFromSuperview()
    }
}
