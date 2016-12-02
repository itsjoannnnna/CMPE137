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
    var returnBtn : UIButton!
    
    override func didMove(to view: SKView) {
        //Backgrount color
        scene?.backgroundColor = UIColor.white
        
        let GameShopTitleLabel = SKSpriteNode(imageNamed: "shop.png")
        GameShopTitleLabel.position = CGPoint(x: frame.midX, y: frame.midY+250)
        addChild(GameShopTitleLabel)
        
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
        returnBtn.removeFromSuperview()
        
    }
}
