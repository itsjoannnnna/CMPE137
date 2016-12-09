//
//  MoreInfo.swift
//  shootingGame
//
//  Created by Jo-Anna Marie Reyes on 12/4/16.
//  Copyright © 2016 Jo-Anna Marie Reyes. All rights reserved.
//

import Foundation
import SpriteKit

class MoreInfoScene: SKScene {
    var returnBtn : UIButton!
    var moreInfoBtn : UIButton!
    var moreInfo: UILabel!
    var moreInfo2: UILabel!
    
    override func didMove(to view: SKView) {
        //Backgrount color
        //Adding Stars
        if let stars = SKEmitterNode(fileNamed: "movingStars") {
            stars.position = CGPoint(x: frame.size.width / 2, y: frame.size.height)
            stars.zPosition = -1
            addChild(stars)
        }
        //Background color
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
        
        //3 Shooter Button
        let ThreeShooterPic = SKSpriteNode(imageNamed: "threeShooter.png")
        ThreeShooterPic.position = CGPoint(x: frame.midX+70, y: frame.midY)
        addChild(ThreeShooterPic)
        //Return button for going back to HomeScreen
        moreInfoBtn = UIButton (frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        moreInfoBtn.center = CGPoint(x: view.frame.midX, y: view.frame.midY)
        
        moreInfo = UILabel(frame: CGRect(x: 0, y:0, width: view.frame.size.width/1.2, height: 30))
        moreInfo.center = CGPoint(x: view.frame.midX, y: view.frame.midY+50)
        moreInfo.textColor = UIColor.red
        moreInfo.text = "This item is a rare item,"
        self.view?.addSubview(moreInfo)
        
        moreInfo2 = UILabel(frame: CGRect(x: 0, y:0, width: view.frame.size.width/1.2, height: 30))
        moreInfo2.center = CGPoint(x: view.frame.midX, y: view.frame.midY+65)
        moreInfo2.textColor = UIColor.red
        moreInfo2.text = "and cannot be bought at this time."
        self.view?.addSubview(moreInfo2)
    }
    
    //Return function to redirect scene to HomeScreen
    func Return(){
        //move to specified scene
        let scene = GameScene(fileNamed: "GameScene")
        //starting transition between scenes
        self.view?.presentScene(scene)
        returnBtn.removeFromSuperview()
        moreInfo.removeFromSuperview()
        moreInfo2.removeFromSuperview()
        moreInfoBtn.removeFromSuperview()
    }
}
