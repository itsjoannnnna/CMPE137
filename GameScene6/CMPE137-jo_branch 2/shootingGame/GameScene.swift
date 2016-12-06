import UIKit
import SpriteKit
import GameplayKit
class GameScene: SKScene {
    
    //Buttons on the HomeScene
    override func didMove(to view: SKView) {
        //Start Game Button
        let startGameButton = SKSpriteNode(imageNamed: "StartButton.png")
        startGameButton.position = CGPoint(x: frame.midX, y: frame.midY+100)
        startGameButton.name = "startgame"
        addChild(startGameButton)
        //Unlimited Game Button
        let unlimitedGameButton = SKSpriteNode(imageNamed: "StartButton.png")
        unlimitedGameButton.position = CGPoint(x: frame.midX, y: frame.midY)
        unlimitedGameButton.name = "unlimitedgame"
        addChild(unlimitedGameButton)
        //Game Shop Button
        let gameShopButton = SKSpriteNode(imageNamed: "StartButton.png")
        gameShopButton.position = CGPoint(x: frame.midX, y: frame.midY-100)
        gameShopButton.name = "gameshop"
        addChild(gameShopButton)
        
    }
    
    //When buttons are touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        let touchedNode = self.atPoint(touchLocation!)
        
        //Start Game Button goes to first GameScene
        if(touchedNode.name == "startgame"){
            let gameOverScene = GameScene1(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
        //Unlimited Gameplay Button goes to unlimited GameScene
        if(touchedNode.name == "unlimitedgame"){
            let gameOverScene = GameScene6(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
        //Game Shop Button goes to GameShop scene
        if(touchedNode.name == "gameshop"){
            let gameOverScene = GameShop(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
    }
}
