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
    var homescreenBtn: UIButton!
    var GameOverLabel: UILabel!
    var Highscore : Int!
    var ScoreLabel : UILabel!
    var HighScoreLabel : UILabel!
    
    override func didMove(to view: SKView) {
        scene?.backgroundColor = UIColor.white
        
        GameOverLabel = UILabel(frame:CGRect(x: 0, y:0, width: view.frame.size.width/2, height: 30))
        GameOverLabel.textColor = UIColor.red
        GameOverLabel.font = UIFont.boldSystemFont(ofSize: 32.0)
        GameOverLabel.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/5)
        GameOverLabel.text = "Game Over!"
        self.view?.addSubview(GameOverLabel)
        
        restartBtn = UIButton (frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        restartBtn.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/2)
        
        restartBtn.setTitle("Restart", for: UIControlState.normal)
        restartBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        restartBtn.addTarget(self, action: #selector(EndScene.Restart), for: UIControlEvents.touchUpInside)
        self.view!.addSubview(restartBtn)
        
        homescreenBtn = UIButton (frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        homescreenBtn.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/3)
        
        homescreenBtn.setTitle("Homescreen", for: UIControlState.normal)
        homescreenBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        homescreenBtn.addTarget(self, action: #selector(EndScene.Homescreen), for: UIControlEvents.touchUpInside)
        self.view!.addSubview(homescreenBtn)
        
        let scoreDefault = UserDefaults.standard
        let Score = scoreDefault.value(forKey: "Score") as! Int
        
        let HighscoreDefault = UserDefaults.standard
        Highscore = HighscoreDefault.value(forKey: "Highscore") as! Int
        
        ScoreLabel = UILabel(frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        ScoreLabel.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/1.2)
        ScoreLabel.text = "Your score: \(Score)"
        self.view?.addSubview(ScoreLabel)
        
        HighScoreLabel = UILabel(frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        HighScoreLabel.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/1)
        HighScoreLabel.text = "Highscore: \(Highscore!)"
        self.view?.addSubview(HighScoreLabel)
    }
    
    func Restart(){
        //Fixed restart issue, but rocket is zoomed in once first restart is pressed
        let scene = GameScene1(fileNamed: "GameScene1")
        self.view?.presentScene(scene)
        GameOverLabel.removeFromSuperview()
        homescreenBtn.removeFromSuperview()
        restartBtn.removeFromSuperview()
        HighScoreLabel.removeFromSuperview()
        ScoreLabel.removeFromSuperview()
    }
    
    func Homescreen(){
        let scene = GameScene(fileNamed: "GameScene")
        self.view?.presentScene(scene)
        GameOverLabel.removeFromSuperview()
        homescreenBtn.removeFromSuperview()
        restartBtn.removeFromSuperview()
        HighScoreLabel.removeFromSuperview()
        ScoreLabel.removeFromSuperview()
    }
}
