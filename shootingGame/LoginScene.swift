//
//  LoginScene.swift
//  shootingGame
//
//  Created by Jo-Anna Marie Reyes on 12/2/16.
//  Copyright © 2016 Jo-Anna Marie Reyes. All rights reserved.
//

import Foundation
import SpriteKit

class LoginScene : SKScene {
    var returnBtn : UIButton!
    var signUpBtn : UIButton!
    
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
        
        let GameShopTitleLabel = SKSpriteNode(imageNamed: "Login2.png")
        GameShopTitleLabel.position = CGPoint(x: frame.midX, y: frame.midY+250)
        addChild(GameShopTitleLabel)
        
        //Return button for going back to HomeScreen
        returnBtn = UIButton (frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        returnBtn.center = CGPoint(x: view.frame.midX-160, y: view.frame.midY-350)
        
        returnBtn.setTitle("Return", for: UIControlState.normal)
        returnBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        returnBtn.addTarget(self, action: #selector(GameShop.Return), for: UIControlEvents.touchUpInside)
        self.view!.addSubview(returnBtn)
        
        //Return button for going back to HomeScreen
        signUpBtn = UIButton (frame: CGRect(x: 0, y:0, width: view.frame.size.width, height: 30))
        signUpBtn.center = CGPoint(x: frame.midX, y: frame.midY+200)
        
        signUpBtn.setTitle("No account? Sign up here!", for: UIControlState.normal)
        signUpBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        signUpBtn.addTarget(self, action: #selector(LoginScene.SignUp), for: UIControlEvents.touchUpInside)
        self.view!.addSubview(signUpBtn)
    }
    
    //Return function to redirect scene to HomeScreen
    func Return(){
        //move to specified scene
        let scene = GameScene(fileNamed: "GameScene")
        //starting transition between scenes
        self.view?.presentScene(scene)
        returnBtn.removeFromSuperview()
        signUpBtn.removeFromSuperview()
    }
    func SignUp(){
        let scene = SignUpScene(fileNamed: "SignUpScene")
        self.view?.presentScene(scene)
        signUpBtn.removeFromSuperview()
        returnBtn.removeFromSuperview()
    }
}
