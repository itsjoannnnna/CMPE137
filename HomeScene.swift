//
//  HomeScene.swift
//  shootingGame
//
//  Created by Jo-Anna Marie Reyes on 10/27/16.
//  Copyright © 2016 Jo-Anna Marie Reyes. All rights reserved.
//

import Foundation
import SpriteKit

class HomeScene : SKScene{
    var home : UILabel!
    
    override func didMove(to view: SKView) {
        NSLog("Home Screen")
        home = UILabel(frame: CGRect(x: 0, y:0, width: view.frame.size.width/3, height: 30))
        home.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.width/1)
        home.text = "Home Screen"
    }
}
