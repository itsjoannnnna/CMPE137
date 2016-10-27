//
//  EndScene.swift
//  shootingGame
//
//  Created by Jo-Anna Marie Reyes on 10/20/16.
//  Copyright © 2016 Jo-Anna Marie Reyes. All rights reserved.
//

import Foundation
import SpriteKit

class EndScene : SKScene {
    
    var restartBtn : UIButton!
    var Highscore : Int!
    var ScoreLabel : UILabel!
    var HighScoreLabel : UILabel!
    
    override func didMove(to view: SKView) {
        scene?.backgroundColor = UIColor.white
        restartBtn = UIButton (frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        restartBtn.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/7)
        
        restartBtn.setTitle("Restart", for: UIControlState.normal)
        restartBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        restartBtn.addTarget(self, action: #selector(EndScene.Restart), for: UIControlEvents.touchUpInside)
        self.view!.addSubview(restartBtn)
        
        let scoreDefault = UserDefaults.standard
        let Score = scoreDefault.value(forKey: "Score") as! Int
        
        let HighscoreDefault = UserDefaults.standard
        Highscore = HighscoreDefault.value(forKey: "Highscore") as! Int
        
        ScoreLabel = UILabel(frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        ScoreLabel.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/4)
        ScoreLabel.text = "Your score: \(Score)"
        self.view?.addSubview(ScoreLabel)
        
        HighScoreLabel = UILabel(frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        HighScoreLabel.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/2)
        HighScoreLabel.text = "Highscore: \(Highscore!)"
        self.view?.addSubview(HighScoreLabel)
    }
    
    func Restart(){
        //Fixed restart issue, but rocket is zoomed in once first restart is pressed
        let scene = GameScene(fileNamed: "GameScene")
        self.view?.presentScene(scene)
        restartBtn.removeFromSuperview()
        HighScoreLabel.removeFromSuperview()
        ScoreLabel.removeFromSuperview()
    }
}
