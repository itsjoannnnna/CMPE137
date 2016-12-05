//
//  GameShop.swift
//  shootingGame
//
//  Created by Jo-Anna Marie Reyes on 11/18/16.
//  Copyright © 2016 Jo-Anna Marie Reyes. All rights reserved.
//

import Foundation
import SpriteKit

class MoreInfoScene: SKScene {
    var returnBtn : UIButton!
    
    override func didMove(to view: SKView) {
        //Backgrount color
        //Adding Stars
        if let stars = SKEmitterNode(fileNamed: "movingStars") {
            stars.position = CGPoint(x: frame.size.width / 2, y: frame.size.height)
            stars.zPosition = -1
            addChild(stars)
        }
        //Backgrount color
        scene?.backgroundColor = UIColor.black
        
        let GameShopTitleLabel = SKSpriteNode(imageNamed: "shop.png")
        GameShopTitleLabel.position = CGPoint(x: frame.midX, y: frame.midY+250)
        addChild(GameShopTitleLabel)
        
        //Return button for going back to HomeScreen
        returnBtn = UIButton (frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        returnBtn.center = CGPoint(x: view.frame.midX-160, y: view.frame.midY-350)
        
        returnBtn.setTitle("Return", for: UIControlState.normal)
        returnBtn.setTitleColor(UIColor.red, for: UIControlState.normal)
        returnBtn.addTarget(self, action: #selector(MoreInfoScene.Return), for: UIControlEvents.touchUpInside)
        self.view!.addSubview(returnBtn)
    }
    
    //Return function to redirect scene to HomeScreen
    func Return(){
        //move to specified scene
        let scene = GameShop(fileNamed: "GameShop")
        //starting transition between scenes
        self.view?.presentScene(scene)
        returnBtn.removeFromSuperview()
    }
}
