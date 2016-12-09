//
//  GameShop.swift
//  shootingGame
//
//  Created by Jo-Anna Marie Reyes on 11/18/16.
//  Copyright © 2016 Jo-Anna Marie Reyes. All rights reserved.
//

import Foundation
import SpriteKit

class IntroScene2: SKScene {
    
    var IntroLabel : UILabel!
    var playTheGame : UIButton!
    var homescreenBtn: UIButton!
    
    let backgroundMusic = SKAudioNode(fileNamed: "NewYork.mp3")
    
    
    override func didMove(to view: SKView) {
        //Adding Stars
        if let stars = SKEmitterNode(fileNamed: "movingStars") {
            stars.position = CGPoint(x: frame.size.width / 2, y: frame.size.height)
            stars.zPosition = -1
            addChild(stars)
        }
        //Backgrount color
        scene?.backgroundColor = UIColor.black
        
        //Background Music
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        IntroLabel = UILabel(frame: CGRect(x: 0, y:0, width: view.frame.size.width/1.5, height: 30))
        IntroLabel.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/1.2)
        IntroLabel.textColor = UIColor.red
        IntroLabel.text = "Score as high as you can!"
        self.view?.addSubview(IntroLabel)
        
        homescreenBtn = UIButton (frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        homescreenBtn.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/3)
        
        homescreenBtn.setTitle("Homescreen", for: UIControlState.normal)
        homescreenBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        homescreenBtn.addTarget(self, action: #selector(IntroScene.Homescreen), for: UIControlEvents.touchUpInside)
        self.view!.addSubview(homescreenBtn)
        
        playTheGame = UIButton (frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        playTheGame.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/5)
        
        playTheGame.setTitle("Play", for: UIControlState.normal)
        playTheGame.setTitleColor(UIColor.white, for: UIControlState.normal)
        playTheGame.addTarget(self, action: #selector(IntroScene.Play), for: UIControlEvents.touchUpInside)
        self.view!.addSubview(homescreenBtn)
        self.view!.addSubview(playTheGame)
        
    }
    
    func Homescreen(){
        let scene = GameScene(fileNamed: "GameScene")
        self.view?.presentScene(scene)
        homescreenBtn.removeFromSuperview()
        playTheGame.removeFromSuperview()
        IntroLabel.removeFromSuperview()
    }
    func Play(){
        let scene = SpecialScene(fileNamed: "SpecialScene")
        self.view?.presentScene(scene)
        homescreenBtn.removeFromSuperview()
        playTheGame.removeFromSuperview()
        IntroLabel.removeFromSuperview()
    }
}
