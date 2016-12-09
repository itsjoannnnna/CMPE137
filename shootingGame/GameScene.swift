import UIKit
import SpriteKit
import GameplayKit
class GameScene: SKScene {
    
    //Buttons on the HomeScene
    override func didMove(to view: SKView) {
        self.scene?.backgroundColor = UIColor.black
        
        //Adding Stars
        if let stars = SKEmitterNode(fileNamed: "movingStars") {
            stars.position = CGPoint(x: frame.size.width / 2, y: frame.size.height)
            stars.zPosition = -1
            addChild(stars)
        }
        
        let titleLabel = SKSpriteNode(imageNamed: "title.png")
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY+250)
        addChild(titleLabel)
        
        //Start Game Button
        let startGameButton = SKSpriteNode(imageNamed: "StartButton1.png")
        startGameButton.position = CGPoint(x: frame.midX, y: frame.midY+100)
        startGameButton.name = "startgame"
        addChild(startGameButton)
        //Unlimited Game Button
        let unlimitedGameButton = SKSpriteNode(imageNamed: "special1.png")
        unlimitedGameButton.position = CGPoint(x: frame.midX, y: frame.midY)
        unlimitedGameButton.name = "unlimitedgame"
        addChild(unlimitedGameButton)
        //Game Shop Button
        let gameShopButton = SKSpriteNode(imageNamed: "shopButton1.png")
        gameShopButton.position = CGPoint(x: frame.midX, y: frame.midY-100)
        gameShopButton.name = "gameshop"
        addChild(gameShopButton)
        //Login/SignUp Button
        let loginSignButton = SKSpriteNode(imageNamed: "loginButton.png")
        loginSignButton.position = CGPoint(x: frame.midX, y: frame.midY-200)
        loginSignButton.name = "login"
        addChild(loginSignButton)
    }
    
    //When buttons are touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: self)
        let touchedNode = self.atPoint(touchLocation!)
        
        //Start Game Button goes to first GameScene
        if(touchedNode.name == "startgame"){
            let gameOverScene = IntroScene(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
        //Unlimited Gameplay Button goes to unlimited GameScene
        if(touchedNode.name == "unlimitedgame"){
            let gameOverScene = IntroScene2(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
        //CHANGE BACK TO SHOP
        //Game Shop Button goes to GameShop scene
        if(touchedNode.name == "gameshop"){
            let gameOverScene = GameShop(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
        //Login/Sign Up Button goes to Login scene
        if(touchedNode.name == "login"){
            //CHANGE BACK TO LOGIN
            let gameOverScene = LoginScene(size: size)
            gameOverScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
            view?.presentScene(gameOverScene,transition: transitionType)
        }
    }
}
