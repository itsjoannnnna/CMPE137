import SpriteKit
import GameplayKit

struct GameSixPhysicsCategory{
    static let Aliens: UInt32 = 1 //lets the last bit equal to 1
    static let Bullet: UInt32 = 2 // lets the last bits equal to 2
    static let Player: UInt32 = 3 //lets the last bits equal to 3
    static let Boss: UInt32 = 5
    static let AlienBullet: UInt32 = 6
}

class GameScene6: SKScene, SKPhysicsContactDelegate {
    
    var HighScore = Int()
    var Score = Int()
    var pauseButton: SKSpriteNode?
    var playButton: SKSpriteNode?
    let backgroundMusic = SKAudioNode(fileNamed: "NewYork.mp3")
    
    @IBInspectable
    var Player = SKSpriteNode(imageNamed: "rocket1.png")
    
    var ScoreLabel = UILabel()
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var bossMovementDirection: BossMovementDirection = .right
    var timeOfLastMove: CFTimeInterval = 0.0
    var timePerMove: CFTimeInterval = 1.0
    var contactQueue = [SKPhysicsContact]()
    var bossHealth: Float = 1.0
    var gameEnding: Bool = false
    let MinBossBottomHeight: Float = 32.0
    var contentCreated = false
    let BossName = "boss"
    let BossSize = CGSize(width: 50, height: 25)
    
    enum BossType {
        case a
        
        static var size: CGSize {
            return CGSize(width: 24, height: 16)
        }
        
        static var name: String {
            return "boss"
        }
    }
    
    enum BossMovementDirection {
        case right
        case left
        case downThenRight
        case downThenLeft
        case none
    }
    
    enum BulletType {
        case bossFired
    }
    
    let BossGridSpacing = CGSize(width: 12, height: 12)
    let BossRowCount = 1
    let BossColCount = 1
    let HealthHudName = "healthHud"
    let BossFiredBulletName = "bossFiredBullet"
    let BulletSize = CGSize(width:4, height:8)
    let ShipName = "ship"
    
    let BossCategory: UInt32 = 0x1 << 0
    let SceneEdgeCategory: UInt32 = 0x1 << 3
    let BossFiredBulletCategory: UInt32 = 0x1 << 4
    
    
    override func didMove(to view: SKView) {
        
        //Background Music
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        if(!self.contentCreated){
            self.createContent()
            self.contentCreated = true
        }
        
        playButton = childNode(withName: "playButton") as? SKSpriteNode
        playButton?.isHidden = true
        pauseButton = childNode(withName: "pauseButton") as? SKSpriteNode
        
        let HighscoreDefault = UserDefaults.standard
        if (HighscoreDefault.value(forKey: "Highscore") != nil){
            HighScore = HighscoreDefault.value(forKey: "Highscore") as! Int //as! NSInteger
        }
        else{
            HighScore = 0
        }
        
        physicsWorld.contactDelegate = self
        
        //background color for the playing field
        self.scene?.backgroundColor = UIColor.white
        
        
        
//        //positioning of the player in the field. makes it stay at the bottom of the string
//        Player.position = CGPoint(x: self.size.width/12, y: -self.frame.size.height/7.5)
//        Player.physicsBody = SKPhysicsBody(rectangleOf: Player.size)
//        Player.physicsBody?.affectedByGravity = false
//        
//        Player.physicsBody?.categoryBitMask = PhysicsCategory.Player
//        Player.physicsBody?.contactTestBitMask = PhysicsCategory.Boss
//        Player.physicsBody?.isDynamic = false
//        addChild(Player)
        
        //increasing the amount of time the bullets will come out of the rocket ship
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.shootBullets), userInfo: nil, repeats: true)
        
        
        
        //adds the score label to the top of the screen
        ScoreLabel.text = "\(Score)"
        ScoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        ScoreLabel.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.3)
        self.view?.addSubview(ScoreLabel)
        
    }
    
    func createContent(){
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody!.categoryBitMask = SceneEdgeCategory
        setupHud()
        setupBoss()
        setupPlayer()
        
        self.backgroundColor = SKColor.black
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody = contact.bodyA //takes first body that hits and do stuff with it
        let secondBody: SKPhysicsBody = contact.bodyB //takes second body that hits
        
        //checks if the bullets have hit the boss or boss hit bullets
        if((firstBody.categoryBitMask == PhysicsCategory.Boss && secondBody.categoryBitMask == PhysicsCategory.Bullet) || (firstBody.categoryBitMask == PhysicsCategory.Bullet && secondBody.categoryBitMask == PhysicsCategory.Boss)){
            
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            Score+=1
            ScoreLabel.text = "Score: \(Score)"
        }
            
            //checks if the boss hit the players, or player hits boss
        else if((firstBody.categoryBitMask == PhysicsCategory.AlienBullet && secondBody.categoryBitMask == PhysicsCategory.Player) || (firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.AlienBullet)){
            
            let scoreDefault = UserDefaults.standard
            scoreDefault.set(Score, forKey: "Score")
            scoreDefault.synchronize()
            if(Score > HighScore){
                let HighscoreDefault = UserDefaults.standard
                HighscoreDefault.set(Score, forKey: "Highscore")
            }
            
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            self.view?.presentScene(EndScene())
            ScoreLabel.removeFromSuperview()
        }
        
    }
    
    //makes boss look the way it does
    func loadBossTextures(ofType bossType: BossType) -> [SKTexture] {
        
        return [SKTexture(imageNamed: "InvaderA_00.png"),
                SKTexture(imageNamed: "InvaderA_01.png")]
    }
    
    func makeBoss() -> SKNode {
        let boss = SKSpriteNode(imageNamed: "alienboss.png")
        boss.name = BossName
        return boss
    }
    
    func setupPlayer() {
        Player.position = CGPoint(x: BossSize.width*5, y: (BossSize.height)*4)
        Player.physicsBody = SKPhysicsBody(rectangleOf: Player.size)
        Player.physicsBody?.affectedByGravity = false
        Player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        Player.physicsBody?.contactTestBitMask = PhysicsCategory.Boss
        Player.physicsBody?.isDynamic = false
        addChild(Player)
    }
    
    func setupBoss() {
        let boss = makeBoss()
        boss.position = CGPoint(x: BossSize.width*8, y: (BossSize.height-1)*24)
        addChild(boss)
    }
    
    //Health bar
    func setupHud() {
        let healthLabel = SKLabelNode(fontNamed: "Courier")
        healthLabel.name = HealthHudName
        healthLabel.fontSize = 25
        healthLabel.fontColor = SKColor.red
        healthLabel.text = String(format: "Health: %.1f%%", bossHealth * 100.0)
        healthLabel.position = CGPoint(
            x: frame.size.width/2,
            y: size.height - (40 + healthLabel.frame.size.height/2)
        )
        addChild(healthLabel)
    }
    
    func adjustBossHealth(by healthAdjustment: Float) {
        bossHealth = max(bossHealth + healthAdjustment, 0)
        
        if let health = childNode(withName: HealthHudName) as? SKLabelNode {
            health.text = String(format: "Health: %.1f%%", self.bossHealth * 100)
        }
    }
    
    func makeBullet(ofType bulletType: BulletType) -> SKNode {
        var bullet: SKNode
        
        switch bulletType {
        case .bossFired:
            bullet = SKSpriteNode(color: SKColor.green, size: BulletSize)
            bullet.name = BossFiredBulletName
            
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
            bullet.physicsBody!.isDynamic = true
            bullet.physicsBody!.affectedByGravity = false
            bullet.physicsBody!.categoryBitMask = BossFiredBulletCategory
            bullet.physicsBody!.contactTestBitMask = PhysicsCategory.Boss
            bullet.physicsBody!.collisionBitMask = 0x0
            break
        }
        return bullet
    }
    
    func moveBoss(forUpdate currentTime: CFTimeInterval) {
        if(currentTime - timeOfLastMove < timePerMove) {
            return
        }
        
        determineBossMovementDirection()
        
        enumerateChildNodes(withName: BossType.name) {
            node, stop in
            switch self.bossMovementDirection{
            case .right:
                node.position = CGPoint(x: node.position.x + 10, y: node.position.y)
            case .left:
                node.position = CGPoint(x: node.position.x - 10, y: node.position.y)
            case .downThenLeft, .downThenRight:
                node.position = CGPoint(x: node.position.x, y: node.position.y - 10)
            case .none:
                break
            }
            self.timeOfLastMove = currentTime
        }
    }
    
    func adjustBossMovement(to timePerMove: CFTimeInterval) {
        if self.timePerMove <= 0 {
            return
        }
        
        let ratio: CGFloat = CGFloat(self.timePerMove/timePerMove)
        self.timePerMove = timePerMove
        
        enumerateChildNodes(withName: BossType.name) {
            node, stop in
            node.speed = node.speed * ratio
        }
    }
    
    func fireBossBullets(forUpdate currentTime: CFTimeInterval) {
        let existingBullet = childNode(withName: BossFiredBulletName)
        
        if existingBullet == nil {
            var allBoss = [SKNode]()
            
            enumerateChildNodes(withName: BossType.name) {
                node, stop in
                allBoss.append(node)
            }
            
            if allBoss.count > 0 {
                let allBossIndex = Int(arc4random_uniform(UInt32(allBoss.count)))
                
                let boss = allBoss[allBossIndex]
                
                let bullet = makeBullet(ofType: .bossFired)
                bullet.position = CGPoint(
                    x: boss.position.x,
                    y: boss.position.y - boss.frame.size.height/2 + bullet.frame.size.height/2
                )
                
                let bulletDestination = CGPoint(x: boss.position.x, y: -(bullet.frame.size.height/2))
                
                fireBullet(
                    bullet: bullet,
                    toDestination: bulletDestination,
                    withDuration: 2.0
                )
            }
        }
    }
    
    func fireBullet(bullet: SKNode, toDestination destination: CGPoint, withDuration duration: CFTimeInterval) {
        let bulletAction = SKAction.sequence([
            SKAction.move(to: destination, duration: duration),
            SKAction.wait(forDuration: 3.0 / 60.0),
            SKAction.removeFromParent()
            ])
        
        bullet.run(SKAction.group([bulletAction]))
        addChild(bullet)
    }
    
    func processContacts(forUpdate currentTime: CFTimeInterval) {
        for contact in contactQueue {
            handle(contact)
            
            if let index = contactQueue.index(of: contact) {
                contactQueue.remove(at: index)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isGameOver() {
            endGame()
        }
        moveBoss(forUpdate: currentTime)
        fireBossBullets(forUpdate: currentTime)
        processContacts(forUpdate: currentTime)
    }
    
    func determineBossMovementDirection() {
        var proposedMovementDirection: BossMovementDirection = bossMovementDirection
        enumerateChildNodes(withName: BossType.name) {
            node, stop in
            switch self.bossMovementDirection {
            case .right:
                if(node.frame.maxX >= node.scene!.size.width - 1.0) {
                    proposedMovementDirection = .downThenLeft
                    
                    self.adjustBossMovement(to: self.timePerMove * 0.8)
                    stop.pointee = true
                }
            case .left:
                if(node.frame.minX <= 1.0) {
                    proposedMovementDirection = .downThenRight
                    
                    self.adjustBossMovement(to: self.timePerMove * 0.8)
                    
                    stop.pointee = true
                }
            case .downThenLeft:
                proposedMovementDirection = .left
                stop.pointee = true
                
            case .downThenRight:
                proposedMovementDirection = .right
                stop.pointee = true
                
            default:
                break
            }
        }
        if(proposedMovementDirection != bossMovementDirection) {
            bossMovementDirection = proposedMovementDirection
        }
    }
    
    func handle(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil {
            return
        }
        
        let nodeNames = [contact.bodyA.node!.name!, contact.bodyB.node!.name!]
        
        if nodeNames.contains(BossName) && nodeNames.contains(BossFiredBulletName) {
            //Boss bullet hit ship
            
            adjustBossHealth(by: -0.334)
            if bossHealth <= 0.0 {
                contact.bodyA.node!.removeFromParent()
                contact.bodyB.node!.removeFromParent()
            } else {
                if let boss = childNode(withName: BossType.name) {
                    boss.alpha = CGFloat(bossHealth)
                    
                    if contact.bodyA.node == boss {
                        contact.bodyB.node!.removeFromParent()
                    } else {
                        contact.bodyA.node!.removeFromParent()
                    }
                }
            }
        } else if nodeNames.contains(BossType.name) && nodeNames.contains(BossFiredBulletName) {
            contact.bodyA.node!.removeFromParent()
            contact.bodyB.node!.removeFromParent()
        }
    }

    func isGameOver() -> Bool {
        let boss = childNode(withName: BossType.name)
        
        var bossTooLow = false
        
        enumerateChildNodes(withName: BossType.name) {
            node, stop in
            if(Float(node.frame.minY) <= self.MinBossBottomHeight) {
                bossTooLow = true
                stop.pointee = true
            }
        }
        let ship = childNode(withName: ShipName)
        return boss == nil || bossTooLow || ship == nil
    }
    
    func endGame() {
        if !gameEnding {
            gameEnding = true
            
            //let gameOverScene: EndScene = EndScene(size: size)
            
            //view?.presentScene(gameOverScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1.0))
        }
    }
    
    //function to shoot the bullets from behind the rocketship
    func shootBullets(){
        let Bullet = SKSpriteNode(imageNamed: "bullet.png")
        Bullet.zPosition = -5
        Bullet.position = CGPoint(x: Player.position.x, y: Player.position.y)
        
        let shooting = SKAction.moveTo(y: self.size.height + 30, duration: 1.0)
        let shootingDone = SKAction.removeFromParent()
        Bullet.run(SKAction.sequence([shooting, shootingDone]))
        //Bullet.run(SKAction.repeatForever(shooting))
        
        Bullet.physicsBody = SKPhysicsBody(rectangleOf: Bullet.size)
        Bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        Bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Boss //bullets go away from the
        Bullet.physicsBody?.affectedByGravity = false // so the bullets don't fly off
        Bullet.physicsBody?.isDynamic = false
        self.addChild(Bullet)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let location = touch.location(in: self)
            Player.position.x = location.x
        }
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        //print(touchLocation)
        
        let nodes = self.atPoint(touchLocation)
        if nodes.name == "pauseButton" {
            let showPlayButtonAction = SKAction.run(showPlayButton)
            let pauseGameAction = SKAction.run(pauseGame)
            let pauseSequence = SKAction.sequence([showPlayButtonAction, pauseGameAction])
            run(pauseSequence)
            
        }
        else if nodes.name == "playButton"{
            self.resumeGame()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let location = touch.location(in: self)
            Player.position.x = location.x
        }
    }
    
    
    func pauseGame() {
        self.view!.isPaused = true
    }
    
    func resumeGame() {
        playButton!.isHidden = true
        pauseButton!.isHidden = false
        self.view?.isPaused = false
    }
    
    func showPlayButton() {
        pauseButton!.isHidden = true
        playButton!.isHidden = false
    }
}
