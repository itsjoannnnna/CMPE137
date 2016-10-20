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
    
    override func didMove(to view: SKView) {
        scene?.backgroundColor = UIColor.white
        restartBtn = UIButton (frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        restartBtn.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/7)
        
        
        restartBtn.setTitle("Restart", for: UIControlState.normal)
        restartBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        restartBtn.addTarget(self, action: #selector(EndScene.Restart), for: UIControlEvents.touchUpInside)
        self.view?.addSubview(restartBtn)
    }
    
    func Restart(){
        self.view?.presentScene(GameScene(), transition: SKTransition.crossFade(withDuration: 0.3))
        restartBtn.removeFromSuperview()
    }
}
