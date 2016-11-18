//
//  GameShop.swift
//  shootingGame
//
//  Created by Jo-Anna Marie Reyes on 11/18/16.
//  Copyright © 2016 Jo-Anna Marie Reyes. All rights reserved.
//

import Foundation
import SpriteKit


class GameShop: SKScene {
    
    var TestingLabel : UILabel!
    var returnBtn : UIButton!
    
    override func didMove(to view: SKView) {
        //Backgrount color
        scene?.backgroundColor = UIColor.white
        
        //Label for Shop
        TestingLabel = UILabel(frame:CGRect(x: 0, y:0, width: view.frame.size.width/2, height: 30))
        TestingLabel.textColor = UIColor.red
        TestingLabel.font = UIFont.boldSystemFont(ofSize: 32.0)
        TestingLabel.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/5)
        TestingLabel.text = "Shop!"
        self.view?.addSubview(TestingLabel)
        
        
        //Return button for going back to HomeScreen
        returnBtn = UIButton (frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        returnBtn.center = CGPoint(x: view.frame.midX-160, y: view.frame.midY-350)
        
        returnBtn.setTitle("Return", for: UIControlState.normal)
        returnBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        returnBtn.addTarget(self, action: #selector(GameShop.Return), for: UIControlEvents.touchUpInside)
        self.view!.addSubview(returnBtn)
    }
    
    //Return function to redirect scene to HomeScreen
    func Return(){
        //move to specified scene
        let scene = GameScene(fileNamed: "GameScene")
        //starting transition between scenes
        self.view?.presentScene(scene)
        TestingLabel.removeFromSuperview()
        returnBtn.removeFromSuperview()
        
    }
}
